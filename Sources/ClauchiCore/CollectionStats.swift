import Foundation

// 도감 전체 집계 — 순수 계산. UI/시계를 모른다 (PetEngine 순수성 철학과 동일).
public struct CollectionStats: Equatable, Sendable {
    public let totalSpecies: Int        // 전체 종 수 (12)
    public let completedSpecies: Int    // 졸업(.graduated) 기록이 있는 '서로 다른 종' 수
    public let totalDaysLived: Int      // 모든 기록의 생존일수 합
    public let totalDeaths: Int         // 사망(.died) 기록 수

    public init(records: [CollectionRecord]) {
        totalSpecies = Species.allCases.count
        let graduatedSpecies = Set(
            records.filter { $0.result == .graduated }.map { $0.species })
        completedSpecies = graduatedSpecies.count
        totalDaysLived = records.reduce(0) { $0 + $1.daysLived }
        totalDeaths = records.filter { $0.result == .died }.count
    }
}

// 한 종의 생애 집계 — 상세 화면 요약 헤더용. 순수 계산.
public struct SpeciesSummary: Equatable, Sendable {
    public let species: Species
    public let raisedCount: Int       // 그 종의 기록 수 (졸업 + 사망)
    public let graduatedCount: Int    // 졸업 횟수
    public let diedCount: Int         // 사망 횟수
    public let bestLevel: Int         // 최고 finalLevel (기록 없으면 0)
    public let totalDaysLived: Int    // 그 종의 생존일수 합

    public init(species: Species, records: [CollectionRecord]) {
        let mine = records.filter { $0.species == species }
        self.species = species
        raisedCount = mine.count
        graduatedCount = mine.filter { $0.result == .graduated }.count
        diedCount = mine.filter { $0.result == .died }.count
        bestLevel = mine.map(\.finalLevel).max() ?? 0
        totalDaysLived = mine.reduce(0) { $0 + $1.daysLived }
    }
}
