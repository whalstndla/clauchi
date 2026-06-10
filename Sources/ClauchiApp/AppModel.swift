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
    var dialogueProvider: any DialogueProviding

    private(set) var visualState: VisualState = .idle
    private(set) var frameIndex = 0
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

        dialogueProvider = TemplateDialogueProvider()   // Task 21에서 FM 프로바이더로 교체

        // 손상 복구 실패 → 새 게임 사과 토스트 (스펙 §10)
        if startedFreshAfterCorruption {
            let pet = engine.state.pet
            toastPresenter.enqueue(ToastPresenter.Toast(
                text: "이전 기록을 읽지 못해서 새로 시작했어... 미안!",
                expression: .sad, species: pet.species, stage: pet.stage))
        }
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tickNow() }
        }
    }

    private func tickNow() {
        let now = clock.now()
        var outputs: [EngineOutput] = []
        for event in reader.readNewEvents() { outputs += engine.handle(event) }
        engine.setEventLogOffset(reader.offset)
        outputs += engine.tick(now: now)
        visualState = engine.visualState(now: now)
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
            }
        }
    }

    private func speakToast(situation: DialogueSituation) {
        let pet = engine.state.pet
        let context = DialogueContext(
            situation: situation, petName: pet.species.koreanName,
            stage: pet.stage, level: pet.level, satiety: Int(pet.satiety))
        let expression: ClauchiCore.Expression = switch situation {
        case .criticalWarning: .critical
        case .hungryWarning, .longWorkBreak: .sad
        default: .happy
        }
        enqueueDialogueToast(context: context, expression: expression,
                             species: pet.species, stage: pet.stage)
    }

    private func recordToast(record: CollectionRecord, situation: DialogueSituation,
                             expression: ClauchiCore.Expression) {
        let context = DialogueContext(
            situation: situation, petName: record.species.koreanName,
            stage: .adult, level: record.finalLevel,
            satiety: situation == .died ? 0 : 100)
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

    // 설정/디버그 진입점 (Task 20에서 UI 연결)
    func applySettings(_ settings: GameSettings) {
        engine.updateSettings(settings)
        saveNow()
    }
    func toggleVacation(_ on: Bool) {
        process(engine.setVacation(on))
        saveNow()
    }
    func debugFastForward(_ seconds: TimeInterval) { clock.fastForward(seconds) }
    func debugInject(_ kind: ClaudeEventKind) {
        process(engine.handle(ClaudeEvent(ts: clock.now(), event: kind,
                                          sessionId: "debug", cwd: nil)))
    }
    func debugCommand(_ command: DebugCommand) {
        process(engine.debugApply(command, now: clock.now()))
    }
}
