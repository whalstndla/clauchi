import Foundation
import Testing
@testable import ClauchiCore

@Test func newEggAssignsPersonalityFromRandom() {
    // random()==0 → 종 인덱스 0 + 성격 첫 케이스(cheerful)
    let pet = PetEngine.newEgg(collection: [], pool: [.rat], now: TestSupport.weekday9am,
                               random: { 0 })
    #expect(pet.personality == Personality.allCases.first)
}

@Test func rerollGivesEggAPersonality() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 5, species: .rat),
        hatchPool: [.rat, .ox], random: { 0 })
    _ = engine.reroll(now: TestSupport.weekday9am)
    #expect(engine.state.pet.stage == .egg)
    #expect(Personality.allCases.contains(engine.state.pet.personality))
}

@Test func graduatedRecordCarriesPersonality() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 29, exp: 289, species: .rat),
        hatchPool: [.rat, .ox], random: { 0 })
    // 졸업 직전 펫의 성격을 고정해 기록 복사를 검증
    engine.debugSetPersonality(.earnest)
    let outputs = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    let record = outputs.compactMap { output -> CollectionRecord? in
        if case .petGraduated(let record) = output { return record }
        return nil
    }.first
    #expect(record?.personality == .earnest)
}
