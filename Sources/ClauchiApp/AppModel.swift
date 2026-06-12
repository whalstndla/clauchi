import AppKit
import Observation
import ClauchiCore

extension Notification.Name {
    static let clauchiHoverChanged = Notification.Name("clauchiHoverChanged")
    static let clauchiPanelToggled = Notification.Name("clauchiPanelToggled")
}

@MainActor
@Observable
final class AppModel {
    let clock = AppClock()
    let engine: PetEngine
    let store: PersistenceStore
    let reader: EventLogReader
    let toastPresenter = ToastPresenter()
    let updateService = UpdateService()
    private var updateTimer: Timer?
    var dialogueProvider: any DialogueProviding

    private(set) var visualState: VisualState = .idle
    private(set) var frameIndex = 0
    // PetEngine은 @Observable이 아니라서 설정 변경이 SwiftUI에 전파되지 않는다 —
    // 뷰가 읽을 관찰용 스냅샷을 둔다
    private(set) var settings: GameSettings = .default
    private(set) var heartBurst = 0   // 쓰다듬기 하트 이펙트 트리거
    var isHovering = false {
        didSet { NotificationCenter.default.post(name: .clauchiHoverChanged, object: nil) }
    }
    var isPanelOpen = false {
        didSet { NotificationCenter.default.post(name: .clauchiPanelToggled, object: nil) }
    }

    private var timer: Timer?
    private var autosaveCounter = 0
    private(set) var startedFreshAfterCorruption = false   // 스펙 §10: 손상 복구 실패 알림용

    init() {
        let directory = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".clauchi")
        store = PersistenceStore(directory: directory)
        let loaded = store.load()
        if loaded == nil, FileManager.default.fileExists(atPath: store.stateURL.path) {
            startedFreshAfterCorruption = true   // 파일은 있는데 백업까지 못 읽음 (스펙 §10)
        }
        let loadedState = loaded
            ?? PetEngine.newGameState(now: Date(), hatchPool: SpriteLibrary.implementedSpecies)
        engine = PetEngine(state: loadedState, hatchPool: SpriteLibrary.implementedSpecies)

        let logURL = directory.appendingPathComponent("events.jsonl")
        reader = EventLogReader(fileURL: logURL, offset: loadedState.eventLogOffset)
        // 로그 비대 방지 — 전부 처리된 5MB 초과 로그는 비운다 (스펙 §9).
        // 동시에 훅이 append 중이면 한 줄 정도 유실 가능 — 허용 범위
        if reader.offset > 5_000_000,
           let attributes = try? FileManager.default.attributesOfItem(atPath: logURL.path),
           (attributes[.size] as? UInt64) == reader.offset {
            try? Data().write(to: logURL)
            reader.resetOffset()
            engine.setEventLogOffset(0)
        }

        dialogueProvider = TemplateDialogueProvider()

