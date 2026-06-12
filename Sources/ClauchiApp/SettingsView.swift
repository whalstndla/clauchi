import SwiftUI
import ClauchiCore

struct SettingsView: View {
    @Bindable var model: AppModel

    private let weekdayLabels: [(Int, String)] =
        [(1, "일"), (2, "월"), (3, "화"), (4, "수"), (5, "목"), (6, "금"), (7, "토")]

    @State private var isHookInstalled = HookInstaller.isInstalled

    var body: some View {
        // 엔진 상태는 관찰 불가 — 반드시 모델의 스냅샷을 읽어야 토글이 갱신된다
        let settings = model.settings
        VStack(alignment: .leading, spacing: 12) {
            Text("휴식 요일 (포만감 정지 · 초록 = 켜짐)")
                .font(.caption).foregroundStyle(.gray)
            HStack(spacing: 4) {
                ForEach(weekdayLabels, id: \.0) { weekday, label in
                    let isOn = settings.restWeekdays.contains(weekday)
                    SettingChip(label: label, isOn: isOn) {
                        var updated = settings
                        if isOn { updated.restWeekdays.remove(weekday) }
                        else { updated.restWeekdays.insert(weekday) }
                        model.applySettings(updated)
                    }
                }
            }

            SettingSwitchRow(label: "AI 대사 (Apple Intelligence)",
                             isOn: settings.dialogueAIEnabled) { enabled in
                var updated = model.settings
                updated.dialogueAIEnabled = enabled
                model.applySettings(updated)
                model.refreshDialogueProvider()
            }

            SettingSwitchRow(label: "로그인 시 자동 시작",
                             isOn: settings.launchAtLogin) { enabled in
                var updated = model.settings
                updated.launchAtLogin = enabled
                model.applySettings(updated)
                LaunchAtLogin.set(enabled)
            }

            Divider().overlay(Color(white: 0.3))

            if isHookInstalled {
                SettingChip(label: "Claude Code 훅 제거", isOn: false) {
                    try? HookInstaller.uninstall()
                    isHookInstalled = HookInstaller.isInstalled
                }
            } else {
                SettingChip(label: "Claude Code 훅 설치", isOn: false) {
                    try? HookInstaller.install()
                    isHookInstalled = HookInstaller.isInstalled
                }
            }

            if model.updateService.isEnabled {
                Divider().overlay(Color(white: 0.3))
                Text(updateStatusText(model.updateService.phase))
                    .font(.caption).foregroundStyle(.gray)
                SettingChip(label: "업데이트 확인", isOn: false) {
                    model.updateService.check()
                }
                if case .readyToApply = model.updateService.phase {
                    SettingChip(label: "재시작하여 적용", isOn: true) {
                        model.updateService.applyAndRestart()
                    }
                }
            }

            // Dock 아이콘이 없는 앱이라 종료 수단이 여기뿐이다
            SettingChip(label: "Clauchi 종료", isOn: false) {
                NSApp.terminate(nil)
            }
        }
    }

    private func updateStatusText(_ phase: UpdateService.Phase) -> String {
        switch phase {
        case .idle: "업데이트: 대기"
        case .checking: "업데이트: 확인 중…"
        case .downloading: "업데이트: 새 버전 받는 중…"
        case .readyToApply: "업데이트: 준비됨 — 재시작하면 적용"
        case .upToDate: "업데이트: 최신 상태"
        case .failed(let reason): "업데이트: 실패 (\(reason))"
        }
    }
}
