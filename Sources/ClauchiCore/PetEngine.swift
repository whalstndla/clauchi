import Foundation

public enum VisualState: String, Equatable, Sendable {
    case egg, idle, working, sleeping, hungry, critical, playing, vacation
}

public enum DialogueSituation: String, Equatable, Sendable {
    case greeting, returnGreeting, levelUp, hatched, evolvedToAdult, graduated, died
    case hungryWarning, criticalWarning, permissionWaiting, longWorkBreak
    case randomChatter, vacationReturn
}

public enum EngineOutput: Equatable, Sendable {
    case speak(DialogueSituation)
    case hatched(Species)
    case leveledUp(Int)
    case petGraduated(CollectionRecord)
    case petDied(CollectionRecord)
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
    private var workingUntil: Date?
    private var hungryWarned: Bool
    private var lastNotificationSpokeAt: Date?

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

    // 새 알 생성 (부화 풀 필터링은 Task 6에서 확장)
    static func newEgg(collection: [CollectionRecord], pool: [Species],
                       now: Date, random: () -> Double) -> PetState {
        let index = min(Int(random() * Double(pool.count)), pool.count - 1)
        return PetState(species: pool[index], stage: .egg, level: 0, exp: 0,
                        satiety: 100, bornAt: now, criticalAccumulatedSeconds: 0)
    }

    public func handle(_ event: ClaudeEvent) -> [EngineOutput] {
        var outputs: [EngineOutput] = []
        let now = event.ts
        switch event.event {
        case .sessionStart:
            break   // Task 9에서 인사 구현
        case .toolUse:
            break   // Task 8에서 작업 상태 구현
        case .stop:
            outputs.append(contentsOf: applyFeeding(now: now))
        case .notification:
            break   // Task 9에서 구현
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
        return applyExpGain(config.expPerStop, now: now)
    }

    // EXP 획득 (레벨업/부화/진화/졸업은 Task 6에서 확장)
    private func applyExpGain(_ amount: Int, now: Date) -> [EngineOutput] {
        state.pet.exp += amount
        return []
    }
}
