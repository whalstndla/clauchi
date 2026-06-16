import Foundation
import Testing
@testable import ClauchiCore

// 조기 졸업 — rerollLockLevel(기본 10) 이상에서만, 도감에 졸업 기록을 남기고 새 알로 교체

@Test func graduateEarlyBlockedBelowLockLevel() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 9, species: .tiger))
    let outputs = engine.graduateEarly(now: TestSupport.weekday9am)
    #expect(outputs.isEmpty)
    #expect(engine.state.pet.species == .tiger)       // 펫 그대로
    #expect(engine.state.collection.isEmpty)          // 기록 없음
}

@Test func graduateEarlyLeavesGraduatedRecordAndNewEgg() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 10, species: .tiger),
        hatchPool: [.rat, .ox])
    let outputs = engine.graduateEarly(now: TestSupport.weekday9am)

    #expect(engine.state.collection.count == 1)
    let record = engine.state.collection[0]
    #expect(record.species == .tiger)
    #expect(record.result == .graduated)              // 졸업⭐으로 기록
    #expect(record.finalLevel == 10)
    #expect(engine.state.pet.stage == .egg)           // 새 알로 교체
    // 졸업 출력·대사를 그대로 재사용
    #expect(outputs.contains(.petGraduated(record)))
    #expect(outputs.contains(.speak(.graduated)))
}

@Test func graduateEarlyCountsTowardCompletion() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 12, species: .tiger))
    _ = engine.graduateEarly(now: TestSupport.weekday9am)
    let stats = CollectionStats(records: engine.state.collection)
    #expect(stats.completedSpecies == 1)              // 완성률에 포함
}
