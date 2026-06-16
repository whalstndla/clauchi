import Foundation
import Darwin

// 설치 번들 메타. dev(swift run)엔 버전/번들이 없어 nil → 자동 업데이트 비활성.
enum BuildInfo {
    static var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    // 교체 대상 .app — 설치 위치 무관(/Applications 등 어디든).
    // App Translocation: 격리(quarantine)된 미서명 앱을 Downloads 등에서 실행하면 macOS가
    // 읽기 전용 임시 경로로 옮겨 실행한다 → Bundle.main.bundleURL이 임시 경로를 가리킨다.
    // 그 경로를 그대로 교체 대상으로 쓰면 자동 업데이트가 실제 설치 위치를 못 건드려
    // 교체가 실패하고, 종료 후 재실행도 죽은 경로라 앱이 안 켜진다. → 원래 경로로 환원한다.
    static var installedAppURL: URL? {
        let url = Bundle.main.bundleURL
        guard url.pathExtension == "app" else { return nil }
        return deTranslocatedURL(url)
    }

    // SecTranslocateCreateOriginalPathForURL — 공개 API지만 Swift Security 모듈에 노출돼
    // 있지 않아 dlsym으로 동적 로드한다. translocation이면 원래 경로, 아니면 입력 그대로 반환.
    private typealias SecTranslocateOriginalPath =
        @convention(c) (CFURL, UnsafeMutablePointer<Unmanaged<CFError>?>?) -> Unmanaged<CFURL>?

    private static func deTranslocatedURL(_ url: URL) -> URL {
        guard let symbol = dlsym(UnsafeMutableRawPointer(bitPattern: -2),  // RTLD_DEFAULT
                                 "SecTranslocateCreateOriginalPathForURL") else {
            return url
        }
        let function = unsafeBitCast(symbol, to: SecTranslocateOriginalPath.self)
        var errorRef: Unmanaged<CFError>?
        if let original = function(url as CFURL, &errorRef) {
            return original.takeRetainedValue() as URL
        }
        return url
    }
}
