import Foundation
import Testing
@testable import ClauchiCore

// 펫 일지 — 하이라이트 기록 + 상한 적용

@Test func hatchIsLogged() {
    // 알(exp 29) + Stop(+5) → 부화 → 일지에 부화 기록
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 50, stage: .egg, level: 0, exp: 29))
    _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am))
    #expect(engine.state.petLog.contains { $0.text.contains("부화") })
}

@Test func graduationIsLogged() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 50, stage: .adult, level: 12))
    _ = engine.graduateEarly(now: TestSupport.weekday9am)
    #expect(engine.state.petLog.contains { $0.text.contains("졸업") })
}

@Test func logRespectsMaxEntries() {
    // 상한을 넘겨 기록해도 최신 N개만 유지
    var state = TestSupport.makeState(satiety: 50, stage: .adult, level: 12)
    // 미리 상한 가까이 채워두고 졸업 한 번 더 추가
    state.petLog = (0..<60).map { PetLogEntry(date: TestSupport.weekday9am, text: "old \($0)") }
    let engine = TestSupport.makeEngine(state: state)
    _ = engine.graduateEarly(now: TestSupport.weekday9am)
    #expect(engine.state.petLog.count <= engine.config.petLogMaxEntries)
    #expect(engine.state.petLog.last?.text.contains("졸업") == true)   // 최신은 졸업
}

@Test func roundLevelIsLogged() {
    // Lv.9 + 큰 EXP → Lv.10 도달 → 일지에 'Lv.10 달성'
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, stage: .adult, level: 9, exp: 0))
    // expToNextLevel(9)=90 만큼 채우면 Lv.10. Stop으로 EXP 누적
    for i in 0..<30 {
        _ = engine.handle(TestSupport.stopEvent(at: TestSupport.weekday9am.addingTimeInterval(Double(i) * 60)))
    }
    #expect(engine.state.pet.level >= 10)
    #expect(engine.state.petLog.contains { $0.text.contains("Lv.10 달성") })
}
