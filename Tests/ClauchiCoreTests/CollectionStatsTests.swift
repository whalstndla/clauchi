import Foundation
import Testing
@testable import ClauchiCore

// 도감 집계 순수 로직 — 완성률·총생존일·사망수, 종별 요약

private func record(_ species: Species, _ result: LifeResult,
                    days: Int, level: Int) -> CollectionRecord {
    CollectionRecord(species: species, result: result, daysLived: days,
                     finalLevel: level, endedAt: TestSupport.weekday9am)
}

@Test func emptyCollectionStats() {
    let stats = CollectionStats(records: [])
    #expect(stats.totalSpecies == Species.allCases.count)
    #expect(stats.completedSpecies == 0)
    #expect(stats.totalDaysLived == 0)
    #expect(stats.totalDeaths == 0)
}

@Test func completionCountsDistinctGraduatedSpecies() {
    // 같은 종(.tiger)을 두 번 졸업해도 완성 종 수는 1
    let records = [
        record(.tiger, .graduated, days: 3, level: 30),
        record(.tiger, .graduated, days: 5, level: 12),
        record(.rat, .died, days: 1, level: 4),
    ]
    let stats = CollectionStats(records: records)
    #expect(stats.completedSpecies == 1)              // 사망한 .rat은 미포함
    #expect(stats.totalDeaths == 1)
    #expect(stats.totalDaysLived == 9)                // 3 + 5 + 1
}

@Test func speciesSummaryAggregatesPerSpecies() {
    let records = [
        record(.tiger, .graduated, days: 3, level: 30),
        record(.tiger, .died, days: 5, level: 12),
        record(.rat, .graduated, days: 2, level: 30),
    ]
    let summary = SpeciesSummary(species: .tiger, records: records)
    #expect(summary.raisedCount == 2)
    #expect(summary.graduatedCount == 1)
    #expect(summary.diedCount == 1)
    #expect(summary.bestLevel == 30)                  // max(30, 12)
    #expect(summary.totalDaysLived == 8)              // 3 + 5
}

@Test func speciesSummaryEmptyWhenNoRecords() {
    let summary = SpeciesSummary(species: .ox, records: [])
    #expect(summary.raisedCount == 0)
    #expect(summary.bestLevel == 0)
}
