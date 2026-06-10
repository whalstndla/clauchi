import Foundation
import Testing
@testable import ClauchiCore

private let binaryPath = "/Users/me/.clauchi/bin/clauchi-hook"

@Test func mergeIntoEmptySettingsAddsFiveEvents() {
    let merged = HookConfigMerger.merged(settings: [:], hookBinaryPath: binaryPath)
    let hooks = merged["hooks"] as? [String: Any]
    for event in ["SessionStart", "PostToolUse", "Stop", "Notification", "UserPromptSubmit"] {
        #expect((hooks?[event] as? [[String: Any]])?.count == 1, "\(event)")
    }
    let promptEntry = (hooks?["UserPromptSubmit"] as? [[String: Any]])?.first
    let command = ((promptEntry?["hooks"] as? [[String: Any]])?.first?["command"] as? String)
    #expect(command == "\(binaryPath) user-prompt")
}

@Test func mergeAddsMissingUserPromptToExistingInstall() {
    // 구버전(4개 이벤트) 설치 상태 → 재병합하면 UserPromptSubmit만 추가
    var old = HookConfigMerger.merged(settings: [:], hookBinaryPath: binaryPath)
    var hooks = (old["hooks"] as? [String: Any]) ?? [:]
    hooks.removeValue(forKey: "UserPromptSubmit")
    old["hooks"] = hooks
    let upgraded = HookConfigMerger.merged(settings: old, hookBinaryPath: binaryPath)
    let upgradedHooks = upgraded["hooks"] as? [String: Any]
    #expect((upgradedHooks?["UserPromptSubmit"] as? [[String: Any]])?.count == 1)
    #expect((upgradedHooks?["Stop"] as? [[String: Any]])?.count == 1)   // 중복 없음
}

@Test func mergeIsIdempotent() {
    let once = HookConfigMerger.merged(settings: [:], hookBinaryPath: binaryPath)
    let twice = HookConfigMerger.merged(settings: once, hookBinaryPath: binaryPath)
    let hooks = twice["hooks"] as? [String: Any]
    #expect((hooks?["Stop"] as? [[String: Any]])?.count == 1)
}

@Test func mergePreservesExistingSettingsAndHooks() {
    let existing: [String: Any] = [
        "model": "opus",
        "hooks": [
            "Stop": [["hooks": [["type": "command", "command": "other-tool notify"]]]],
        ],
    ]
    let merged = HookConfigMerger.merged(settings: existing, hookBinaryPath: binaryPath)
    #expect(merged["model"] as? String == "opus")
    let stopEntries = (merged["hooks"] as? [String: Any])?["Stop"] as? [[String: Any]]
    #expect(stopEntries?.count == 2)   // 기존 훅 + clauchi 훅
}

@Test func removedStripsOnlyClauchiHooks() {
    let existing: [String: Any] = [
        "hooks": [
            "Stop": [["hooks": [["type": "command", "command": "other-tool notify"]]]],
        ],
    ]
    let merged = HookConfigMerger.merged(settings: existing, hookBinaryPath: binaryPath)
    let removed = HookConfigMerger.removed(settings: merged)
    let hooks = removed["hooks"] as? [String: Any]
    #expect((hooks?["Stop"] as? [[String: Any]])?.count == 1)       // 남의 훅 보존
    #expect(hooks?["PostToolUse"] == nil)                            // 우리 것만 있던 이벤트는 제거
}

@Test func removedDropsHooksKeyWhenEmpty() {
    let merged = HookConfigMerger.merged(settings: [:], hookBinaryPath: binaryPath)
    let removed = HookConfigMerger.removed(settings: merged)
    #expect(removed["hooks"] == nil)
}
