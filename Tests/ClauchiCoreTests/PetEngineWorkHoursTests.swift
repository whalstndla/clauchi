import Foundation
import Testing
@testable import ClauchiCore

// 근무시간(활동 시간대) — 근무 밖엔 펫도 같이 취침해 감쇠·기분·사망 타이머가 멈춘다.
// 시각은 모두 UTC 고정 달력(TestSupport) 기준. weekday9am = 2026-06-10(수) 09:00.

// 9~18시 근무 설정
private let nineToSix = GameSettings(
    restWeekdays: [], vacationMode: false, dialogueAIEnabled: true, launchAtLogin: false,
    workHoursEnabled: true, workStartHour: 9, workEndHour: 18)

private let wedOnHours = TestSupport.weekday9am.addingTimeInterval(5 * 3600)   // 14:00 (근무 중)
private let wedOffHours = TestSupport.weekday9am.addingTimeInterval(13 * 3600) // 22:00 (퇴근 후)

@Test func noDecayOutsideWorkHours() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nineToSix))
    runTicks(engine, from: wedOffHours, duration: 3600)
    #expect(engine.state.pet.satiety == 100)
}

@Test func decaysDuringWorkHours() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nineToSix))
    runTicks(engine, from: wedOnHours, duration: 3600)
    #expect(abs(engine.state.pet.satiety - 90) < 0.1)
}

@Test func noDeathTimerOutsideWorkHours() {
    // 포만감 0인 채 퇴근 후 7시간(사망 기준 6시간 초과) 방치해도 죽지 않아야 한다
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 0, settings: nineToSix))
    let outputs = runTicks(engine, from: wedOffHours, duration: 7 * 3600)
    #expect(engine.state.pet.criticalAccumulatedSeconds == 0)
    #expect(!outputs.contains { if case .petDied = $0 { true } else { false } })
}

@Test func moodFrozenOutsideWorkHours() {
    // 근무 밖엔 기분이 회복도 감소도 하지 않고 동결
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nineToSix, mood: 50))
    runTicks(engine, from: wedOffHours, duration: 3600)
    #expect(engine.state.pet.mood == 50)
}

@Test func feedingStillWorksOutsideWorkHours() {
    // 퇴근 후 작업하면(Stop) 급식은 그대로 들어가야 한다
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 50, settings: nineToSix))
    _ = engine.handle(TestSupport.stopEvent(at: wedOffHours))
    #expect(engine.state.pet.satiety > 50)
}

@Test func nightShiftWindowWrapsAroundMidnight() {
    // 22~6시 야간근무 — 02시는 근무 중(감쇠), 12시는 퇴근 후(정지)
    let nightShift = GameSettings(
        restWeekdays: [], vacationMode: false, dialogueAIEnabled: true, launchAtLogin: false,
        workHoursEnabled: true, workStartHour: 22, workEndHour: 6)
    let night2am = TestSupport.weekday9am.addingTimeInterval(-7 * 3600)  // 02:00 (근무 중)
    let noon = TestSupport.weekday9am.addingTimeInterval(3 * 3600)        // 12:00 (퇴근 후)

    let working = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nightShift))
    runTicks(working, from: night2am, duration: 3600)
    #expect(abs(working.state.pet.satiety - 90) < 0.1)

    let resting = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nightShift))
    runTicks(resting, from: noon, duration: 3600)
    #expect(resting.state.pet.satiety == 100)
}

@Test func startEqualsEndMeansAlwaysWorking() {
    // 출근==퇴근이면 기능 비활성(24시간 근무)로 간주 — 퇴근 시간대에도 감쇠
    let always = GameSettings(
        restWeekdays: [], vacationMode: false, dialogueAIEnabled: true, launchAtLogin: false,
        workHoursEnabled: true, workStartHour: 9, workEndHour: 9)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: always))
    runTicks(engine, from: wedOffHours, duration: 3600)
    #expect(abs(engine.state.pet.satiety - 90) < 0.1)
}

@Test func disabledKeepsDecayingOutsideHours() {
    // 기능 OFF면 시각 무관하게 기존처럼 감쇠 (init 기본값 보존 확인)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100))   // 기본 settings = workHoursEnabled false
    runTicks(engine, from: wedOffHours, duration: 3600)
    #expect(abs(engine.state.pet.satiety - 90) < 0.1)
}

@Test func visualStateSleepsOutsideWorkHours() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nineToSix))
    #expect(engine.visualState(now: wedOffHours) == .sleeping)
}

@Test func activeWorkBeatsOffHoursSleep() {
    // 퇴근 시간대라도 실제로 작업 중이면 '작업' 표시 (야간 작업자 배려)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 100, settings: nineToSix))
    _ = engine.handle(ClaudeEvent(ts: wedOffHours, event: .toolUse, sessionId: "s1", cwd: nil))
    #expect(engine.visualState(now: wedOffHours.addingTimeInterval(10)) == .working)
}

@Test func hungryBeatsOffHoursSleep() {
    // 배고픈 채 퇴근하면 다음날까지 배고픈 표정 유지(취침으로 가리지 않음)
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 10, settings: nineToSix))
    #expect(engine.visualState(now: wedOffHours) == .hungry)
}

@Test func oldSettingsSaveEnablesWorkHoursByDefault() throws {
    // 근무시간 필드가 없는 구버전 세이브는 기능 ON(9~18)으로 마이그레이션
    let original = GameSettings(restWeekdays: [1, 7], vacationMode: false,
                               dialogueAIEnabled: true, launchAtLogin: false)
    let encoded = try JSONEncoder.clauchi.encode(original)
    var dict = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
    dict.removeValue(forKey: "workHoursEnabled")
    dict.removeValue(forKey: "workStartHour")
    dict.removeValue(forKey: "workEndHour")
    let stripped = try JSONSerialization.data(withJSONObject: dict)
    let decoded = try JSONDecoder.clauchi.decode(GameSettings.self, from: stripped)
    #expect(decoded.workHoursEnabled)
    #expect(decoded.workStartHour == 9)
    #expect(decoded.workEndHour == 18)
}
