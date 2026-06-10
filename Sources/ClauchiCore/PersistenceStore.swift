import Foundation

// state.json 원자적 저장 + 백업 복구 (스펙 §9·§10)
public struct PersistenceStore {
    public let stateURL: URL
    public let backupURL: URL

    public init(directory: URL) {
        self.stateURL = directory.appendingPathComponent("state.json")
        self.backupURL = directory.appendingPathComponent("state.json.bak")
    }

    public func load() -> GameState? {
        if let state = try? Self.decode(from: stateURL) { return state }
        if let backup = try? Self.decode(from: backupURL) {
            try? save(backup)   // 복구본을 본 파일로 되살림
            return backup
        }
        return nil
    }

    public func save(_ state: GameState) throws {
        try FileManager.default.createDirectory(
            at: stateURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        if FileManager.default.fileExists(atPath: stateURL.path) {
            _ = try? FileManager.default.removeItem(at: backupURL)
            try? FileManager.default.copyItem(at: stateURL, to: backupURL)
        }
        try JSONEncoder.clauchi.encode(state).write(to: stateURL, options: .atomic)
    }

    private static func decode(from url: URL) throws -> GameState {
        try JSONDecoder.clauchi.decode(GameState.self, from: Data(contentsOf: url))
    }
}
