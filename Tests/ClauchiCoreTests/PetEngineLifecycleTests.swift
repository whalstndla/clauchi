import Foundation
import Testing
@testable import ClauchiCore

@Test func eggHatchesAtThirtyExp() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .egg, level: 0))
    let t = TestSupport.weekday9am
    var outputs: [EngineOutput] = []
    for i in 0..<6 {   // 6 × 5 EXP = 30
        outputs += engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(Double(i) * 120)))
    }
    #expect(outputs.contains(.hatched(engine.state.pet.species)))
    #expect(outputs.contains(.speak(.hatched)))
    #expect(engine.state.pet.stage == .baby)
    #expect(engine.state.pet.level == 1)
    #expect(engine.state.pet.exp == 0)
}

@Test func levelUpConsumesExpAndEmitsOutput() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 1, exp: 8))
    let outputs = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    // 8 + 5 = 13 → Lv.1→2 (10 소모) → 잔여 3
    #expect(outputs.contains(.leveledUp(2)))
    #expect(outputs.contains(.speak(.levelUp)))
    #expect(engine.state.pet.level == 2)
    #expect(engine.state.pet.exp == 3)
}

@Test func babyEvolvesToAdultAtLevelTen() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 9, exp: 89))
    let outputs = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    // 89 + 5 = 94 ≥ 90 → Lv.10 진화
    #expect(outputs.contains(.speak(.evolvedToAdult)))
    #expect(engine.state.pet.stage == .adult)
}

@Test func adultGraduatesAtLevelThirtyAndNewEggExcludesGraduated() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 29, exp: 289, species: .rat),
        hatchPool: [.rat, .ox],
        random: { 0 })   // 항상 풀의 첫 번째 선택
    let outputs = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    let graduated = outputs.compactMap { output -> CollectionRecord? in
        if case .petGraduated(let record) = output { return record }
        return nil
    }
    #expect(graduated.count == 1)
    #expect(graduated[0].species == .rat)
    #expect(graduated[0].finalLevel == 30)
    #expect(outputs.contains(.speak(.graduated)))
    #expect(engine.state.collection.count == 1)
    // 새 알: 졸업한 rat 제외 → ox
    #expect(engine.state.pet.stage == .egg)
    #expect(engine.state.pet.species == .ox)
}

@Test func hatchPoolResetsWhenAllGraduated() {
    let t = TestSupport.weekday9am
    let record = CollectionRecord(species: .rat, result: .graduated,
                                  daysLived: 1, finalLevel: 30, endedAt: t)
    let pet = PetEngine.newEgg(collection: [record], pool: [.rat], now: t, random: { 0 })
    #expect(pet.species == .rat)   // 전부 졸업이면 풀 전체에서 다시
}

@Test func diedSpeciesCanHatchAgain() {
    let t = TestSupport.weekday9am
    let record = CollectionRecord(species: .rat, result: .died,
                                  daysLived: 1, finalLevel: 3, endedAt: t)
    let pet = PetEngine.newEgg(collection: [record], pool: [.rat, .ox], now: t, random: { 0 })
    #expect(pet.species == .rat)   // 죽은 종은 재도전 가능
}
