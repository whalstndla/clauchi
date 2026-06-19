import Foundation

public enum VisualState: String, Equatable, Sendable {
    case egg, idle, working, sleeping, hungry, critical, playing, vacation
}

public enum DialogueSituation: String, Equatable, Sendable, CaseIterable {
    case greeting, returnGreeting, levelUp, hatched, evolvedToAdult, graduated, died
    case hungryWarning, criticalWarning, permissionWaiting, longWorkBreak
    case randomChatter, vacationReturn, petted, rerolled, promptReaction
    case manualFed, talked, streakMilestone, lateNightWork, weekendWork, workMilestone
}

public enum EngineOutput: Equatable, Sendable {
    case speak(DialogueSituation)
    case reactToPrompt(String, Date)     // 프롬프트 텍스트 + 이벤트 시각 — 리플레이 신선도 필터용 (스펙 §3)
    case hatched(Species)
    case leveledUp(Int)
    case petGraduated(CollectionRecord)
    case petDied(CollectionRecord)
    case petted                          // 쓰다듬기 성공 — UI 하트 이펙트용
}

public enum DebugCommand: Sendable {
    case setSatiety(Double)
    case grantExp(Int)
}

// 순수 상태 머신 — 시계(이벤트 ts/tick now), 달력, 랜덤을 전부 주입받는다.
// UI/파일시스템을 모른다. (CLAUDE.md 코드 규칙)
public final class PetEngine {
    public private(set) var state: GameState
    public let config: GameConfig
    private let hatchPool: [Species]
    private let calendar: Calendar
    private let random: () -> Double

    private var lastTickAt: Date?
    private var recentSatietyGains: [(at: Date, amount: Double)] = []
    private var recentToolExpGains: [(at: Date, amount: Int)] = []
    private var recentMoodGains: [(at: Date, amount: Double)] = []
    private var workingUntil: Date?
    private var hungryWarned: Bool
    private var lastNotificationSpokeAt: Date?
    private var lastPromptReactionAt: Date?
    private var lastManualFeedAt: Date?

    public init(config: GameConfig = .default, state: GameState,
                hatchPool: [Species], calendar: Calendar = .current,
                random: @escaping () -> Double = { Double.random(in: 0..<1) }) {
        self.config = config
        self.state = state
        self.hatchPool = hatchPool
        self.calendar = calendar
        self.random = random
        self.hungryWarned = state.pet.satiety <= config.hungryThreshold
    }

    // 첫 실행: 새 게임(첫 알)
    public static func newGameState(now: Date, hatchPool: [Species],
                                    random: () -> Double = { Double.random(in: 0..<1) }) -> GameState {
        GameState(version: 1,
                  pet: newEgg(collection: [], pool: hatchPool, now: now, random: random),
                  collection: [], settings: .default, eventLogOffset: 0,
                  lastChatterAt: nil, lastActivityAt: nil, continuousWorkStartedAt: nil)
    }

    // 새 알 — 아직 졸업 못한 종 중 랜덤. 죽은 종은 재도전 가능 (스펙 §5).
    // excluding: 리세마라 시 직전 종 제외 (후보가 그것뿐이면 허용)
    static func newEgg(collection: [CollectionRecord], pool: [Species],
                       now: Date, random: () -> Double,
                       excluding: Species? = nil) -> PetState {
        let graduatedSpecies = Set(collection.filter { $0.result == .graduated }.map(\.species))
        var candidates = pool.filter { !graduatedSpecies.contains($0) }
        if let excluding, candidates.count > 1 {
            candidates.removeAll { $0 == excluding }
        }
        if candidates.isEmpty { candidates = pool }
        let index = min(Int(random() * Double(candidates.count)), candidates.count - 1)
        // random 두 번째 소비 — 종 결정 후 성격 결정 (순서 변경 시 기존 테스트의 결정값이 바뀜)
        return PetState(species: candidates[index], stage: .egg, level: 0, exp: 0,
                        satiety: 100, mood: 80, bornAt: now,
                        criticalAccumulatedSeconds: 0,
                        personality: Personality.random(random))
    }

