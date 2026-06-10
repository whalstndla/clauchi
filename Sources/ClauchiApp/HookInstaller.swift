import AppKit
import ClauchiCore

// 첫 실행: 동의 → 훅 바이너리를 안정 경로로 복사 → settings.json 병합 (스펙 §3·§10)
enum HookInstaller {
    static let settingsURL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".claude/settings.json")
    static let installedBinaryURL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".clauchi/bin/clauchi-hook")

    static var isInstalled: Bool {
        guard let text = try? String(contentsOf: settingsURL, encoding: .utf8) else { return false }
        return text.contains(HookConfigMerger.marker)
    }

    @MainActor
    static func offerInstallIfNeeded() {
        guard !isInstalled else { return }
        let alert = NSAlert()
        alert.messageText = "Claude Code 연동 설정"
        alert.informativeText = """
            펫이 Claude Code 활동을 느끼려면 ~/.claude/settings.json 에 훅 4개를 \
            등록해야 합니다. 기존 설정은 건드리지 않으며, 설정 탭에서 언제든 제거할 수 있습니다.
            """
        alert.addButton(withTitle: "등록")
        alert.addButton(withTitle: "나중에")
        guard alert.runModal() == .alertFirstButtonReturn else { return }
        do {
            try install()
        } catch {
            let failure = NSAlert()
            failure.messageText = "등록 실패"
            failure.informativeText = error.localizedDescription
            failure.runModal()
        }
    }

    static func install() throws {
        // 1) 실행 파일 옆의 ClauchiHook 바이너리를 안정 경로로 복사
        //    (swift run: .build/debug/, 번들: Clauchi.app/Contents/MacOS/ — 둘 다 동작)
        let sourceURL = Bundle.main.executableURL!
            .deletingLastPathComponent().appendingPathComponent("ClauchiHook")
        try FileManager.default.createDirectory(
            at: installedBinaryURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        _ = try? FileManager.default.removeItem(at: installedBinaryURL)
        try FileManager.default.copyItem(at: sourceURL, to: installedBinaryURL)

        // 2) settings.json 병합 (없으면 생성)
        var existing: [String: Any] = [:]
        if let data = try? Data(contentsOf: settingsURL),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            existing = json
        }
        let merged = HookConfigMerger.merged(settings: existing,
                                             hookBinaryPath: installedBinaryURL.path)
        try write(merged)
    }

    static func uninstall() throws {
        guard let data = try? Data(contentsOf: settingsURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return }
        try write(HookConfigMerger.removed(settings: json))
    }

    private static func write(_ settings: [String: Any]) throws {
        try FileManager.default.createDirectory(
            at: settingsURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        let data = try JSONSerialization.data(
            withJSONObject: settings, options: [.prettyPrinted, .sortedKeys])
        try data.write(to: settingsURL, options: .atomic)
    }
}
