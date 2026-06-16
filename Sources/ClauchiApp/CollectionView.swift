import SwiftUI
import ClauchiCore

// 12지 도감 — 그리드 ↔ 상세 화면 전환 컨테이너 (스펙 §7 + 2026-06-16)
struct CollectionView: View {
    @Bindable var model: AppModel
    @State private var detailSpecies: Species?

    var body: some View {
        if let species = detailSpecies {
            CollectionDetailView(model: model, species: species) {
                detailSpecies = nil
            }
        } else {
            CollectionGridView(model: model) { species in
                detailSpecies = species
            }
        }
    }
}

// MARK: - 그리드 + 통계 헤더

// 완성 ⭐ / 사망 🪦 / 현재 🐣 / 미발견 ? — 발견된 칸만 탭 가능
private struct CollectionGridView: View {
    @Bindable var model: AppModel
    let onSelect: (Species) -> Void

    var body: some View {
        let records = model.engine.state.collection
        let currentSpecies = model.engine.state.pet.species
        let currentStage = model.engine.state.pet.stage
        let currentPersonality = model.engine.state.pet.personality
        let stats = CollectionStats(records: records)
        let gameState = model.engine.state

        VStack(spacing: 8) {
            // 통계 헤더 — 완성률 · 총 생존일수 · 총 사망
            HStack(spacing: 12) {
                statBadge("⭐", "\(stats.completedSpecies)/\(stats.totalSpecies)")
                statBadge("📅", "\(stats.totalDaysLived)일")
                statBadge("🪦", "\(stats.totalDeaths)")
            }
            // 누적 업적 — 연속 사용일 · 작업 · 급식 · 쓰다듬기
            HStack(spacing: 8) {
                statBadge("🔥", "\(gameState.streakDays)일")
                statBadge("⌨️", "\(gameState.lifetimeStops)")
                statBadge("🍚", "\(gameState.lifetimeManualFeeds)")
                statBadge("🤚", "\(gameState.lifetimePets)")
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                ForEach(Species.allCases, id: \.rawValue) { species in
                    let graduated = records.contains { $0.species == species && $0.result == .graduated }
                    let died = records.contains { $0.species == species && $0.result == .died }
                    let isCurrent = species == currentSpecies && currentStage != .egg
                    let isDiscovered = graduated || died || isCurrent

                    Button {
                        if isDiscovered { onSelect(species) }
                    } label: {
                        cell(species: species, graduated: graduated, died: died,
                             isCurrent: isCurrent,
                             personality: cellPersonality(for: species, isCurrent: isCurrent,
                                                          current: currentPersonality,
                                                          records: records))
                    }
                    .buttonStyle(.plain)
                    .disabled(!isDiscovered)
                }
            }
        }
    }

    private func statBadge(_ icon: String, _ value: String) -> some View {
        HStack(spacing: 3) {
            Text(icon).font(.system(size: 11))
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(CuteTheme.cream)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(CuteTheme.slot.opacity(0.6)))
    }

