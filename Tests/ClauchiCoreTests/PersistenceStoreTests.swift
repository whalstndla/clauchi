import Foundation
import Testing
@testable import ClauchiCore

private func makeTempDirectory() -> URL {
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("clauchi-store-\(UUID().uuidString)")
    try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
}

@Test func saveAndLoadRoundtrip() throws {
    let directory = makeTempDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    let store = PersistenceStore(directory: directory)
    let state = TestSupport.makeState()

    try store.save(state)
    #expect(store.load() == state)
}

@Test func corruptedMainFileRecoversFromBackup() throws {
    let directory = makeTempDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    let store = PersistenceStore(directory: directory)
    let first = TestSupport.makeState(satiety: 77)

    try store.save(first)
    try store.save(TestSupport.makeState(satiety: 88))   // first가 백업으로 밀림
    try Data("corrupt!".utf8).write(to: store.stateURL)  // 본 파일 파손

    #expect(store.load()?.pet.satiety == 77)             // 백업에서 복구
}

@Test func bothFilesCorruptReturnsNil() throws {
    let directory = makeTempDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    let store = PersistenceStore(directory: directory)

    try Data("x".utf8).write(to: store.stateURL)
    try Data("y".utf8).write(to: store.backupURL)
    #expect(store.load() == nil)
}

@Test func loadWithNoFilesReturnsNil() {
    let directory = makeTempDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    #expect(PersistenceStore(directory: directory).load() == nil)
}
