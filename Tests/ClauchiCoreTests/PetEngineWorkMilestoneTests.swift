import Foundation
import Testing
@testable import ClauchiCore

// 누적 작업 마일스톤 — 기본 workMilestones=[100,...]. 100번째 Stop에서 축하 대사

@Test func hundredthStopEmitsWorkMilestone() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    let t = TestSupport.weekday9am
    var last: [EngineOutput] = []
    for i in 0..<100 {
        last = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(Double(i))))
    }
    #expect(engine.state.lifetimeStops == 100)
    #expect(last.contains(.speak(.workMilestone)))
}

@Test func nonMilestoneStopHasNoWorkMilestone() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50))
    let outputs = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))  // 1회
    #expect(engine.state.lifetimeStops == 1)
    #expect(!outputs.contains(.speak(.workMilestone)))
}
