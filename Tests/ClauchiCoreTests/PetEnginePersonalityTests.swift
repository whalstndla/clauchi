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
    // random: { 0 } → 성격 첫 케이스로 결정됨
    #expect(engine.state.pet.personality == Personality.allCases.first)
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

@Test func diedRecordCarriesPersonality() {
    // Death 테스트와 동일한 결정적 사망 시나리오 — satiety 0으로 6시간 경과
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 0, species: .tiger),
        hatchPool: [.rat, .tiger], random: { 0 })
    // 사망 직전 펫의 성격을 고정해 기록 복사를 검증
    engine.debugSetPersonality(.grumpy)
    let outputs = runTicks(engine, from: TestSupport.weekday9am, duration: 6 * 3600 + 60)
    let record = outputs.compactMap { output -> CollectionRecord? in
        if case .petDied(let record) = output { return record }
        return nil
    }.first
    #expect(record?.personality == .grumpy)
}
