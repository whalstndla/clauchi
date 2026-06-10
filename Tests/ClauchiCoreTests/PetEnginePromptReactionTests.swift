import Foundation
import Testing
@testable import ClauchiCore

private func promptEvent(at date: Date, prompt: String?) -> ClaudeEvent {
    ClaudeEvent(ts: date, event: .userPrompt, sessionId: "s1", cwd: nil, prompt: prompt)
}

@Test func reactsToPromptWithText() {
    let engine = TestSupport.makeEngine()
    let outputs = engine.handle(promptEvent(at: TestSupport.weekday9am, prompt: "버그 수정"))
    // 출력에 이벤트 ts가 그대로 실리는지도 함께 검증 — 리플레이 신선도 필터의 전제
    #expect(outputs.contains(.reactToPrompt("버그 수정", TestSupport.weekday9am)))
}

@Test func cooldownSuppressesThenRecovers() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(promptEvent(at: t, prompt: "첫 작업"))
    let second = engine.handle(promptEvent(at: t.addingTimeInterval(30), prompt: "둘째 작업"))
    let third = engine.handle(promptEvent(at: t.addingTimeInterval(120), prompt: "셋째 작업"))
    #expect(!second.contains(.reactToPrompt("둘째 작업", t.addingTimeInterval(30))))   // 90초 쿨다운 내
    #expect(third.contains(.reactToPrompt("셋째 작업", t.addingTimeInterval(120))))    // 쿨다운 경과
}

@Test func cooldownBoundaryExactlyAtNinetySecondsReacts() {
    let engine = TestSupport.makeEngine()
    let t = TestSupport.weekday9am
    _ = engine.handle(promptEvent(at: t, prompt: "첫 작업"))
    // 쿨다운 조건이 >= 이므로 정확히 90초 경계에서는 반응해야 한다
    let boundary = engine.handle(promptEvent(at: t.addingTimeInterval(90), prompt: "경계 작업"))
    #expect(boundary.contains(.reactToPrompt("경계 작업", t.addingTimeInterval(90))))
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
