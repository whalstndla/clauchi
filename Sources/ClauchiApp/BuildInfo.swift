import Foundation

// 설치 번들의 빌드 메타데이터. dev 실행(swift run)엔 Info.plist가 없어 nil → 자동 업데이트 비활성.
enum BuildInfo {
    // make-app-bundle.sh / build-update.sh가 Info.plist에 주입한 빌드 커밋
    static var commit: String? {
        Bundle.main.object(forInfoDictionaryKey: "ClauchiBuildCommit") as? String
    }

    // 설치 번들이 <repo>/build/Clauchi.app 형태일 때만 레포 루트 반환.
    // dev나 다른 위치로 옮긴 경우 nil → 자동 업데이트 비활성.
    static var repoRoot: URL? {
        let bundleURL = Bundle.main.bundleURL                       // <repo>/build/Clauchi.app
        guard bundleURL.pathExtension == "app",
              bundleURL.deletingLastPathComponent().lastPathComponent == "build" else { return nil }
        let repo = bundleURL.deletingLastPathComponent().deletingLastPathComponent()
        guard FileManager.default.fileExists(
                atPath: repo.appendingPathComponent(".git").path) else { return nil }
        return repo
    }

    // 설치 번들(.app) 경로 — 교체 대상
    static var installedAppURL: URL? {
        let bundleURL = Bundle.main.bundleURL
        return bundleURL.pathExtension == "app" ? bundleURL : nil
    }
}
