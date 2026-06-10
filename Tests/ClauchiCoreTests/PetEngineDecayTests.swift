import Foundation
import Testing
@testable import ClauchiCore

// 5초 간격으로 duration 만큼 tick을 돌리는 헬퍼
@discardableResult
func runTicks(_ engine: PetEngine, from start: Date,
              duration: TimeInterval, step: TimeInterval = 5) -> [EngineOutput] {
    var outputs: [EngineOutput] = []
    _ = engine.tick(now: start)   // 첫 틱은 기준점만 잡음
    var t = start
    let end = start.addingTimeInterval(duration)
    while t < end {
        t = min(t.addingTimeInterval(step), end)
        outputs.append(contentsOf: engine.tick(now: t))
    }
    return outputs
}

@Test func satietyDecaysTenPerHour() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 100))
    runTicks(engine, from: TestSupport.weekday9am, duration: 3600)
    #expect(abs(engine.state.pet.satiety - 90) < 0.1)
}

@Test func sleepGapIsCappedNotCounted() {
    // 2시간 공백(잠자기) 후 틱 — 델타 캡 5초만 반영돼야 함 (스펙 §5 휴식 예외)
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 100))
    let t = TestSupport.weekday9am
    _ = engine.tick(now: t)
    _ = engine.tick(now: t.addingTimeInterval(7200))
    #expect(engine.state.pet.satiety > 99.9)
}

@Test func hungryWarningFiresOnceOnCrossing() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 21))
    let outputs = runTicks(engine, from: TestSupport.weekday9am, duration: 3600)
    #expect(outputs.filter { $0 == .speak(.hungryWarning) }.count == 1)
}

@Test func criticalWarningFiresWhenReachingZero() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 1))
    let outputs = runTicks(engine, from: TestSupport.weekday9am, duration: 3600)
    #expect(outputs.contains(.speak(.criticalWarning)))
    #expect(engine.state.pet.satiety == 0)
    #expect(engine.state.pet.criticalAccumulatedSeconds > 0)
}

@Test func feedingWhileCriticalResetsDeathTimer() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 1))
    let t = TestSupport.weekday9am
    runTicks(engine, from: t, duration: 3600)
    #expect(engine.state.pet.criticalAccumulatedSeconds > 0)
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(3700)))
    #expect(engine.state.pet.criticalAccumulatedSeconds == 0)
}

@Test func eggDoesNotStarve() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 100, stage: .egg, level: 0))
    runTicks(engine, from: TestSupport.weekday9am, duration: 3600)
    #expect(engine.state.pet.satiety == 100)
}
