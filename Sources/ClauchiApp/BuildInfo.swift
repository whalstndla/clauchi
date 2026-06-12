import Foundation

// 설치 번들 메타. dev(swift run)엔 버전/번들이 없어 nil → 자동 업데이트 비활성.
enum BuildInfo {
    static var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    // 교체 대상 .app — 설치 위치 무관(/Applications 등 어디든)
    static var installedAppURL: URL? {
        let url = Bundle.main.bundleURL
        return url.pathExtension == "app" ? url : nil
    }
}
