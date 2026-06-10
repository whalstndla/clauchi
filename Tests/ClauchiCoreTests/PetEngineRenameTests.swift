import Foundation
import Testing
@testable import ClauchiCore

@Test func renameTrimsAndStores() {
    let engine = TestSupport.makeEngine()
    engine.renamePet("  쿠키  ")
    #expect(engine.state.pet.customName == "쿠키")
}

@Test func renameCutsAtTwelveCharacters() {
    let engine = TestSupport.makeEngine()
    engine.renamePet("아주아주아주아주긴이름이다")   // 13자
    #expect(engine.state.pet.customName == "아주아주아주아주긴이름이")
}

@Test func renameEmptyRevertsToDefault() {
    let engine = TestSupport.makeEngine()
    engine.renamePet("쿠키")
    engine.renamePet("   ")
    #expect(engine.state.pet.customName == nil)
}

@Test func graduationRecordKeepsCustomName() {
    // Lv.29 → 졸업(Lv.30)에 EXP 290 필요 (10 × 29)
    let state = TestSupport.makeState(stage: .adult, level: 29, exp: 0)
    let engine = TestSupport.makeEngine(state: state)
    engine.renamePet("쿠키")
    _ = engine.debugApply(.grantExp(290), now: TestSupport.weekday9am)
    #expect(engine.state.collection.first?.customName == "쿠키")
    #expect(engine.state.pet.customName == nil)   // 새 알은 이름 리셋
}

@Test func deathRecordKeepsCustomName() {
    let state = TestSupport.makeState(satiety: 0, stage: .adult, level: 5, exp: 0)
    let engine = TestSupport.makeEngine(state: state)
    engine.renamePet("쿠키")
    // 포만감 0 상태로 사망 한계(6시간) 초과 경과 → die() 유도
    _ = engine.debugAdvance(seconds: 6 * 3600 + 60, from: TestSupport.weekday9am)
    #expect(engine.state.collection.first?.customName == "쿠키")
    #expect(engine.state.pet.customName == nil)   // 새 알은 이름 리셋
}
