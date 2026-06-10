import Foundation
import ClauchiCore

// Claude Code 훅 → events.jsonl 한 줄 append.
// 절대 Claude Code를 방해하지 않는다: 모든 실패를 조용히 무시하고 항상 exit 0,
// stdout에 아무것도 쓰지 않는다 (검증된 훅 동작: exit 0 + stdout 없음 = 무간섭)
func run() {
    guard CommandLine.arguments.count >= 2,
          let kind = ClaudeEventKind(rawValue: CommandLine.arguments[1]) else { return }

    // stdin 훅 JSON (tool_input이 클 수 있어 1MB 상한)
    let input = FileHandle.standardInput.readData(ofLength: 1_048_576)
    var sessionId = "unknown"
    var cwd: String?
    var prompt: String?
    if let json = try? JSONSerialization.jsonObject(with: input) as? [String: Any] {
        sessionId = (json["session_id"] as? String) ?? "unknown"
        cwd = json["cwd"] as? String
        // 프롬프트는 user-prompt 이벤트만, 앞 200자 (프라이버시·파일 크기, 스펙 §3.3)
        if kind == .userPrompt, let rawPrompt = json["prompt"] as? String {
            prompt = String(rawPrompt.prefix(200))
        }
    }

    let event = ClaudeEvent(ts: Date(), event: kind, sessionId: sessionId, cwd: cwd, prompt: prompt)
    guard let line = try? event.jsonLine() else { return }

    let directory = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".clauchi")
    let fileURL = directory.appendingPathComponent("events.jsonl")
    try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
    }
    guard let handle = try? FileHandle(forWritingTo: fileURL) else { return }
    defer { try? handle.close() }
    _ = try? handle.seekToEnd()
    // 한 줄 단일 write — 동시 훅 실행에도 줄 섞임을 최소화
    try? handle.write(contentsOf: Data((line + "\n").utf8))
}

run()
