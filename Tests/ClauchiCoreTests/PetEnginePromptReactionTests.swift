import Foundation
import Testing
@testable import ClauchiCore

private func promptEvent(at date: Date, prompt: String?) -> ClaudeEvent {
    ClaudeEvent(ts: date, event: .userPrompt, sessionId: "s1", cwd: nil, prompt: prompt)
}

@Test func reactsToPromptWithText() {
    let engine = TestSupport.makeEngine()
    let outputs = engine.handle(promptEvent(at: TestSupport.weekday9am, prompt: "버그 수정"))
    #expect(outputs.contains(.reactToPrompt("버그 수정")))
}

@Test func cooldownSuppressesThenRecovers() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(promptEvent(at: t, prompt: "첫 작업"))
    let second = engine.handle(promptEvent(at: t.addingTimeInterval(30), prompt: "둘째 작업"))
    let third = engine.handle(promptEvent(at: t.addingTimeInterval(120), prompt: "셋째 작업"))
    #expect(!second.contains(.reactToPrompt("둘째 작업")))   // 90초 쿨다운 내
    #expect(third.contains(.reactToPrompt("셋째 작업")))     // 쿨다운 경과
}

@Test func blankOrMissingPromptDoesNotReact() {
    let engine = TestSupport.makeEngine()
    let missing = engine.handle(promptEvent(at: TestSupport.weekday9am, prompt: nil))
    let blank = engine.handle(promptEvent(at: TestSupport.weekday9am.addingTimeInterval(200),
                                          prompt: "   "))
    #expect(missing.isEmpty)
    #expect(blank.isEmpty)
}

@Test func promptEventUpdatesLastActivity() {
    let engine = TestSupport.makeEngine()
    _ = engine.handle(promptEvent(at: TestSupport.weekday9am, prompt: "작업"))
    #expect(engine.state.lastActivityAt == TestSupport.weekday9am)
}
