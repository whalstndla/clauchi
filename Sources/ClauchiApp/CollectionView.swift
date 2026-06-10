import SwiftUI
import ClauchiCore

// 12지 도감 — 완성 ⭐ / 사망 🪦 / 현재 🐣 / 미발견 ? (스펙 §7)
struct CollectionView: View {
    @Bindable var model: AppModel

    var body: some View {
        let records = model.engine.state.collection
        let currentSpecies = model.engine.state.pet.species
        let currentStage = model.engine.state.pet.stage

        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
            ForEach(Species.allCases, id: \.rawValue) { species in
                let graduated = records.contains { $0.species == species && $0.result == .graduated }
                let died = records.contains { $0.species == species && $0.result == .died }
                let isCurrent = species == currentSpecies && currentStage != .egg

                VStack(spacing: 4) {
                    if graduated || isCurrent,
                       SpriteLibrary.implementedSpecies.contains(species),
                       let grid = SpriteLibrary.spriteSet(for: species, stage: .adult).large[.happy] {
                        Image(nsImage: SpriteImageFactory.image(
                            for: grid, cacheKey: "L-\(species.rawValue)-adult-happy"))
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 40, height: 40)
                            .saturation(isCurrent && !graduated ? 0.6 : 1)
                    } else {
                        Text(died ? "🪦" : "?")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .frame(width: 40, height: 40)
                    }
                    Text(badge(graduated: graduated, died: died, isCurrent: isCurrent,
                               name: species.koreanName))
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(CuteTheme.slot.opacity(0.6)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(graduated ? CuteTheme.yellow.opacity(0.7) : .clear,
                                      lineWidth: 1.5))
                .opacity(graduated || died || isCurrent ? 1 : 0.4)
            }
        }
    }

    private func badge(graduated: Bool, died: Bool, isCurrent: Bool, name: String) -> String {
        if graduated { return "⭐ \(name)" }
        if isCurrent { return "🐣 \(name)" }
        if died { return "🪦 \(name)" }
        return "???"
    }
}
