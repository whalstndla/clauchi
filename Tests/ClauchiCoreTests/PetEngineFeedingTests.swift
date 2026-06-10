import Foundation
import Testing
@testable import ClauchiCore

@Test func stopEventFeedsAndGivesExp() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    #expect(engine.state.pet.satiety == 60)   // +10
    #expect(engine.state.pet.exp == 5)        // +5
}

@Test func satietyCapsAt100() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 95))
    _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    #expect(engine.state.pet.satiety == 100)
}

@Test func gainCapPerMinuteBlocksThirdStop() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 10))
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))                          // +10
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(10)))   // +10 (분당 20 도달)
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(20)))   // +0 (상한)
    #expect(engine.state.pet.satiety == 30)
    #expect(engine.state.pet.exp == 15)       // EXP는 상한 없음
}

@Test func gainCapWindowSlides() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 10))
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(10)))
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(61)))   // 첫 획득이 창 밖으로
    #expect(engine.state.pet.satiety == 40)
}

@Test func eventsUpdateLastActivity() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(ClaudeEvent(ts: t, event: .toolUse, sessionId: "s1", cwd: nil))
    #expect(engine.state.lastActivityAt == t)
}