    // 이름 변경 — 트림 후 빈 문자열이면 기본 이름 복귀, 12자 초과는 앞 12자 (스펙 §2.2)
    public func renamePet(_ rawName: String) {
        let trimmed = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        state.pet.customName = trimmed.isEmpty ? nil : String(trimmed.prefix(12))
    }

    // 리세마라 — rerollLockLevel 미만에서만 새 알로 다시 뽑기. 기록을 남기지 않는다 (스펙 §5)
    public func reroll(now: Date) -> [EngineOutput] {
        guard state.pet.level < config.rerollLockLevel else { return [] }
        state.pet = Self.newEgg(collection: state.collection, pool: hatchPool,
                                now: now, random: random, excluding: state.pet.species)
        hungryWarned = false
        return [.speak(.rerolled)]
    }

    // 조기 졸업 — rerollLockLevel 이상에서만. 현재 펫을 도감에 졸업(.graduated)으로 남기고
    // 새 알로 교체한다. 30레벨 자연 졸업과 도감상 동일하게 ⭐로 취급 (스펙 2026-06-16).
    public func graduateEarly(now: Date) -> [EngineOutput] {
        guard state.pet.level >= config.rerollLockLevel else { return [] }
        return graduate(now: now)
    }

    // 펫 일지에 하이라이트 한 줄 기록 — 상한 초과 시 오래된 것부터 버린다
    private func logEvent(_ text: String, now: Date) {
        state.petLog.append(PetLogEntry(date: now, text: text))
        if state.petLog.count > config.petLogMaxEntries {
            state.petLog.removeFirst(state.petLog.count - config.petLogMaxEntries)
        }
    }

    // 연속 사용일(스트릭) 갱신 — 같은 날 재호출은 무시, 다음 날이면 +1, 하루 이상 비면 1로 리셋.
    // 마일스톤(GameConfig.streakMilestones)에 새로 도달하면 true 반환 → 축하 대사 트리거.
    private func updateStreak(now: Date) -> Bool {
        let today = calendar.startOfDay(for: now)
        guard let lastDay = state.lastStreakDay else {
            state.streakDays = 1
            state.lastStreakDay = today
            return config.streakMilestones.contains(1)
        }
        let lastStart = calendar.startOfDay(for: lastDay)
        let dayGap = calendar.dateComponents([.day], from: lastStart, to: today).day ?? 0
        if dayGap <= 0 { return false }            // 같은 날(또는 과거) — 변화 없음
        state.streakDays = dayGap == 1 ? state.streakDays + 1 : 1   // 연속이면 +1, 끊겼으면 리셋
        state.lastStreakDay = today
        return config.streakMilestones.contains(state.streakDays)
    }

    // 오늘 작업 수 갱신 — 날짜가 바뀌면 0으로 리셋 후 1, 같은 날이면 +1
    private func updateTodayStops(now: Date) {
        let today = calendar.startOfDay(for: now)
        if let day = state.todayStopsDay, calendar.isDate(day, inSameDayAs: today) {
            state.todayStops += 1
        } else {
            state.todayStops = 1
            state.todayStopsDay = today
        }
    }

