import Foundation
import Testing
@testable import ClauchiCore

// 누적 통계·스트릭은 '계정 단위' — 펫이 졸업/리세마라로 교체돼도 유지되어야 한다

@Test func lifetimeStatsSurviveGraduation() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 50, stage: .adult, level: 12))
    let t = TestSupport.weekday9am
    _ = engine.handle(ClaudeEvent(ts: t, event: .sessionStart, sessionId: "s", cwd: nil))
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(60)))
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(120)))

    let stopsBefore = engine.state.lifetimeStops
    let streakBefore = engine.state.streakDays
    #expect(stopsBefore == 2)
    #expect(streakBefore == 1)

    _ = engine.graduateEarly(now: t.addingTimeInterval(200))   // 펫 교체

    #expect(engine.state.pet.stage == .egg)                    // 펫은 새 알로 교체
    #expect(engine.state.lifetimeStops == stopsBefore)         // 누적은 유지
    #expect(engine.state.streakDays == streakBefore)           // 스트릭도 유지
}

@Test func lifetimeStatsSurviveReroll() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 50, stage: .baby, level: 3))
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))
    let before = engine.state.lifetimeStops
    _ = engine.reroll(now: t.addingTimeInterval(10))           // 리세마라(기록 없는 교체)
    #expect(engine.state.lifetimeStops == before)              // 누적 유지
}
