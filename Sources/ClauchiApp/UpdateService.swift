import Foundation
import AppKit
import ClauchiCore

@MainActor
@Observable
final class UpdateService {
    enum Phase: Equatable {
        case idle
        case checking
        case downloading
        case readyToApply(version: String)
        case upToDate
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    // readyToApply 진입 시 1회 호출(토스트용) — AppModel이 주입
    var onReadyToApply: (() -> Void)?

    private let version: String?
    private let installedAppURL: URL?
    // 다운로드분을 풀어둘 스테이징 위치
    private let stagingAppURL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".clauchi/update/staging/Clauchi.app")
    nonisolated static let repoSlug = "whalstndla/clauchi"

    init(version: String? = BuildInfo.version,
         installedAppURL: URL? = BuildInfo.installedAppURL) {
        self.version = version
        self.installedAppURL = installedAppURL
    }

    // 설치 번들(버전 + .app)일 때만 활성
    var isEnabled: Bool { version != nil && installedAppURL != nil }

    // 최신 릴리스 확인 — 이미 진행 중이면 무시
    func check() {
        guard isEnabled, let installed = version else { return }
        switch phase {
        case .checking, .downloading, .readyToApply: return
        case .idle, .upToDate, .failed: break
        }
        phase = .checking
        Task {
            do {
                let release = try await Self.fetchLatestRelease()
                switch ReleaseVersionChecker.status(installed: installed, latest: release.version) {
                case .upToDate: phase = .upToDate
                case .skip: phase = .idle
                case .updateAvailable(let newVersion):
                    if let assetURL = release.zipAssetURL {
                        download(from: assetURL, version: newVersion)
                    } else {
                        phase = .idle
                    }
                }
            } catch {
                phase = .idle   // 오프라인/API 실패 → 조용히 스킵
            }
        }
    }

    private func download(from assetURL: URL, version newVersion: String) {
        phase = .downloading
        let staging = stagingAppURL
        Task {
            do {
                let (zipData, _) = try await URLSession.shared.data(from: assetURL)
                let ok = await Task.detached(priority: .utility) { () -> Bool in
                    Self.extractAndStage(zipData: zipData, stagingApp: staging)
                }.value
                if ok {
                    phase = .readyToApply(version: newVersion)
                    onReadyToApply?()
                } else {
                    phase = .failed("업데이트 추출 실패")
                }
            } catch {
                phase = .failed("다운로드 실패")
            }
        }
    }

    // 재시작하여 적용 — backup-restore 원자 교체 후 재실행, 현재 앱 종료
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
            rm -rf "\(stagingNew)" "\(installPath).bak"
            cp -R "\(staging)" "\(stagingNew)" &&
            mv "\(installPath)" "\(installPath).bak" &&
            mv "\(stagingNew)" "\(installPath)" &&
            rm -rf "\(installPath).bak" &&
            open "\(installPath)"
            """
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", helper]
        try? process.run()   // detached — 기다리지 않는다
        NSApp.terminate(nil)
    }

    // --- 네트워크/추출 (nonisolated) ---

    private struct LatestRelease: Sendable { let version: String; let zipAssetURL: URL? }

    // 공개 릴리스 API (인증 불필요, User-Agent 필수)
    nonisolated private static func fetchLatestRelease() async throws -> LatestRelease {
        let url = URL(string: "https://api.github.com/repos/\(repoSlug)/releases/latest")!
        var request = URLRequest(url: url)
        request.setValue("Clauchi", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)   // 비2xx(레이트리밋/릴리스 없음) → catch → 조용히 스킵
        }
        let release = try JSONDecoder().decode(GitHubRelease.self, from: data)
        let tag = release.tagName
        let version = tag.hasPrefix("v") ? String(tag.dropFirst()) : tag
        let zip = release.assets.first { $0.name.hasSuffix(".zip") }?.browserDownloadURL
        return LatestRelease(version: version, zipAssetURL: zip)
    }

    private struct GitHubRelease: Decodable {
        let tagName: String
        let assets: [Asset]
        struct Asset: Decodable {
            let name: String
            let browserDownloadURL: URL
            enum CodingKeys: String, CodingKey {
                case name
                case browserDownloadURL = "browser_download_url"
            }
        }
        enum CodingKeys: String, CodingKey {
            case tagName = "tag_name"
            case assets
        }
    }

    // zip(Data) → ditto 추출 → 격리 제거 → 스테이징 (블로킹, detached에서 호출)
    nonisolated private static func extractAndStage(zipData: Data, stagingApp: URL) -> Bool {
        let fileManager = FileManager.default
        let tmpDir = fileManager.temporaryDirectory
            .appendingPathComponent("clauchi-update-\(UUID().uuidString)")
        defer { try? fileManager.removeItem(at: tmpDir) }
        do {
            try fileManager.createDirectory(at: tmpDir, withIntermediateDirectories: true)
            let zipPath = tmpDir.appendingPathComponent("Clauchi.zip")
            try zipData.write(to: zipPath)
            let extractDir = tmpDir.appendingPathComponent("extract")
            try fileManager.createDirectory(at: extractDir, withIntermediateDirectories: true)
            guard run("/usr/bin/ditto", ["-x", "-k", zipPath.path, extractDir.path]) == 0 else { return false }
            let extractedApp = extractDir.appendingPathComponent("Clauchi.app")
            guard fileManager.fileExists(atPath: extractedApp.path) else { return false }
            // 미서명 핵심: 다운로드분의 격리 속성 제거
            _ = run("/usr/bin/xattr", ["-dr", "com.apple.quarantine", extractedApp.path])
            try fileManager.createDirectory(at: stagingApp.deletingLastPathComponent(),
                                            withIntermediateDirectories: true)
            try? fileManager.removeItem(at: stagingApp)
            try fileManager.moveItem(at: extractedApp, to: stagingApp)
            return true
        } catch {
            return false
        }
    }

    nonisolated private static func run(_ launch: String, _ args: [String]) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launch)
        process.arguments = args
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        do { try process.run() } catch { return -1 }
        process.waitUntilExit()
        return process.terminationStatus
    }
}
