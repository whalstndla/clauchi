import Foundation

// ~/.claude/settings.json 의 hooks 블록에 clauchi 훅을 병합/제거하는 순수 함수.
// 기존 설정은 절대 덮어쓰지 않는다 (스펙 §10). 검증된 훅 형식(2026-06-10) 기준.
public enum HookConfigMerger {
    public static let marker = "clauchi-hook"
    static let hookEvents: [(claudeEvent: String, argument: String)] = [
        ("SessionStart", "session-start"),
        ("PostToolUse", "tool-use"),
        ("Stop", "stop"),
        ("Notification", "notification"),
        ("UserPromptSubmit", "user-prompt"),
    ]

    public static func merged(settings: [String: Any], hookBinaryPath: String) -> [String: Any] {
        var result = settings
        var hooks = (result["hooks"] as? [String: Any]) ?? [:]
        for (claudeEvent, argument) in hookEvents {
            var entries = (hooks[claudeEvent] as? [[String: Any]]) ?? []
            let alreadyInstalled = entries.contains { containsClauchiCommand($0) }
            if !alreadyInstalled {
                entries.append([
                    "hooks": [[
                        "type": "command",
                        "command": "\(hookBinaryPath) \(argument)",
                        "timeout": 5,
                    ] as [String: Any]],
                ])
            }
            hooks[claudeEvent] = entries
        }
        result["hooks"] = hooks
        return result
    }

    public static func removed(settings: [String: Any]) -> [String: Any] {
        var result = settings
        guard var hooks = result["hooks"] as? [String: Any] else { return result }
        for (claudeEvent, _) in hookEvents {
            guard let entries = hooks[claudeEvent] as? [[String: Any]] else { continue }
            let kept = entries.filter { !containsClauchiCommand($0) }
            if kept.isEmpty { hooks.removeValue(forKey: claudeEvent) }
            else { hooks[claudeEvent] = kept }
        }
        if hooks.isEmpty { result.removeValue(forKey: "hooks") }
        else { result["hooks"] = hooks }
        return result
    }

    private static func containsClauchiCommand(_ entry: [String: Any]) -> Bool {
        ((entry["hooks"] as? [[String: Any]]) ?? [])
            .contains { (($0["command"] as? String) ?? "").contains(marker) }
    }
}
