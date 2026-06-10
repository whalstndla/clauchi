import Foundation
import Testing
@testable import ClauchiCore

@Test func rerollReplacesBabyWithNewEggExcludingCurrentSpecies() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 5, species: .rat),
        hatchPool: [.rat, .ox], random: { 0 })
    let outputs = engine.reroll(now: TestSupport.weekday9am)
    #expect(outputs == [.speak(.rerolled)])
    #expect(engine.state.pet.stage == .egg)
    #expect(engine.state.pet.species == .ox)    // 같은 종은 제외하고 뽑는다
    #expect(engine.state.pet.level == 0)
    #expect(engine.state.collection.isEmpty)    // 리세마라는 기록을 남기지 않는다
}

@Test func rerollWorksOnEggToo() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .egg, level: 0, species: .rat),
        hatchPool: [.rat, .ox, .tiger], random: { 0 })
    _ = engine.reroll(now: TestSupport.weekday9am)
    #expect(engine.state.pet.species != .rat)
}

@Test func rerollNotAllowedForAdult() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .adult, level: 15, species: .tiger))
    let outputs = engine.reroll(now: TestSupport.weekday9am)
    #expect(outputs.isEmpty)
    #expect(engine.state.pet.stage == .adult)
    #expect(engine.state.pet.species == .tiger)
}

@Test func rerollKeepsSameSpeciesWhenOnlyCandidate() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .egg, level: 0, species: .rat),
        hatchPool: [.rat], random: { 0 })
    _ = engine.reroll(now: TestSupport.weekday9am)
    #expect(engine.state.pet.species == .rat)   // 후보가 하나뿐이면 같은 종 허용
}
