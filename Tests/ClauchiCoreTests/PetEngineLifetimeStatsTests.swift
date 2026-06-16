import Foundation
import Testing
@testable import ClauchiCore

// 누적 업적 카운터 — Stop/수동급식 횟수를 펫 생애와 무관하게 영구 집계

@Test func stopIncrementsLifetimeStops() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(60)))
    #expect(engine.state.lifetimeStops == 2)
}

@Test func manualFeedIncrementsLifetimeFeeds() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 30))
    _ = engine.manualFeed(now: TestSupport.weekday9am)
    #expect(engine.state.lifetimeManualFeeds == 1)
}

@Test func manualFeedOnCooldownDoesNotCount() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 30))
    let t = TestSupport.weekday9am
    _ = engine.manualFeed(now: t)                              // 1회
    _ = engine.manualFeed(now: t.addingTimeInterval(10))       // 쿨다운 중 → 무시
    #expect(engine.state.lifetimeManualFeeds == 1)
}

@Test func eggManualFeedDoesNotCount() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .egg, level: 0))
    _ = engine.manualFeed(now: TestSupport.weekday9am)
    #expect(engine.state.lifetimeManualFeeds == 0)
}

@Test func petPetIncrementsLifetimePets() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(mood: 50))
    let t = TestSupport.weekday9am
    _ = engine.petPet(now: t)
    _ = engine.petPet(now: t.addingTimeInterval(1))
    #expect(engine.state.lifetimePets == 2)
}

@Test func eggPetPetDoesNotCount() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(stage: .egg, level: 0))
    _ = engine.petPet(now: TestSupport.weekday9am)
    #expect(engine.state.lifetimePets == 0)
}