    public func handle(_ event: ClaudeEvent) -> [EngineOutput] {
        var outputs: [EngineOutput] = []
        let now = event.ts
        switch event.event {
        case .sessionStart:
            if updateStreak(now: now) {
                outputs.append(.speak(.streakMilestone))
                logEvent("\(state.streakDays)일 연속 사용 달성 🔥", now: now)
            }
            // 심야 > 주말 > 일반 인사 순으로 한 가지 인사만 선택
            if config.lateNightHours.contains(calendar.component(.hour, from: now)) {
                outputs.append(.speak(.lateNightWork))
            } else if config.weekendWeekdays.contains(calendar.component(.weekday, from: now)) {
                outputs.append(.speak(.weekendWork))
            } else if let last = state.lastActivityAt {
                let gap = now.timeIntervalSince(last)
                if gap >= config.returnGreetingAfterSeconds {
                    outputs.append(.speak(.returnGreeting))
                } else if gap >= config.greetingGapSeconds {
                    outputs.append(.speak(.greeting))
                }
            } else {
                outputs.append(.speak(.greeting))
            }
        case .toolUse:
            workingUntil = now.addingTimeInterval(config.workingWindowSeconds)
            if state.continuousWorkStartedAt == nil { state.continuousWorkStartedAt = now }
            outputs.append(contentsOf: applyToolUseFeeding(now: now))
        case .stop:
            state.lifetimeStops += 1
            updateTodayStops(now: now)
            if config.workMilestones.contains(state.lifetimeStops) {
                outputs.append(.speak(.workMilestone))
                logEvent("누적 작업 \(state.lifetimeStops)회 달성 🎉", now: now)
            }
            outputs.append(contentsOf: applyFeeding(now: now))
        case .notification:
            let cooldownOver = lastNotificationSpokeAt
                .map { now.timeIntervalSince($0) >= config.notificationSpeakCooldownSeconds } ?? true
            if cooldownOver {
                outputs.append(.speak(.permissionWaiting))
                lastNotificationSpokeAt = now
            }
        case .userPrompt:
            if let prompt = event.prompt,
               !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let cooldownOver = lastPromptReactionAt
                    .map { now.timeIntervalSince($0) >= config.promptReactionCooldownSeconds } ?? true
                if cooldownOver {
                    outputs.append(.reactToPrompt(prompt, now))
                    lastPromptReactionAt = now
                }
            }
        }
        state.lastActivityAt = now
        return outputs
    }

    // Stop = 밥 — 분당 상한 적용 (스펙 §5)
    private func applyFeeding(now: Date) -> [EngineOutput] {
        recentSatietyGains.removeAll { now.timeIntervalSince($0.at) >= 60 }
        let gainedLastMinute = recentSatietyGains.reduce(0) { $0 + $1.amount }
        let allowed = max(0, config.satietyGainCapPerMinute - gainedLastMinute)
        let gain = min(config.satietyPerStop, allowed)
        if gain > 0 {
            state.pet.satiety = min(100, state.pet.satiety + gain)
            recentSatietyGains.append((at: now, amount: gain))
            state.pet.criticalAccumulatedSeconds = 0
            if state.pet.satiety > config.hungryThreshold { hungryWarned = false }
        }
        // 밥은 기분도 조금 올린다 (알은 제외). 행복하면 EXP 보너스 (스펙 §5)
        if state.pet.stage != .egg {
            state.pet.mood = min(100, state.pet.mood + config.moodPerStop)
        }
        let happyBonus = state.pet.mood >= config.moodHappyThreshold
            ? config.happyExpBonusPerStop : 0
        return applyExpGain(config.expPerStop + happyBonus, now: now)
    }

    // tool-use = 능동 작업 급식 — Claude가 도구를 쓸 때마다 소량 (사용자 요청).
    // 포만감은 Stop과 같은 분당 캡(satietyGainCapPerMinute)을 공유하고, EXP는 전용 캡을 둬 폭주를 막는다.
    private func applyToolUseFeeding(now: Date) -> [EngineOutput] {
        recentSatietyGains.removeAll { now.timeIntervalSince($0.at) >= 60 }
        let satietyLastMinute = recentSatietyGains.reduce(0) { $0 + $1.amount }
        let satietyAllowed = max(0, config.satietyGainCapPerMinute - satietyLastMinute)
        let satietyGain = min(config.satietyPerToolUse, satietyAllowed)
        if satietyGain > 0 {
            state.pet.satiety = min(100, state.pet.satiety + satietyGain)
            recentSatietyGains.append((at: now, amount: satietyGain))
            state.pet.criticalAccumulatedSeconds = 0
            if state.pet.satiety > config.hungryThreshold { hungryWarned = false }
        }
        recentToolExpGains.removeAll { now.timeIntervalSince($0.at) >= 60 }
        let expLastMinute = recentToolExpGains.reduce(0) { $0 + $1.amount }
        let expAllowed = max(0, config.toolUseExpGainCapPerMinute - expLastMinute)
        let expGain = min(config.expPerToolUse, expAllowed)
        guard expGain > 0 else { return [] }
        recentToolExpGains.append((at: now, amount: expGain))
        return applyExpGain(expGain, now: now)
    }

    // 쓰다듬기 — 패널의 펫 클릭 (스펙 §5). 알은 반응하지 않는다
    public func petPet(now: Date) -> [EngineOutput] {
        guard state.pet.stage != .egg else { return [] }
        state.lifetimePets += 1
        recentMoodGains.removeAll { now.timeIntervalSince($0.at) >= 60 }
        let gainedLastMinute = recentMoodGains.reduce(0) { $0 + $1.amount }
        let allowed = max(0, config.moodGainCapPerMinute - gainedLastMinute)
        let gain = min(config.moodPerPet, allowed)
        var outputs: [EngineOutput] = [.petted]
        if gain > 0 {
            state.pet.mood = min(100, state.pet.mood + gain)
            recentMoodGains.append((at: now, amount: gain))
            if random() < 0.3 { outputs.append(.speak(.petted)) }
        }
        return outputs
    }

    // 수동 밥주기 — 5분 쿨다운, 알 단계 제외 (포만감만 채우고 EXP는 없음)
    public func manualFeed(now: Date) -> [EngineOutput] {
        guard state.pet.stage != .egg else { return [] }
        if let last = lastManualFeedAt,
           now.timeIntervalSince(last) < config.manualFeedCooldownSeconds { return [] }
        lastManualFeedAt = now
        state.lifetimeManualFeeds += 1
        state.pet.satiety = min(100, state.pet.satiety + config.satietyPerManualFeed)
        state.pet.criticalAccumulatedSeconds = 0
        if state.pet.satiety > config.hungryThreshold { hungryWarned = false }
        return [.speak(.manualFed)]
    }

    // 남은 쿨다운 초 (0이면 즉시 가능)
    public func manualFeedCooldownRemaining(now: Date) -> TimeInterval {
        guard let last = lastManualFeedAt else { return 0 }
        return max(0, config.manualFeedCooldownSeconds - now.timeIntervalSince(last))
    }

    // EXP 획득 → 부화/레벨업/진화/졸업 (스펙 §5 생애 주기)
    private func applyExpGain(_ amount: Int, now: Date) -> [EngineOutput] {
        var outputs: [EngineOutput] = []
        state.pet.exp += amount
        switch state.pet.stage {
        case .egg:
            if state.pet.exp >= config.hatchExp {
                state.pet.stage = .baby
                state.pet.level = 1
                state.pet.exp = 0
                state.pet.mood = min(100, state.pet.mood + config.moodPerStageChange)
                outputs.append(.hatched(state.pet.species))
                outputs.append(.speak(.hatched))
                logEvent("부화 — \(state.pet.species.koreanName) 탄생 🐣", now: now)
            }
        case .baby, .adult:
            while state.pet.exp >= config.expToNextLevel(from: state.pet.level) {
                state.pet.exp -= config.expToNextLevel(from: state.pet.level)
                state.pet.level += 1
                state.pet.mood = min(100, state.pet.mood + config.moodPerLevelUp)
                outputs.append(.leveledUp(state.pet.level))
                outputs.append(.speak(.levelUp))
                if state.pet.level % 10 == 0 {   // 10단위 레벨만 일지에 기록(매 레벨은 과함)
                    logEvent("Lv.\(state.pet.level) 달성 ⬆️", now: now)
                }
                if state.pet.stage == .baby && state.pet.level >= config.adultLevel {
                    state.pet.stage = .adult
                    state.pet.mood = min(100, state.pet.mood + config.moodPerStageChange)
                    outputs.append(.speak(.evolvedToAdult))
                    logEvent("성체로 성장 (Lv.\(state.pet.level)) 🌟", now: now)
                }
                if state.pet.stage == .adult && state.pet.level >= config.graduateLevel {
                    outputs.append(contentsOf: graduate(now: now))
                    break
                }
            }
        }
        return outputs
    }

    private func graduate(now: Date) -> [EngineOutput] {
        let record = CollectionRecord(species: state.pet.species, result: .graduated,
                                      daysLived: daysLived(now: now),
                                      finalLevel: state.pet.level, endedAt: now,
                                      customName: state.pet.customName,
                                      personality: state.pet.personality)
        state.collection.append(record)
        logEvent("졸업 🎓 \(record.species.koreanName) Lv.\(record.finalLevel)", now: now)
        state.pet = Self.newEgg(collection: state.collection, pool: hatchPool,
                                now: now, random: random)
        hungryWarned = false
        return [.petGraduated(record), .speak(.graduated)]
    }

    private func daysLived(now: Date) -> Int {
        max(0, calendar.dateComponents([.day], from: state.pet.bornAt, to: now).day ?? 0)
    }

    private func die(now: Date) -> [EngineOutput] {
        let record = CollectionRecord(species: state.pet.species, result: .died,
                                      daysLived: daysLived(now: now),
                                      finalLevel: state.pet.level, endedAt: now,
                                      customName: state.pet.customName,
                                      personality: state.pet.personality)
        state.collection.append(record)
        logEvent("사망 🪦 \(record.species.koreanName) Lv.\(record.finalLevel)", now: now)
        state.pet = Self.newEgg(collection: state.collection, pool: hatchPool,
                                now: now, random: random)
        hungryWarned = false
        return [.petDied(record), .speak(.died)]
    }

    // 1초 주기로 호출되는 시간 틱.
    // 델타를 캡 — 잠자기/앱 정지 공백은 흐르지 않은 시간으로 취급 (스펙 §5)
    public func tick(now: Date) -> [EngineOutput] {
        guard let last = lastTickAt else { lastTickAt = now; return [] }
        guard now > last else { return [] }
        let delta = min(now.timeIntervalSince(last), config.tickDeltaCapSeconds)
        lastTickAt = now
        var outputs: [EngineOutput] = []

        // 연속 작업 추적 — 1시간 넘으면 휴식 권유 (스펙 §5)
        if let until = workingUntil {
            if now.timeIntervalSince(until) > 300 {
                workingUntil = nil
                state.continuousWorkStartedAt = nil
            } else if let workStart = state.continuousWorkStartedAt,
                      now.timeIntervalSince(workStart) >= config.longWorkSeconds {
                outputs.append(.speak(.longWorkBreak))
                state.continuousWorkStartedAt = now
            }
        }

        // 포만감 감쇠 — 알 단계/휴식 시간/근무 외 시간엔 정지
        if state.pet.stage != .egg && !isRestTime(now: now) && !isOutsideWorkHours(now: now) {
            let satietyBefore = state.pet.satiety
            state.pet.satiety = max(0, satietyBefore - config.satietyDecayPerHour * delta / 3600)
            if !hungryWarned && state.pet.satiety <= config.hungryThreshold && state.pet.satiety > 0 {
                hungryWarned = true
                outputs.append(.speak(.hungryWarning))
            }
            if state.pet.satiety == 0 {
                if satietyBefore > 0 { outputs.append(.speak(.criticalWarning)) }
                state.pet.criticalAccumulatedSeconds += delta
                if state.pet.criticalAccumulatedSeconds >= config.criticalSecondsToDeath {
                    outputs.append(contentsOf: die(now: now))
                    return outputs
                }
            }
        }

        // 기분 변화 — 평시 감소, 배고프면 가속, 휴일엔 회복, 휴가엔 동결 (스펙 §5)
        if state.pet.stage != .egg {
            if state.settings.vacationMode {
                // 휴가: 동결
            } else if isRestTime(now: now) {
                state.pet.mood = min(100, state.pet.mood + config.moodRestGainPerHour * delta / 3600)
            } else if isOutsideWorkHours(now: now) {
                // 근무 외 — 펫도 같이 취침, 기분 동결(회복도 감소도 없음)
            } else {
                var moodDecayPerHour = config.moodDecayPerHour
                if state.pet.satiety <= config.hungryThreshold {
                    moodDecayPerHour += config.moodExtraDecayWhenHungryPerHour
                }
                state.pet.mood = max(0, state.pet.mood - moodDecayPerHour * delta / 3600)
            }
        }

        // 랜덤 잡담 — 쿨다운 후 평균 10분 내 발화 (설정 off/휴가/알/배고픔 제외).
        // 배고플 땐 명랑한 잡담 대신 배고픔 경고가 상태를 대변한다(톤 일관성).
        if state.settings.randomChatterEnabled && !state.settings.vacationMode
            && state.pet.stage != .egg && state.pet.satiety > config.hungryThreshold {
            let cooldownOver = state.lastChatterAt
                .map { now.timeIntervalSince($0) >= config.chatterCooldownSeconds } ?? true
            if cooldownOver && random() < delta / 600 {
                state.lastChatterAt = now
                outputs.append(.speak(.randomChatter))
            }
        }
        return outputs
    }

    // 주말 휴식 또는 휴가 모드 (스펙 §5 휴식 예외)
    private func isRestTime(now: Date) -> Bool {
        state.settings.vacationMode
            || state.settings.restWeekdays.contains(calendar.component(.weekday, from: now))
    }

    // 근무시간 밖인가 — 기능이 켜져 있고 현재 시각이 [출근, 퇴근) 범위 밖이면 true.
    // 자정을 넘기는 야간근무(출근>퇴근, 예: 22~6시)도 지원. 출근==퇴근이면 24시간 근무로 간주(항상 false).
    private func isOutsideWorkHours(now: Date) -> Bool {
        let settings = state.settings
        guard settings.workHoursEnabled, settings.workStartHour != settings.workEndHour
        else { return false }
        let hour = calendar.component(.hour, from: now)
        let start = settings.workStartHour
        let end = settings.workEndHour
        let working = start < end
            ? (hour >= start && hour < end)        // 예: 9~18 → 9..17시 근무
            : (hour >= start || hour < end)        // 예: 22~6 → 22,23,0..5시 근무
        return !working
    }

    // UI 표시 상태 — 우선순위: 휴가 > 알 > 위독 > 배고픔 > 휴일놀기 > 작업 > 잠 > 대기 (스펙 §7)
    public func visualState(now: Date) -> VisualState {
        if state.settings.vacationMode { return .vacation }
        if state.pet.stage == .egg { return .egg }
        if state.pet.satiety == 0 { return .critical }
        if state.pet.satiety <= config.hungryThreshold { return .hungry }
        if isRestTime(now: now) { return .playing }
        if let until = workingUntil, until > now { return .working }
        if isOutsideWorkHours(now: now) { return .sleeping }   // 근무 외 — 펫도 같이 취침(Zzz)
        if let last = state.lastActivityAt,
           now.timeIntervalSince(last) >= config.sleepAfterIdleSeconds { return .sleeping }
        return .idle
    }

    public func setVacation(_ on: Bool) -> [EngineOutput] {
        let wasOn = state.settings.vacationMode
        state.settings.vacationMode = on
        if wasOn && !on { return [.speak(.vacationReturn)] }
        return []
    }

    public func updateSettings(_ settings: GameSettings) { state.settings = settings }

    // 앱이 이벤트 로그 처리 위치를 상태에 반영할 때 사용
    public func setEventLogOffset(_ offset: UInt64) { state.eventLogOffset = offset }

    // 디버그 빨리감기 — 시계만 옮기면 델타 캡이 점프를 "잠자기"로 취급해 무시하므로,
    // 캡 단위로 tick을 반복해 실제 시간 경과를 시뮬레이션한다 (스펙 §11)
    public func debugAdvance(seconds: TimeInterval, from now: Date) -> [EngineOutput] {
        if lastTickAt == nil { _ = tick(now: now) }
        guard let baseline = lastTickAt else { return [] }
        var outputs: [EngineOutput] = []
        let step = config.tickDeltaCapSeconds
        var current = baseline
        let end = baseline.addingTimeInterval(seconds)
        while current < end {
            current = min(current.addingTimeInterval(step), end)
            outputs.append(contentsOf: tick(now: current))
        }
        return outputs
    }

    // 테스트 전용 — 성격 고정(기록 복사 검증용)
    public func debugSetPersonality(_ personality: Personality) {
        state.pet.personality = personality
    }

    // 디버그 메뉴 전용 (스펙 §11)
    public func debugApply(_ command: DebugCommand, now: Date) -> [EngineOutput] {
        switch command {
        case .setSatiety(let value):
            state.pet.satiety = max(0, min(100, value))
            if state.pet.satiety > 0 { state.pet.criticalAccumulatedSeconds = 0 }
            return []
        case .grantExp(let amount):
            return applyExpGain(amount, now: now)
        }
    }
}
