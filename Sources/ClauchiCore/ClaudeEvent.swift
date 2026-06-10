import Foundation

public enum ClaudeEventKind: String, Codable, Equatable, Sendable {
    case sessionStart = "session-start"
    case toolUse = "tool-use"
    case stop = "stop"
    case notification = "notification"
}

// clauchi-hook 이 기록하고 앱이 읽는 events.jsonl 한 줄
public struct ClaudeEvent: Codable, Equatable, Sendable {
    public var ts: Date
    public var event: ClaudeEventKind
    public var sessionId: String
    public var cwd: String?
    public init(ts: Date, event: ClaudeEventKind, sessionId: String, cwd: String?) {
        self.ts = ts; self.event = event; self.sessionId = sessionId; self.cwd = cwd
    }

    // 깨진 줄은 nil — 호출부가 조용히 건너뛴다 (스펙 §10)
    public static func fromJSONLine(_ data: Data) -> ClaudeEvent? {
        try? JSONDecoder.clauchi.decode(ClaudeEvent.self, from: data)
    }

    public func jsonLine() throws -> String {
        String(decoding: try JSONEncoder.clauchi.encode(self), as: UTF8.self)
    }
}
