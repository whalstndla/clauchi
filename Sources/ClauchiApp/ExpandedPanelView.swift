import SwiftUI
import ClauchiCore

// 알약 클릭 시 노치 아래로 열리는 패널 — 다마고치풍 (스펙 §7)
struct ExpandedPanelView: View {
    @Bindable var model: AppModel
    @State private var selectedTab = 0
    @State private var rerollArmed = false   // 리세마라 2단계 확인
    @State private var isEditingName = false
    @State private var nameInput = ""
    @FocusState private var isNameFieldFocused: Bool

    private let tabs = ["🐾 펫", "📒 도감", "⚙️ 설정"]

    var body: some View {
        VStack(spacing: 12) {
            // 탭 — 비활성 창에서도 색이 살아있는 커스텀 칩
            HStack(spacing: 6) {
                ForEach(tabs.indices, id: \.self) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        Text(tabs[index])
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(selectedTab == index ? .black : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(selectedTab == index
                                               ? CuteTheme.yellow : CuteTheme.slot))
                    }
                    .buttonStyle(.plain)
                }
            }

            switch selectedTab {
            case 0: petTab
            case 1: CollectionView(model: model)
            default: SettingsView(model: model)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 22, bottomTrailingRadius: 22)
                .fill(CuteTheme.panelBackground))
        .overlay(
            UnevenRoundedRectangle(bottomLeadingRadius: 22, bottomTrailingRadius: 22)
                .strokeBorder(CuteTheme.border, lineWidth: 1))
        .preferredColorScheme(.dark)
    }

    private var petTab: some View {
        let pet = model.engine.state.pet
        let config = model.engine.config
        let expression: ClauchiCore.Expression = switch true {
        case _ where model.visualState == .critical: .critical
        case _ where model.visualState == .hungry || model.visualState == .sleeping: .sad
        case _ where pet.mood <= config.moodSadThreshold: .sad
        default: .happy
        }

        return VStack(spacing: 12) {
            // 다마고치 "화면" — 밤하늘 스크린 안에 펫. 클릭하면 쓰다듬기
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [CuteTheme.screenTop, CuteTheme.screenBottom],
                                         startPoint: .top, endPoint: .bottom))
                VStack(spacing: 6) {
                    if let grid = SpriteLibrary.spriteSet(for: pet.species, stage: pet.stage)
                        .large[expression] {
                        Image(nsImage: SpriteImageFactory.image(
                            for: grid,
                            cacheKey: "L-\(pet.species.rawValue)-\(pet.stage.rawValue)-\(expression.rawValue)"))
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 96, height: 96)
                    }
                    Text(pet.stage == .egg ? "...무언가 꿈틀거린다" : "콕 눌러서 쓰다듬기 💕")
                        .font(.system(size: 9, design: .rounded))
                        .foregroundStyle(.white.opacity(0.45))
                }
                HeartBurst(trigger: model.heartBurst)
            }
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(CuteTheme.cream.opacity(0.25),
                                  style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])))
            .contentShape(Rectangle())
            .onTapGesture { model.petPet() }

            HStack(spacing: 6) {
                if isEditingName {
                    TextField("이름 (최대 12자)", text: $nameInput)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .frame(width: 150)
                        .focused($isNameFieldFocused)
                        .onSubmit {
                            model.renamePet(nameInput)
                            isEditingName = false
                            isNameFieldFocused = false
                        }
                    Button("취소") {
                        isEditingName = false
                        isNameFieldFocused = false
                    }
                        .buttonStyle(.plain)
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                } else {
                    Text(pet.stage == .egg
                         ? "부화를 기다리는 알"
                         : "\(pet.displayName) Lv.\(pet.level)")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(CuteTheme.cream)
                    Button("✏️") {
                        nameInput = pet.customName ?? ""
                        isEditingName = true
                        isNameFieldFocused = true
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 11))
                }
            }
            // 패널 열린 채 리세마라/부화로 펫이 바뀌면 이전 펫 기준 편집 상태를 정리한다
            // (bornAt이 펫 개체 식별자 역할 — 새 알마다 갱신됨)
            .onChange(of: pet.bornAt) {
                isEditingName = false
                nameInput = ""
                isNameFieldFocused = false
            }

            // 성격 — 알 단계에서는 숨김(부화 시 공개) (스펙 §7.1)
            if pet.stage != .egg {
                Text("성격 · \(pet.personality.koreanName)")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(CuteTheme.cream.opacity(0.7))
            }

            VStack(spacing: 7) {
                statRow(icon: "🍚", label: "포만감", value: pet.satiety, total: 100,
                        color: CuteTheme.green)
                statRow(icon: "💖", label: "기분", value: pet.mood, total: 100,
                        color: CuteTheme.pink)
                statRow(icon: "⭐", label: "EXP", value: Double(pet.exp),
                        total: Double(pet.stage == .egg
                                      ? config.hatchExp
                                      : config.expToNextLevel(from: pet.level)),
                        color: CuteTheme.yellow)
            }

            // 수동 밥주기 — 알 단계 제외. 쿨다운은 frameIndex(0.5초)마다 자동 갱신
            let manualFeedCooldown = model.manualFeedCooldownRemaining
            if pet.stage != .egg {
                SettingChip(
                    label: manualFeedCooldown > 0
                        ? "🍚 밥 주기 (\(Int(manualFeedCooldown))초 후 가능)"
                        : "🍚 밥 주기",
                    isOn: false
                ) {
                    model.manualFeed()
                }
                .frame(maxWidth: 220)
                .disabled(manualFeedCooldown > 0)
                .opacity(manualFeedCooldown > 0 ? 0.5 : 1)
            }

            SettingSwitchRow(label: "🏖️ 휴가 모드", isOn: model.settings.vacationMode) { on in
                model.toggleVacation(on)
            }
            .frame(maxWidth: 220)

            // 리세마라 — rerollLockLevel 미만에서만 가능 (스펙 §5)
            let isRerollLocked = pet.level >= config.rerollLockLevel
            if isRerollLocked {
                // 잠금 상태 — 비활성 표시
                SettingChip(label: "🔒 리세마라 잠금 (Lv.\(config.rerollLockLevel) 이상)",
                            isOn: false) {}
                    .opacity(0.4)
                    .disabled(true)
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
        }
    }

    private func statRow(icon: String, label: String, value: Double,
                         total: Double, color: Color) -> some View {
        HStack(spacing: 6) {
            Text(icon).font(.system(size: 11))
            Text(label)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
                .frame(width: 40, alignment: .leading)
            PixelBar(value: min(value, total), total: total, color: color)
            Text("\(Int(value))/\(Int(total))")
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.white.opacity(0.55))
                .frame(width: 44, alignment: .trailing)
        }
    }

}
