import Foundation
import Testing
@testable import ClauchiCore

@Test func pettingRaisesMoodWithPerMinuteCap() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(mood: 50))
    let t = TestSupport.weekday9am
    let first = engine.petPet(now: t)
    #expect(first.contains(.petted))
    #expect(engine.state.pet.mood == 60)
    _ = engine.petPet(now: t.addingTimeInterval(10))   // +10 (분당 20 도달)
    #expect(engine.state.pet.mood == 70)
    _ = engine.petPet(now: t.addingTimeInterval(20))   // +0 (상한)
    #expect(engine.state.pet.mood == 70)
}

@Test func eggCannotBePetted() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .egg, level: 0, mood: 50))
    let outputs = engine.petPet(now: TestSupport.weekday9am)
    #expect(outputs.isEmpty)
    #expect(engine.state.pet.mood == 50)
}

@Test func moodDecaysAndExtraWhenHungry() {
    // 평시: 시간당 -5
    let normalEngine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 100, mood: 50))
    runTicks(normalEngine, from: TestSupport.weekday9am, duration: 3600)
    #expect(abs(normalEngine.state.pet.mood - 45) < 0.1)

    // 배고픔(≤20): 시간당 -5 -10 = -15
    let hungryEngine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 15, mood: 50))
    runTicks(hungryEngine, from: TestSupport.weekday9am, duration: 3600)
    #expect(abs(hungryEngine.state.pet.mood - 35) < 0.2)
}

@Test func happyMoodGivesExpBonus() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 1, exp: 0, mood: 80))
    _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    #expect(engine.state.pet.exp == 6)   // 5 + 행복 보너스 1
}

@Test func restDayRaisesMoodAndVacationFreezesIt() {
    let restSettings = GameSettings(restWeekdays: [1, 7], vacationMode: false,
                                    dialogueAIEnabled: true, launchAtLogin: false)
    let restEngine = TestSupport.makeEngine(
        state: TestSupport.makeState(settings: restSettings, mood: 50))
    runTicks(restEngine, from: saturday9am, duration: 3600)
    #expect(abs(restEngine.state.pet.mood - 55) < 0.1)

    let vacationSettings = GameSettings(restWeekdays: [], vacationMode: true,
                                        dialogueAIEnabled: true, launchAtLogin: false)
    let vacationEngine = TestSupport.makeEngine(
        state: TestSupport.makeState(settings: vacationSettings, mood: 50))
    runTicks(vacationEngine, from: TestSupport.weekday9am, duration: 3600)
    #expect(vacationEngine.state.pet.mood == 50)
}

@Test func levelUpBoostsMood() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 1, exp: 8, mood: 50))
    _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    // 밥 +2, 레벨업 +15
    #expect(engine.state.pet.mood == 67)
}

@Test func legacyStateWithoutMoodDecodes() throws {
    // v1 세이브에는 mood 필드가 없다 — 기본값 80으로 마이그레이션 (스펙 §9)
    let json = #"{"species":"rat","stage":"baby","level":2,"exp":3,"satiety":50,"bornAt":"2026-06-10T00:00:00Z","criticalAccumulatedSeconds":0}"#
    let pet = try JSONDecoder.clauchi.decode(PetState.self, from: Data(json.utf8))
    #expect(pet.mood == 80)
}