        // 손상 복구 실패 → 새 게임 사과 토스트 (스펙 §10)
        if startedFreshAfterCorruption {
            let pet = engine.state.pet
            toastPresenter.enqueue(ToastPresenter.Toast(
                text: "이전 기록을 읽지 못해서 새로 시작했어... 미안!",
                expression: .sad, species: pet.species, stage: pet.stage))
        }
        settings = engine.state.settings
        refreshDialogueProvider()
        updateService.onReadyToApply = { [weak self] in self?.notifyUpdateReady() }
        updateService.check()                 // 실행 시 1회
        startUpdateTimer()                     // 이후 6시간마다
        startTimer()
    }

    // 설정에 따라 AI/템플릿 프로바이더 선택 (스펙 §6)
    func refreshDialogueProvider() {
        if engine.state.settings.dialogueAIEnabled {
            dialogueProvider = FoundationModelsDialogueProvider(fallback: TemplateDialogueProvider())
            FoundationModelsDialogueProvider.warmUp()
        } else {
            dialogueProvider = TemplateDialogueProvider()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tickNow() }
        }
    }

    // 6시간마다 업데이트 확인 (스펙 §4.4)
    private func startUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 6 * 3600, repeats: true) {
            [weak self] _ in
            Task { @MainActor in self?.updateService.check() }
        }
    }

    // 업데이트 준비됨 → 펫 말풍선 토스트 (스펙 §4.5)
    private func notifyUpdateReady() {
        let pet = engine.state.pet
        toastPresenter.enqueue(ToastPresenter.Toast(
            text: "새 버전 준비됐어! 재시작하면 적용돼 🔄",
            expression: .happy, species: pet.species, stage: pet.stage))
    }

    private func tickNow() {
        let now = clock.now()
        var outputs: [EngineOutput] = []
        for event in reader.readNewEvents() { outputs += engine.handle(event) }
        engine.setEventLogOffset(reader.offset)
        outputs += engine.tick(now: now)
        visualState = engine.visualState(now: now)
        if settings != engine.state.settings { settings = engine.state.settings }
        frameIndex += 1
        process(outputs)
        autosaveCounter += 1
        if autosaveCounter >= 60 {   // 0.5초 틱 × 60 = 30초마다 자동 저장
            autosaveCounter = 0
            saveNow()
        }
    }

    // 엔진 출력 → 토스트.
    // 주의: died/graduated 시점엔 엔진의 pet이 이미 새 알로 교체돼 있다 —
    // 반드시 record 기반으로 토스트를 만든다 (speak(.died/.graduated)는 여기서 무시)
    private func process(_ outputs: [EngineOutput]) {
        for output in outputs {
            switch output {
            case .speak(let situation):
                if situation == .died || situation == .graduated { break }
                speakToast(situation: situation)
            case .petDied(let record):
                recordToast(record: record, situation: .died, expression: .critical)
            case .petGraduated(let record):
                recordToast(record: record, situation: .graduated, expression: .happy)
            case .hatched, .leveledUp:
                break   // 동반되는 speak 출력이 토스트를 담당
            case .petted:
                heartBurst += 1   // 하트 이펙트 트리거
            case .reactToPrompt(let promptText, let at):
                // 오프라인 백로그 리플레이 — 오래된 프롬프트엔 반응하지 않는다
                if clock.now().timeIntervalSince(at) <= engine.config.promptReactionFreshnessSeconds {
                    promptReactionToast(promptText: promptText)
                }
            }
        }
    }

    // 쓰다듬기 — 패널의 펫 클릭 (스펙 §5)
    func petPet() {
        process(engine.petPet(now: clock.now()))
    }

    // 수동 밥주기 — 패널의 밥 주기 버튼
    func manualFeed() {
        process(engine.manualFeed(now: clock.now()))
        saveNow()
    }

    var manualFeedCooldownRemaining: TimeInterval {
        engine.manualFeedCooldownRemaining(now: clock.now())
    }

    // 말걸기 — 펫과 대화. 채팅 내용을 userPrompt로 담아 AI가 맥락 있게 반응
    func talkToPet(message: String) {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, engine.state.pet.stage != .egg else { return }
        let pet = engine.state.pet
        let context = DialogueContext(
            situation: .talked, petName: pet.displayName,
            stage: pet.stage, level: pet.level,
            satiety: Int(pet.satiety), mood: Int(pet.mood),
            userPrompt: trimmed,
            species: pet.species, personality: pet.personality)
        enqueueDialogueToast(context: context, expression: .happy,
                             species: pet.species, stage: pet.stage)
    }

    private func speakToast(situation: DialogueSituation) {
        let pet = engine.state.pet
        let context = DialogueContext(
            situation: situation, petName: pet.displayName,
            stage: pet.stage, level: pet.level, satiety: Int(pet.satiety),
            mood: Int(pet.mood),
            species: pet.species, personality: pet.personality)
        let expression: ClauchiCore.Expression = switch situation {
        case .criticalWarning: .critical
        case .hungryWarning, .longWorkBreak: .sad
        default: .happy
        }
        enqueueDialogueToast(context: context, expression: expression,
                             species: pet.species, stage: pet.stage)
    }

    // 주인의 프롬프트에 펫이 한마디 (스펙 §3)
    private func promptReactionToast(promptText: String) {
        let pet = engine.state.pet
        let context = DialogueContext(
            situation: .promptReaction, petName: pet.displayName,
            stage: pet.stage, level: pet.level, satiety: Int(pet.satiety),
            mood: Int(pet.mood), userPrompt: promptText,
            species: pet.species, personality: pet.personality)
        enqueueDialogueToast(context: context, expression: .happy,
                             species: pet.species, stage: pet.stage)
    }

    private func recordToast(record: CollectionRecord, situation: DialogueSituation,
                             expression: ClauchiCore.Expression) {
        let context = DialogueContext(
            situation: situation, petName: record.customName ?? record.species.koreanName,
            stage: .adult, level: record.finalLevel,
            satiety: situation == .died ? 0 : 100,
            species: record.species, personality: record.personality ?? .cheerful)
        enqueueDialogueToast(context: context, expression: expression,
                             species: record.species, stage: .adult)
    }

    private func enqueueDialogueToast(context: DialogueContext, expression: ClauchiCore.Expression,
                                      species: Species, stage: Stage) {
        let provider = dialogueProvider
        Task { @MainActor in
            let text = await provider.line(for: context)
            toastPresenter.enqueue(ToastPresenter.Toast(
                text: text, expression: expression, species: species, stage: stage))
        }
    }

    func saveNow() {
        try? store.save(engine.state)
    }

    // 설정/디버그 진입점
    func applySettings(_ newSettings: GameSettings) {
        engine.updateSettings(newSettings)
        settings = engine.state.settings
        saveNow()
    }
    func toggleVacation(_ on: Bool) {
        process(engine.setVacation(on))
        settings = engine.state.settings
        saveNow()
    }
    // 리세마라 — 알/아기 단계에서 새 알 다시 뽑기 (스펙 §5)
    func reroll() {
        process(engine.reroll(now: clock.now()))
        saveNow()
    }

    // 이름 변경 — 엔진 검증(트림·12자) 후 즉시 저장
    func renamePet(_ name: String) {
        engine.renamePet(name)
        saveNow()
    }
}
