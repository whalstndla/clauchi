import Foundation
import AppKit
import ClauchiCore

@MainActor
@Observable
final class UpdateService {
    enum Phase: Equatable {
        case idle
        case checking
        case building
        case readyToApply(remoteCommit: String)
        case upToDate
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    // readyToApply 진입 시 1회 호출(토스트용) — AppModel이 주입
    var onReadyToApply: (() -> Void)?

    private let repoRoot: URL?
    private let buildCommit: String?
    private let installedAppURL: URL?
    // build-update.sh 출력 위치와 일치
    private let stagingAppURL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".clauchi/update/staging/Clauchi.app")

    init(repoRoot: URL? = BuildInfo.repoRoot,
         buildCommit: String? = BuildInfo.commit,
         installedAppURL: URL? = BuildInfo.installedAppURL) {
        self.repoRoot = repoRoot
        self.buildCommit = buildCommit
        self.installedAppURL = installedAppURL
    }

    // 설치 번들 + git 레포일 때만 활성
    var isEnabled: Bool { repoRoot != nil && buildCommit != nil && installedAppURL != nil }

    // 업데이트 확인 — 이미 진행 중이면 무시
    func check() {
        guard isEnabled, let repo = repoRoot, let build = buildCommit else { return }
        switch phase {
        case .checking, .building, .readyToApply: return
        case .idle, .upToDate, .failed: break
        }
        phase = .checking
        let repoPath = repo.path
        // detached에는 Sendable 값(String)만 넘기고, self는 MainActor로 돌아와서 만진다 (Swift 6)
        Task {
            let status = await Task.detached(priority: .utility) { () -> UpdateStatus in
                _ = Self.run("/usr/bin/git", ["-C", repoPath, "fetch", "origin", "main"])
                let remote = Self.run("/usr/bin/git", ["-C", repoPath, "rev-parse", "origin/main"])
                    .out.trimmingCharacters(in: .whitespacesAndNewlines)
                let ancestor = Self.run("/usr/bin/git",
                    ["-C", repoPath, "merge-base", "--is-ancestor", build, "origin/main"]).code == 0
                return UpdateChecker.status(
                    buildCommit: build,
                    remoteCommit: remote.isEmpty ? nil : remote,
                    buildIsAncestorOfRemote: ancestor)
            }.value
            self.handle(status)
        }
    }

    private func handle(_ status: UpdateStatus) {
        switch status {
        case .upToDate: phase = .upToDate
        case .skip: phase = .idle
        case .updateAvailable(let remote): startBuild(remoteCommit: remote)
        }
    }

    private func startBuild(remoteCommit: String) {
        guard let repo = repoRoot else { return }
        phase = .building
        let script = repo.appendingPathComponent("Scripts/build-update.sh").path
        let repoPath = repo.path
        Task {
            let ok = await Task.detached(priority: .utility) { () -> Bool in
                let result = Self.run("/bin/bash", [script, repoPath])
                return result.code == 0 && result.out.contains("STAGED:")
            }.value
            if ok {
                self.phase = .readyToApply(remoteCommit: remoteCommit)
                self.onReadyToApply?()
            } else {
                self.phase = .failed("업데이트 빌드 실패")
            }
        }
    }

    // 재시작하여 적용 — 헬퍼가 현재 앱 종료 대기 후 교체·재실행, 현재 앱 종료
    func applyAndRestart() {
        guard case .readyToApply = phase, let install = installedAppURL else { return }
        let pid = ProcessInfo.processInfo.processIdentifier
        let installPath = install.path
        let installDir = install.deletingLastPathComponent().path
        let staging = stagingAppURL.path
        let stagingNew = installDir + "/.Clauchi.app.new"
        let helper = """
            while kill -0 \(pid) 2>/dev/null; do sleep 0.3; done
            [ -d "\(staging)" ] || exit 1
            rm -rf "\(stagingNew)"
            cp -R "\(staging)" "\(stagingNew)" &&
            rm -rf "\(installPath)" &&
            mv "\(stagingNew)" "\(installPath)" &&
            open "\(installPath)"
            """
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", helper]
        try? process.run()   // detached — 기다리지 않는다
        NSApp.terminate(nil)
    }

    // 동기 Process 실행 (백그라운드에서만 호출). stderr는 버려 파이프 막힘 방지.
    nonisolated private static func run(_ launch: String, _ args: [String]) -> (code: Int32, out: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launch)
        process.arguments = args
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice
        do { try process.run() } catch { return (-1, "") }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        return (process.terminationStatus, String(data: data, encoding: .utf8) ?? "")
    }
}
