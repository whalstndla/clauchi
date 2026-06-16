import SwiftUI
import ClauchiCore

struct SettingsView: View {
    @Bindable var model: AppModel

    private let weekdayLabels: [(Int, String)] =
        [(1, "일"), (2, "월"), (3, "화"), (4, "수"), (5, "목"), (6, "금"), (7, "토")]

    @State private var isHookInstalled = HookInstaller.isInstalled
    @State private var rerollArmed = false   // 리세마라 2단계 확인
    @State private var graduateArmed = false // 조기 졸업 2단계 확인

    var body: some View {
        // 엔진 상태는 관찰 불가 — 반드시 모델의 스냅샷을 읽어야 토글이 갱신된다
        let settings = model.settings
        let pet = model.engine.state.pet
        let config = model.engine.config
        let streakDays = model.engine.state.streakDays
        let lifetimeStops = model.engine.state.lifetimeStops
        let lifetimeManualFeeds = model.engine.state.lifetimeManualFeeds
        VStack(alignment: .leading, spacing: 12) {
            // 연속 사용일(스트릭) — 0일이면 숨김
            if streakDays > 0 {
                Text("🔥 \(streakDays)일 연속 사용 중")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(CuteTheme.yellow)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            // 누적 업적 — 작업/급식 횟수
            Text("⌨️ 누적 작업 \(lifetimeStops)회 · 🍚 급식 \(lifetimeManualFeeds)회")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .center)

            // 주인 프로필 — 대사 호칭/개인화에 사용
            Text("주인 프로필 (대사 호칭에 사용)")
                .font(.caption).foregroundStyle(.gray)
            TextField("주인 이름 (미입력 시 기본 호칭)", text: Binding(
                get: { model.settings.ownerName },
                set: { name in
                    var updated = model.settings
                    updated.ownerName = String(name.prefix(12))
                    model.applySettings(updated)
                }
            ))
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 11, design: .rounded))

            HStack(spacing: 6) {
                Text("성별")
                    .font(.caption).foregroundStyle(.gray)
                ForEach([("미설정", OwnerGender.unspecified),
                         ("남성", .male), ("여성", .female)], id: \.1) { label, gender in
                    let isOn = settings.ownerGender == gender
                    SettingChip(label: label, isOn: isOn) {
                        var updated = model.settings
                        updated.ownerGender = gender
                        model.applySettings(updated)
                    }
                }
            }

            Divider().overlay(Color(white: 0.3))

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

            SettingSwitchRow(label: "🏖️ 휴가 모드", isOn: settings.vacationMode) { on in
                model.toggleVacation(on)
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

            Divider().overlay(Color(white: 0.3))

            // 펫 관리 — 리세마라(Lv.rerollLockLevel 미만) / 조기 졸업(이상) (스펙 §5 + 2026-06-16)
            Text("펫 관리")
                .font(.caption).foregroundStyle(.gray)
            if pet.level >= config.rerollLockLevel {
                // 조기 졸업 — 도감에 졸업 기록을 남기고 새 알. 알 단계에선 숨김
                if pet.stage != .egg {
                    SettingChip(label: graduateArmed
                                ? "정말 졸업시킬까? (한 번 더 클릭)"
                                : "🎓 졸업시키고 새로 시작",
                                isOn: graduateArmed) {
                        if graduateArmed {
                            graduateArmed = false
                            model.graduateEarly()
                        } else {
                            graduateArmed = true
                            Task {
                                try? await Task.sleep(for: .seconds(3))
                                graduateArmed = false
                            }
                        }
                    }
                }
            } else {
                SettingChip(label: rerollArmed
                            ? "정말 새 알로 바꿀까? (한 번 더 클릭)"
                            : "🔄 리세마라 — 새 알 뽑기",
                            isOn: rerollArmed) {
                    if rerollArmed {
                        rerollArmed = false
                        model.reroll()
                    } else {
                        rerollArmed = true
                        Task {
                            try? await Task.sleep(for: .seconds(3))
                            rerollArmed = false
                        }
                    }
                }
            }

            Divider().overlay(Color(white: 0.3))

            // Dock 아이콘이 없는 앱이라 종료 수단이 여기뿐이다
            SettingChip(label: "Clauchi 종료", isOn: false) {
                NSApp.terminate(nil)
            }

            // 현재 버전 — dev(swift run)엔 번들 버전이 없어 "개발 빌드"
            Text("Clauchi \(BuildInfo.version.map { "v\($0)" } ?? "개발 빌드")")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
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
