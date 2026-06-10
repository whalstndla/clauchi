import Foundation

// events.jsonl 오프셋 기반 tail-reader.
// 부분 줄(쓰는 중인 줄)은 다음 호출로 미루고, 파일이 줄어들면 처음부터 다시 읽는다 (스펙 §10)
public final class EventLogReader {
    public let fileURL: URL
    public private(set) var offset: UInt64

    public init(fileURL: URL, offset: UInt64 = 0) {
        self.fileURL = fileURL
        self.offset = offset
    }

    public func readNewEvents() -> [ClaudeEvent] {
        guard let handle = try? FileHandle(forReadingFrom: fileURL) else { return [] }
        defer { try? handle.close() }
        let size = (try? handle.seekToEnd()) ?? 0
        if size < offset { offset = 0 }   // truncate/교체 감지
        guard size > offset else { return [] }
        try? handle.seek(toOffset: offset)
        guard let data = try? handle.readToEnd(), !data.isEmpty else { return [] }
        guard let lastNewlineIndex = data.lastIndex(of: UInt8(ascii: "\n")) else { return [] }
        let completeChunk = data[data.startIndex...lastNewlineIndex]
        offset += UInt64(completeChunk.count)
        return completeChunk
            .split(separator: UInt8(ascii: "\n"))
            .compactMap { ClaudeEvent.fromJSONLine(Data($0)) }
    }

    // 로그 정리(truncate) 후 호출 — 처음부터 다시 읽게 한다 (스펙 §9)
    public func resetOffset() { offset = 0 }
}
