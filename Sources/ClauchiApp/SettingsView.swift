import SwiftUI
import ClauchiCore

struct SettingsView: View {
    @Bindable var model: AppModel

    private let weekdayLabels: [(Int, String)] =
        [(1, "일"), (2, "월"), (3, "화"), (4, "수"), (5, "목"), (6, "금"), (7, "토")]

    var body: some View {
        // 엔진 상태는 관찰 불가 — 반드시 모델의 스냅샷을 읽어야 토글이 갱신된다
        let settings = model.settings
        VStack(alignment: .leading, spacing: 12) {
            Text("휴식 요일 (포만감 정지)").font(.caption).foregroundStyle(.gray)
            HStack(spacing: 4) {
                ForEach(weekdayLabels, id: \.0) { weekday, label in
                    let isOn = settings.restWeekdays.contains(weekday)
                    Button(label) {
                        var updated = settings
                        if isOn { updated.restWeekdays.remove(weekday) }
                        else { updated.restWeekdays.insert(weekday) }
                        model.applySettings(updated)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isOn ? .green : Color(white: 0.22))
                    .font(.caption)
                }
            }
            Text("초록색 = 휴식 요일").font(.system(size: 9)).foregroundStyle(.gray)

            Toggle("AI 대사 (Apple Intelligence)", isOn: Binding(
                get: { model.settings.dialogueAIEnabled },
                set: { enabled in
                    var updated = model.settings
                    updated.dialogueAIEnabled = enabled
                    model.applySettings(updated)
                    model.refreshDialogueProvider()
                }))
                .toggleStyle(.switch)
                .tint(.green)
                .font(.caption).foregroundStyle(.white)

            Toggle("로그인 시 자동 시작", isOn: Binding(
                get: { model.settings.launchAtLogin },
                set: { enabled in
                    var updated = model.settings
                    updated.launchAtLogin = enabled
                    model.applySettings(updated)
                    LaunchAtLogin.set(enabled)
                }))
                .toggleStyle(.switch)
                .tint(.green)
                .font(.caption).foregroundStyle(.white)

            Button("Claude Code 훅 제거") {
                try? HookInstaller.uninstall()
            }
            .font(.caption)

            // Dock 아이콘이 없는 앱이라 종료 수단이 여기뿐이다
            Button("Clauchi 종료", role: .destructive) {
                NSApp.terminate(nil)
            }
            .font(.caption)
        }
    }
}
