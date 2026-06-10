import AppKit
import ServiceManagement

// 로그인 자동 시작 (스펙 §5 휴식 예외 — 앱을 깜빡해서 굶기는 사고 방지)
enum LaunchAtLogin {
    static func set(_ enabled: Bool) {
        // SMAppService 는 .app 번들에서만 동작 — swift run 개발 모드에선 무시
        do {
            if enabled { try SMAppService.mainApp.register() }
            else { try SMAppService.mainApp.unregister() }
        } catch {
            NSLog("[clauchi] LaunchAtLogin failed: \(error.localizedDescription)")
        }
    }
}