    @ViewBuilder
    private func cell(species: Species, graduated: Bool, died: Bool,
                      isCurrent: Bool, personality: Personality?) -> some View {
        VStack(spacing: 4) {
            CollectionSprite(species: species, graduated: graduated,
                             died: died, isCurrent: isCurrent)
            Text(badge(graduated: graduated, died: died, isCurrent: isCurrent,
                       name: species.koreanName))
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
            if let personality, graduated || died || isCurrent {
                Text(personality.koreanName)
                    .font(.system(size: 8, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
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

    private func badge(graduated: Bool, died: Bool, isCurrent: Bool, name: String) -> String {
        if graduated { return "⭐ \(name)" }
        if isCurrent { return "🐣 \(name)" }
        if died { return "🪦 \(name)" }
        return "???"
    }

    // 칸에 표시할 성격 — 현재 펫이면 현재 성격, 아니면 그 종의 가장 최근 기록 성격
    private func cellPersonality(for species: Species, isCurrent: Bool,
                                 current: Personality,
                                 records: [CollectionRecord]) -> Personality? {
        if isCurrent { return current }
        return records.last(where: { $0.species == species })?.personality
    }
}

// MARK: - 종 상세 화면

// 요약 헤더 + 기록 리스트 + 뒤로가기. 현재 그 종을 키우는 중이면 맨 위 '현재' 카드
private struct CollectionDetailView: View {
    @Bindable var model: AppModel
    let species: Species
    let onBack: () -> Void

    var body: some View {
        let records = model.engine.state.collection
            .filter { $0.species == species }
            .sorted { $0.endedAt > $1.endedAt }   // 최신순
        let summary = SpeciesSummary(species: species, records: records)
        let pet = model.engine.state.pet
        let isCurrent = pet.species == species && pet.stage != .egg

        VStack(spacing: 10) {
            // 뒤로가기
            HStack {
                Button(action: onBack) {
                    Text("← 도감")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(CuteTheme.yellow)
                }
                .buttonStyle(.plain)
                Spacer()
            }

            // 요약 헤더 — 스프라이트 + 종 이름 + 집계
            HStack(spacing: 10) {
                CollectionSprite(species: species,
                                 graduated: summary.graduatedCount > 0,
                                 died: summary.diedCount > 0, isCurrent: isCurrent)
                VStack(alignment: .leading, spacing: 3) {
                    Text(species.koreanName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("키운 횟수 \(summary.raisedCount) · ⭐\(summary.graduatedCount) · 🪦\(summary.diedCount)")
                        .font(.system(size: 9, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                    Text("최고 Lv.\(summary.bestLevel) · 총 \(summary.totalDaysLived)일")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(CuteTheme.cream.opacity(0.7))
                }
                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(CuteTheme.slot.opacity(0.6)))

            // 기록 리스트 (현재 카드 + 생애 기록) — 스크롤은 패널 외부 ScrollView가 담당
            VStack(spacing: 6) {
                if isCurrent {
                    currentCard(pet: pet)
                }
                ForEach(records.indices, id: \.self) { index in
                    recordRow(records[index])
                }
                if records.isEmpty && !isCurrent {
                    Text("아직 생애 기록이 없어요")
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.vertical, 8)
                }
            }
        }
    }

    // 현재 키우는 중인 개체 카드
    private func currentCard(pet: PetState) -> some View {
        let days = max(0, Calendar.current.dateComponents([.day],
                       from: pet.bornAt, to: Date()).day ?? 0)
        return HStack(spacing: 8) {
            Text("🐣").font(.system(size: 14))
            VStack(alignment: .leading, spacing: 2) {
                Text("현재 · \(pet.displayName)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Lv.\(pet.level) · \(days)일째 · \(pet.personality.koreanName)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(CuteTheme.green.opacity(0.8))
            }
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(CuteTheme.green.opacity(0.5), lineWidth: 1))
    }

    // 한 건의 생애 기록 행
    private func recordRow(_ record: CollectionRecord) -> some View {
        HStack(spacing: 8) {
            Text(record.result == .graduated ? "⭐" : "🪦").font(.system(size: 13))
            VStack(alignment: .leading, spacing: 2) {
                Text(record.customName ?? species.koreanName)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Text("Lv.\(record.finalLevel) · \(record.daysLived)일")
                    if let personality = record.personality {
                        Text("· \(personality.koreanName)")
                    }
                }
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            Text(Self.dateFormatter.string(from: record.endedAt))
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).fill(CuteTheme.slot.opacity(0.5)))
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        return formatter
    }()
}

// MARK: - 공용 스프라이트

// 도감 칸·상세 헤더 공용 — 구현된 종이면 성체 스프라이트, 아니면 🪦/? 폴백
private struct CollectionSprite: View {
    let species: Species
    let graduated: Bool
    let died: Bool
    let isCurrent: Bool

    var body: some View {
        if (graduated || isCurrent),
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
    }
}
