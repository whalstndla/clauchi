import SwiftUI
import ClauchiCore

// 알약 클릭 시 노치 아래로 열리는 패널 (스펙 §7)
struct ExpandedPanelView: View {
    @Bindable var model: AppModel
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 12) {
            Picker("", selection: $selectedTab) {
                Text("펫").tag(0)
                Text("도감").tag(1)
                Text("설정").tag(2)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

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
                .fill(Color.black))
        .preferredColorScheme(.dark)
    }

    private var petTab: some View {
        let pet = model.engine.state.pet
        let expression: ClauchiCore.Expression = switch model.visualState {
        case .critical: .critical
        case .hungry, .sleeping: .sad
        default: .happy
        }
        return VStack(spacing: 10) {
            if let grid = SpriteLibrary.spriteSet(for: pet.species, stage: pet.stage)
                .large[expression] {
                Image(nsImage: SpriteImageFactory.image(
                    for: grid,
                    cacheKey: "L-\(pet.species.rawValue)-\(pet.stage.rawValue)-\(expression.rawValue)"))
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 96, height: 96)
            }
            Text(pet.stage == .egg ? "부화를 기다리는 알" : "\(pet.species.koreanName) Lv.\(pet.level)")
                .font(.headline)
                .foregroundStyle(.white)

            statRow(label: "포만감", value: pet.satiety, total: 100,
                    tint: pet.satiety <= 20 ? .red : .green)
            statRow(label: "EXP",
                    value: Double(pet.exp),
                    total: Double(pet.stage == .egg
                                  ? model.engine.config.hatchExp
                                  : model.engine.config.expToNextLevel(from: pet.level)),
                    tint: .yellow)

            SettingSwitchRow(label: "휴가 모드", isOn: model.settings.vacationMode) { on in
                model.toggleVacation(on)
            }
            .frame(maxWidth: 200)

            #if DEBUG
            debugSection
            #endif
        }
    }

    private func statRow(label: String, value: Double, total: Double, tint: Color) -> some View {
        HStack {
            Text(label).font(.caption).foregroundStyle(.gray)
                .frame(width: 44, alignment: .leading)
            ProgressView(value: min(value, total), total: total).tint(tint)
            Text("\(Int(value))/\(Int(total))")
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.gray)
        }
    }

    #if DEBUG
    private var debugSection: some View {
        DisclosureGroup("디버그") {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Button("1시간 ▶▶") { model.debugFastForward(3600) }
                    Button("밥(Stop)") { model.debugInject(.stop) }
                    Button("작업") { model.debugInject(.toolUse) }
                }
                HStack {
                    Button("알림") { model.debugInject(.notification) }
                    Button("위독") { model.debugCommand(.setSatiety(0)) }
                    Button("EXP+50") { model.debugCommand(.grantExp(50)) }
                }
            }
        }
        .font(.caption)
        .foregroundStyle(.gray)
    }
    #endif
}
