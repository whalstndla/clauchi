import SwiftUI
import ClauchiCore

// 12지 도감 — 완성 ⭐ / 사망 🪦 / 현재 🐣 / 미발견 ? (스펙 §7)
struct CollectionView: View {
    @Bindable var model: AppModel

    var body: some View {
        let records = model.engine.state.collection
        let currentSpecies = model.engine.state.pet.species
        let currentStage = model.engine.state.pet.stage
        let currentPersonality = model.engine.state.pet.personality

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
                    if let cellPersonality = personality(
                        for: species, isCurrent: isCurrent, current: currentPersonality,
                        records: records), graduated || died || isCurrent {
                        Text(cellPersonality.koreanName)
                            .font(.system(size: 8, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                            .lineLimit(1)
                    }

                    // 현재 펫이면 현재 레벨, 아니면 졸업/사망 기록의 레벨·생존일수·커스텀 이름
                    if isCurrent {
                        Text("Lv.\(model.engine.state.pet.level)")
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundStyle(CuteTheme.yellow.opacity(0.7))
                            .lineLimit(1)
                    } else if let record = records.last(where: { $0.species == species }),
                              graduated || died {
                        if let customName = record.customName {
                            Text(customName)
                                .font(.system(size: 8, design: .rounded))
                                .foregroundStyle(CuteTheme.cream.opacity(0.6))
                                .lineLimit(1)
                        }
                        Text("Lv.\(record.finalLevel) · \(record.daysLived)일")
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.4))
                            .lineLimit(1)
                    }
                }
                .padding(.vertical, 8)
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

    // 칸에 표시할 성격 — 현재 펫이면 현재 성격, 아니면 그 종의 가장 최근 기록 성격
    private func personality(for species: Species, isCurrent: Bool,
                             current: Personality,
                             records: [CollectionRecord]) -> Personality? {
        if isCurrent { return current }
        return records.last(where: { $0.species == species })?.personality
    }
}
