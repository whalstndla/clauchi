import Foundation
@testable import ClauchiCore

// 테스트 공용 헬퍼 — UTC 고정 달력, 결정적 랜덤
enum TestSupport {
    static var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    // 2026-06-10(수) 09:00 UTC — 평일 기준 시각
    static let weekday9am = Date(timeIntervalSince1970: 1_781_082_000)

    static func makeState(satiety: Double = 100, stage: Stage = .adult,
                          level: Int = 15, exp: Int = 0,
                          species: Species = .tiger,
                          settings: GameSettings = GameSettings(
                              restWeekdays: [], vacationMode: false,
                              dialogueAIEnabled: true, launchAtLogin: false),
                          collection: [CollectionRecord] = [],
                          mood: Double = 50,   // 중립 — 행복 보너스 미발동 기준
                          now: Date = weekday9am) -> GameState {
        GameState(version: 1,
                  pet: PetState(species: species, stage: stage, level: level, exp: exp,
                                satiety: satiety, mood: mood, bornAt: now,
                                criticalAccumulatedSeconds: 0),
                  collection: collection, settings: settings, eventLogOffset: 0,
                  lastChatterAt: nil, lastActivityAt: nil, continuousWorkStartedAt: nil)
    }

    static func makeEngine(state: GameState? = nil,
                           hatchPool: [Species] = [.rat, .ox, .tiger, .rabbit],
                           random: @escaping () -> Double = { 0 }) -> PetEngine {
        PetEngine(state: state ?? makeState(), hatchPool: hatchPool,
                  calendar: utcCalendar, random: random)
    }

    static func stopEvent(at date: Date, session: String = "s1") -> ClaudeEvent {
        ClaudeEvent(ts: date, event: .stop, sessionId: session, cwd: nil)
    }
}
