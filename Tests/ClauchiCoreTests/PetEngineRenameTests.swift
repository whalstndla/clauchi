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
