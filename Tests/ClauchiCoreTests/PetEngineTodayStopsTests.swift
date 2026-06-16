import Foundation
import Testing
@testable import ClauchiCore

// 오늘의 작업 수 — 같은 날 누적, 날짜 바뀌면 리셋
private func stop(at date: Date) -> ClaudeEvent { TestSupport.stopEvent(at: date) }
private let day: TimeInterval = 24 * 3600

@Test func todayStopsAccumulatesSameDay() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    let t = TestSupport.weekday9am
    _ = engine.handle(stop(at: t))
    _ = engine.handle(stop(at: t.addingTimeInterval(3600)))
    #expect(engine.state.todayStops == 2)
}

@Test func todayStopsResetsNextDay() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    let t = TestSupport.weekday9am
    _ = engine.handle(stop(at: t))
    _ = engine.handle(stop(at: t.addingTimeInterval(3600)))   // 오늘 2
    _ = engine.handle(stop(at: t.addingTimeInterval(day)))    // 다음 날 → 리셋 후 1
    #expect(engine.state.todayStops == 1)
    #expect(engine.state.lifetimeStops == 3)                  // 누적은 계속 증가
}
