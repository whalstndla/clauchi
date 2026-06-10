import Foundation
import Testing
@testable import ClauchiCore

private func makeTempLog() -> URL {
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("clauchi-test-\(UUID().uuidString).jsonl")
    FileManager.default.createFile(atPath: url.path, contents: nil)
    return url
}

private func append(_ text: String, to url: URL) {
    let handle = try! FileHandle(forWritingTo: url)
    defer { try! handle.close() }
    _ = try! handle.seekToEnd()
    try! handle.write(contentsOf: Data(text.utf8))
}

private let line1 = #"{"ts":"2026-06-10T09:00:00Z","event":"stop","sessionId":"s1"}"# + "\n"
private let line2 = #"{"ts":"2026-06-10T09:01:00Z","event":"tool-use","sessionId":"s1"}"# + "\n"

@Test func readsNewLinesAndAdvancesOffset() {
    let url = makeTempLog()
    defer { try? FileManager.default.removeItem(at: url) }
    let reader = EventLogReader(fileURL: url)

    append(line1, to: url)
    #expect(reader.readNewEvents().map(\.event) == [.stop])
    #expect(reader.readNewEvents().isEmpty)   // 같은 줄 재독 없음

    append(line2, to: url)
    #expect(reader.readNewEvents().map(\.event) == [.toolUse])
}

@Test func partialLineWaitsForNewline() {
    let url = makeTempLog()
    defer { try? FileManager.default.removeItem(at: url) }
    let reader = EventLogReader(fileURL: url)

    let half = String(line1.dropLast(10))   // 개행 없는 미완성 줄
    append(half, to: url)
    #expect(reader.readNewEvents().isEmpty)

    append(String(line1.suffix(10)), to: url)   // 나머지 + 개행 도착
    #expect(reader.readNewEvents().count == 1)
}

@Test func truncatedFileResetsOffset() {
    let url = makeTempLog()
    defer { try? FileManager.default.removeItem(at: url) }
    let reader = EventLogReader(fileURL: url)

    append(line1 + line2, to: url)
    #expect(reader.readNewEvents().count == 2)

    try! Data(line1.utf8).write(to: url)   // 더 작은 크기로 교체 (truncate)
    #expect(reader.readNewEvents().count == 1)
}

@Test func malformedLinesAreSkipped() {
    let url = makeTempLog()
    defer { try? FileManager.default.removeItem(at: url) }
    let reader = EventLogReader(fileURL: url)

    append("garbage line\n" + line1, to: url)
    #expect(reader.readNewEvents().count == 1)
}

@Test func missingFileReturnsEmpty() {
    let reader = EventLogReader(
        fileURL: URL(fileURLWithPath: "/nonexistent/clauchi/events.jsonl"))
    #expect(reader.readNewEvents().isEmpty)
}
