import SwiftUI
import ClauchiCore

struct SettingsView: View {
    @Bindable var model: AppModel

    private let weekdayLabels: [(Int, String)] =
        [(1, "일"), (2, "월"), (3, "화"), (4, "수"), (5, "목"), (6, "금"), (7, "토")]

    var body: some View {
        let settings = model.engine.state.settings
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
                    .buttonStyle(.bordered)
                    .tint(isOn ? .green : .gray)
                    .font(.caption)
                }
            }

            Toggle("AI 대사 (Apple Intelligence)", isOn: Binding(
                get: { settings.dialogueAIEnabled },
                set: { enabled in
                    var updated = settings
                    updated.dialogueAIEnabled = enabled
                    model.applySettings(updated)
                    model.refreshDialogueProvider()   // Task 21에서 실구현
                }))
                .toggleStyle(.switch).font(.caption).foregroundStyle(.white)

            Toggle("로그인 시 자동 시작", isOn: Binding(
                get: { settings.launchAtLogin },
                set: { enabled in
                    var updated = settings
                    updated.launchAtLogin = enabled
                    model.applySettings(updated)
                    LaunchAtLogin.set(enabled)        // Task 23에서 실구현
                }))
                .toggleStyle(.switch).font(.caption).foregroundStyle(.white)

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
