import Foundation
import Testing
@testable import ClauchiCore

@Test func decodesJSONLLine() throws {
    let line = #"{"ts":"2026-06-10T10:24:31Z","event":"stop","sessionId":"abc123","cwd":"/tmp/proj"}"#
    let event = ClaudeEvent.fromJSONLine(Data(line.utf8))
    #expect(event?.event == .stop)
    #expect(event?.sessionId == "abc123")
    #expect(event?.cwd == "/tmp/proj")
}

@Test func malformedLineReturnsNil() {
    #expect(ClaudeEvent.fromJSONLine(Data("not json".utf8)) == nil)
    #expect(ClaudeEvent.fromJSONLine(Data(#"{"event":"unknown-kind"}"#.utf8)) == nil)
}

@Test func encodeProducesSingleLine() throws {
    let event = ClaudeEvent(ts: Date(timeIntervalSince1970: 1_780_000_000),
                            event: .toolUse, sessionId: "s1", cwd: nil)
    let line = try event.jsonLine()
    #expect(!line.contains("\n"))
    #expect(ClaudeEvent.fromJSONLine(Data(line.utf8))?.event == .toolUse)
}

@Test func decodesUserPromptLine() {
    let line = #"{"ts":"2026-06-10T10:24:31Z","event":"user-prompt","sessionId":"abc","prompt":"버그 수정해줘"}"#
    let event = ClaudeEvent.fromJSONLine(Data(line.utf8))
    #expect(event?.event == .userPrompt)
    #expect(event?.prompt == "버그 수정해줘")
}

@Test func promptFieldDefaultsToNilOnOldLines() {
    let line = #"{"ts":"2026-06-10T10:24:31Z","event":"stop","sessionId":"abc"}"#
    #expect(ClaudeEvent.fromJSONLine(Data(line.utf8))?.prompt == nil)
}
