import Foundation
import Testing
@testable import ClauchiCore

// tool-use(능동 작업) 급식 — Claude가 도구를 쓸 때마다 소량 급식 (사용자 요청).
// Stop(식사)보다 적게 주고, 분당 상한으로 폭주를 막는다.

@Test func toolUseFeedsExpAndSatiety() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 50, level: 15))
    _ = engine.handle(ClaudeEvent(ts: TestSupport.weekday9am, event: .toolUse,
                                  sessionId: "s1", cwd: nil))
    #expect(engine.state.pet.satiety == 52)   // +satietyPerToolUse(2)
    #expect(engine.state.pet.exp == 1)         // +expPerToolUse(1)
}

@Test func toolUseExpRespectsPerMinuteCap() {
    // 같은 분 안에 toolUse를 많이 보내도 EXP는 분당 상한(6)까지만
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 100, level: 15, exp: 0))
    let t = TestSupport.weekday9am
    for index in 0..<10 {
        _ = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(Double(index)),
                                      event: .toolUse, sessionId: "s1", cwd: nil))
    }
    #expect(engine.state.pet.exp == 6)   // toolUseExpGainCapPerMinute
}

@Test func toolUseGrowsEggTowardHatch() {
    // 사용자 시나리오: 알도 능동 작업(toolUse)으로 부화에 가까워진다
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(stage: .egg, level: 0, exp: 0))
    _ = engine.handle(ClaudeEvent(ts: TestSupport.weekday9am, event: .toolUse,
                                  sessionId: "s1", cwd: nil))
    #expect(engine.state.pet.exp == 1)
    #expect(engine.state.pet.stage == .egg)
}

@Test func toolUseSatietySharesPerMinuteCapWithStop() {
    // 포만감은 Stop과 같은 분당 캡(20)을 공유 — 함께 먹어도 분당 20을 넘지 않는다
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 0, level: 15))
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))                    // 포만감 +10
    for index in 0..<10 {                                             // toolUse +2 × 5회면 +10에서 캡
        _ = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(Double(index + 1)),
                                      event: .toolUse, sessionId: "s1", cwd: nil))
    }
    #expect(engine.state.pet.satiety == 20)   // 10(stop) + 10(toolUse, 캡 도달)
}
