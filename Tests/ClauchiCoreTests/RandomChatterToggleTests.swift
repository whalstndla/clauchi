import Foundation
import Testing
@testable import ClauchiCore

// 랜덤 잡담 설정 게이트 — 같은 조건에서 켜짐은 발화, 꺼짐은 억제
private func chatterFires(enabled: Bool) -> Bool {
    let settings = GameSettings(restWeekdays: [], vacationMode: false,
                                dialogueAIEnabled: true, launchAtLogin: false,
                                randomChatterEnabled: enabled)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(stage: .baby, level: 3, settings: settings),
        random: { 0 })
    let outputs = engine.debugAdvance(seconds: 60, from: TestSupport.weekday9am)
    return outputs.contains(.speak(.randomChatter))
}

@Test func randomChatterEnabledFires() {
    #expect(chatterFires(enabled: true))
}

@Test func randomChatterDisabledSuppressed() {
    #expect(!chatterFires(enabled: false))
}

// 배고프면(포만감 ≤ hungryThreshold) 잡담 억제 — 톤 일관성
@Test func hungryPetSuppressesChatter() {
    let settings = GameSettings(restWeekdays: [], vacationMode: false,
                                dialogueAIEnabled: true, launchAtLogin: false,
                                randomChatterEnabled: true)
    // 포만감 10 (hungryThreshold 20 이하) — 잡담 조건 충족해도 억제돼야
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 10, stage: .baby, level: 3, settings: settings),
        random: { 0 })
    let outputs = engine.debugAdvance(seconds: 60, from: TestSupport.weekday9am)
    #expect(!outputs.contains(.speak(.randomChatter)))
}
