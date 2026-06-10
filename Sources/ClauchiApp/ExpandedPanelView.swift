import SwiftUI
import ClauchiCore

// 알약 클릭 시 노치 아래로 열리는 패널 — 다마고치풍 (스펙 §7)
struct ExpandedPanelView: View {
    @Bindable var model: AppModel
    @State private var selectedTab = 0

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

            Text(pet.stage == .egg ? "부화를 기다리는 알" : "\(pet.species.koreanName) Lv.\(pet.level)")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(CuteTheme.cream)

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

            SettingSwitchRow(label: "🏖️ 휴가 모드", isOn: model.settings.vacationMode) { on in
                model.toggleVacation(on)
            }
            .frame(maxWidth: 220)

            #if DEBUG
            debugSection
            #endif
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

    #if DEBUG
    private var debugSection: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    SettingChip(label: "1시간 ▶▶", isOn: false) { model.debugFastForward(3600) }
                    SettingChip(label: "밥(Stop)", isOn: false) { model.debugInject(.stop) }
                    SettingChip(label: "작업", isOn: false) { model.debugInject(.toolUse) }
                }
                HStack {
                    SettingChip(label: "알림", isOn: false) { model.debugInject(.notification) }
                    SettingChip(label: "위독", isOn: false) { model.debugCommand(.setSatiety(0)) }
                    SettingChip(label: "EXP+50", isOn: false) { model.debugCommand(.grantExp(50)) }
                }
            }
            .padding(.top, 4)
        } label: {
            Text("🔧 디버그")
                .font(.system(size: 10, design: .rounded))
                .foregroundStyle(.gray)
        }
    }
    #endif
}
