import Foundation
import Testing
@testable import ClauchiCore

@Test func firstSessionStartGreets() {
    let engine = TestSupport.makeEngine()
    let outputs = engine.handle(ClaudeEvent(ts: TestSupport.weekday9am,
                                            event: .sessionStart, sessionId: "s1", cwd: nil))
    #expect(outputs.contains(.speak(.greeting)))
}

@Test func quickSecondSessionDoesNotGreet() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(ClaudeEvent(ts: t, event: .sessionStart, sessionId: "s1", cwd: nil))
    let outputs = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(60),
                                            event: .sessionStart, sessionId: "s2", cwd: nil))
    #expect(!outputs.contains(.speak(.greeting)))
}

@Test func returnGreetingAfterEightHours() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(TestSupport.stopEvent(at: t))
    let outputs = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(9 * 3600),
                                            event: .sessionStart, sessionId: "s2", cwd: nil))
    #expect(outputs.contains(.speak(.returnGreeting)))
}

@Test func notificationSpeaksWithCooldown() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    let first = engine.handle(ClaudeEvent(ts: t, event: .notification, sessionId: "s1", cwd: nil))
    let second = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(60),
                                           event: .notification, sessionId: "s1", cwd: nil))
    let third = engine.handle(ClaudeEvent(ts: t.addingTimeInterval(400),
                                          event: .notification, sessionId: "s1", cwd: nil))
    #expect(first.contains(.speak(.permissionWaiting)))
    #expect(!second.contains(.speak(.permissionWaiting)))   // 5분 쿨다운
    #expect(third.contains(.speak(.permissionWaiting)))
}

@Test func longWorkSpeaksAfterOneHour() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    var outputs: [EngineOutput] = []
    _ = engine.tick(now: t)
    var current = t
    // 25초마다 toolUse(작업 유지) + 5초 틱 → 1시간 연속 작업
    while current < t.addingTimeInterval(3700) {
        current = current.addingTimeInterval(5)
        if Int(current.timeIntervalSince(t)) % 25 == 0 {
            _ = engine.handle(ClaudeEvent(ts: current, event: .toolUse, sessionId: "s1", cwd: nil))
        }
        outputs += engine.tick(now: current)
    }
    #expect(outputs.filter { $0 == .speak(.longWorkBreak) }.count == 1)
}

@Test func randomChatterRespectsCooldownAndRandom() {
    // random = 0.99 → 절대 발화 안 함
    let silentEngine = TestSupport.makeEngine(random: { 0.99 })
    let silent = runTicks(silentEngine, from: TestSupport.weekday9am, duration: 3600)
    #expect(!silent.contains(.speak(.randomChatter)))

    // random = 0 → 쿨다운만 지나면 즉시 발화
    let chattyEngine = TestSupport.makeEngine(random: { 0 })
    let chatty = runTicks(chattyEngine, from: TestSupport.weekday9am, duration: 3600)
    #expect(chatty.filter { $0 == .speak(.randomChatter) }.count >= 1)
    // 쿨다운(30분) 내 중복 발화 없음
    #expect(chatty.filter { $0 == .speak(.randomChatter) }.count <= 2)
}
