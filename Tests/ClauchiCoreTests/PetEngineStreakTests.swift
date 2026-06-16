import Foundation
import Testing
@testable import ClauchiCore

// 연속 사용일(스트릭) — 같은 날 무시 / 다음 날 +1 / 하루 이상 공백 시 리셋 / 마일스톤 대사

private func sessionStart(at date: Date) -> ClaudeEvent {
    ClaudeEvent(ts: date, event: .sessionStart, sessionId: "s1", cwd: nil)
}
private let oneDay: TimeInterval = 24 * 3600

@Test func firstSessionStartsStreakAtOne() {
    let engine = TestSupport.makeEngine()
    _ = engine.handle(sessionStart(at: TestSupport.weekday9am))
    #expect(engine.state.streakDays == 1)
}

@Test func sameDayDoesNotIncrementStreak() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(sessionStart(at: t))
    _ = engine.handle(sessionStart(at: t.addingTimeInterval(3600)))   // 같은 날 1시간 뒤
    #expect(engine.state.streakDays == 1)
}

@Test func nextDayIncrementsStreak() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(sessionStart(at: t))
    _ = engine.handle(sessionStart(at: t.addingTimeInterval(oneDay)))  // 다음 날
    #expect(engine.state.streakDays == 2)
}

@Test func gapResetsStreak() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(sessionStart(at: t))
    _ = engine.handle(sessionStart(at: t.addingTimeInterval(oneDay)))      // 2
    _ = engine.handle(sessionStart(at: t.addingTimeInterval(3 * oneDay)))  // 하루 건너뜀 → 리셋
    #expect(engine.state.streakDays == 1)
}

@Test func reachingMilestoneEmitsSpeak() {
    // 기본 streakMilestones = [3, ...] — 3일 연속 도달 시 축하 대사
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(sessionStart(at: t))                            // 1
    _ = engine.handle(sessionStart(at: t.addingTimeInterval(oneDay))) // 2
    let day3 = engine.handle(sessionStart(at: t.addingTimeInterval(2 * oneDay))) // 3
    #expect(engine.state.streakDays == 3)
    #expect(day3.contains(.speak(.streakMilestone)))
}

@Test func nonMilestoneDayHasNoStreakSpeak() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(sessionStart(at: t))                              // 1 (마일스톤 아님)
    let day2 = engine.handle(sessionStart(at: t.addingTimeInterval(oneDay))) // 2 (마일스톤 아님)
    #expect(!day2.contains(.speak(.streakMilestone)))
}

// 심야(0~4시) 세션 시작은 일반 인사 대신 밤샘 걱정 인사
@Test func lateNightSessionGreetsWithLateNightLine() {
    let engine = TestSupport.makeEngine()
    let twoAM = TestSupport.weekday9am.addingTimeInterval(-7 * 3600)   // 09:00 - 7h = 02:00 UTC
    let outputs = engine.handle(sessionStart(at: twoAM))
    #expect(outputs.contains(.speak(.lateNightWork)))
    #expect(!outputs.contains(.speak(.greeting)))
}

@Test func daytimeSessionDoesNotTriggerLateNight() {
    let engine = TestSupport.makeEngine()
    let outputs = engine.handle(sessionStart(at: TestSupport.weekday9am))  // 09:00
    #expect(!outputs.contains(.speak(.lateNightWork)))
}
