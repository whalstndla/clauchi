import Foundation
import Testing
@testable import ClauchiCore

// 2026-06-06(토) 09:00 UTC
let saturday9am = Date(timeIntervalSince1970: 1_780_736_400)

@Test func noDecayOnRestWeekday() {
    let settings = GameSettings(restWeekdays: [1, 7], vacationMode: false,
                                dialogueAIEnabled: true, launchAtLogin: false)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: settings))
    runTicks(engine, from: saturday9am, duration: 3600)
    #expect(engine.state.pet.satiety == 100)
}

@Test func noDecayAndNoDeathTimerOnVacation() {
    let settings = GameSettings(restWeekdays: [], vacationMode: true,
                                dialogueAIEnabled: true, launchAtLogin: false)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 0, settings: settings))
    let outputs = runTicks(engine, from: TestSupport.weekday9am, duration: 7 * 3600)
    #expect(engine.state.pet.criticalAccumulatedSeconds == 0)
    #expect(!outputs.contains { if case .petDied = $0 { true } else { false } })
}

@Test func vacationReturnSpeaks() {
    let engine = TestSupport.makeEngine()
    _ = engine.setVacation(true)
    #expect(engine.state.settings.vacationMode)
    let outputs = engine.setVacation(false)
    #expect(outputs == [.speak(.vacationReturn)])
}

@Test func visualStatePriorities() {
    let t = TestSupport.weekday9am
    // 휴가 > 위독
    let vacationEngine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 0, settings: GameSettings(
            restWeekdays: [], vacationMode: true, dialogueAIEnabled: true, launchAtLogin: false)))
    #expect(vacationEngine.visualState(now: t) == .vacation)

    // 위독 > 작업
    let criticalEngine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 0))
    _ = criticalEngine.handle(ClaudeEvent(ts: t, event: .toolUse, sessionId: "s1", cwd: nil))
    #expect(criticalEngine.visualState(now: t.addingTimeInterval(1)) == .critical)

    // 작업 중 (toolUse 후 30초 이내)
    let workingEngine = TestSupport.makeEngine()
    _ = workingEngine.handle(ClaudeEvent(ts: t, event: .toolUse, sessionId: "s1", cwd: nil))
    #expect(workingEngine.visualState(now: t.addingTimeInterval(10)) == .working)
    // 30초 지나면 작업 해제 → 마지막 활동 10분 전이면 idle
    #expect(workingEngine.visualState(now: t.addingTimeInterval(60)) == .idle)

    // 10분 무활동 → 잠
    #expect(workingEngine.visualState(now: t.addingTimeInterval(700)) == .sleeping)

    // 알
    let eggEngine = TestSupport.makeEngine(state: TestSupport.makeState(stage: .egg, level: 0))
    #expect(eggEngine.visualState(now: t) == .egg)
}

@Test func debugCommandsWork() {
    let engine = TestSupport.makeEngine()
    _ = engine.debugApply(.setSatiety(0), now: TestSupport.weekday9am)
    #expect(engine.state.pet.satiety == 0)
    let outputs = engine.debugApply(.grantExp(10 * 15), now: TestSupport.weekday9am)
    #expect(outputs.contains(.leveledUp(16)))   // makeState 기본 Lv.15, 150 EXP = 다음 레벨 비용
}
