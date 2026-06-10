import SwiftUI
import ClauchiCore

// 노치를 감싸는 알약 (스펙 §7 — B형 상시 표시)
struct PillView: View {
    @Bindable var model: AppModel

    var body: some View {
        let pet = model.engine.state.pet
        let spriteSet = SpriteLibrary.spriteSet(for: pet.species, stage: pet.stage)
        let frames = spriteSet.frames(for: model.visualState)
        let frame = frames.isEmpty ? nil : frames[(model.frameIndex / 2) % frames.count]

        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black)
            HStack(spacing: 8) {
                if let frame {
                    Image(nsImage: SpriteImageFactory.image(
                        for: frame,
                        cacheKey: spriteCacheKey(pet: pet, frames: frames)))
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 28, height: 28)
                }
                Spacer()
                if model.isHovering {
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(petTitle(pet))
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(CuteTheme.cream)
                            .lineLimit(1)
                        TinyBar(value: pet.satiety, total: 100, color: CuteTheme.green)
                            .frame(width: 64)
                        TinyBar(value: pet.mood, total: 100, color: CuteTheme.pink)
                            .frame(width: 64)
                    }
                }
                statusDot
            }
            .padding(.horizontal, 12)
        }
        .onHover { hovering in model.isHovering = hovering }
        .onTapGesture { model.isPanelOpen.toggle() }
    }

    private func spriteCacheKey(pet: PetState, frames: [PixelGrid]) -> String {
        "\(pet.species.rawValue)-\(pet.stage.rawValue)-\(model.visualState.rawValue)-\((model.frameIndex / 2) % max(frames.count, 1))"
    }

    private func petTitle(_ pet: PetState) -> String {
        pet.stage == .egg ? "??? 의 알" : "\(pet.species.koreanName) Lv.\(pet.level)"
    }

    private var statusDot: some View {
        Circle()
            .fill(dotColor)
            .frame(width: 7, height: 7)
            .opacity(model.visualState == .critical && model.frameIndex % 2 == 0 ? 0.2 : 1)
    }

    private var dotColor: Color {
        switch model.visualState {
        case .working: .green
        case .critical: .red
        case .hungry: .orange
        default: .gray
        }
    }

}
