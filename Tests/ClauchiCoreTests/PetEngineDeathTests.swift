import Foundation
import Testing
@testable import ClauchiCore

@Test func petDiesAfterSixCriticalHours() {
    let engine = TestSupport.makeEngine(
        state: TestSupport.makeState(satiety: 0, species: .tiger),
        hatchPool: [.rat, .tiger], random: { 0 })
    let outputs = runTicks(engine, from: TestSupport.weekday9am, duration: 6 * 3600 + 60)
    let died = outputs.compactMap { output -> CollectionRecord? in
        if case .petDied(let record) = output { return record }
        return nil
    }
    #expect(died.count == 1)
    #expect(died[0].species == .tiger)
    #expect(died[0].result == .died)
    #expect(outputs.contains(.speak(.died)))
    // 사망 후 새 알 (죽은 tiger 도 풀에 남음 → random 0 → rat)
    #expect(engine.state.pet.stage == .egg)
    #expect(engine.state.collection.count == 1)
}

@Test func petSurvivesIfFedBeforeSixHours() {
    let engine = TestSupport.makeEngine(state: TestSupport.makeState(satiety: 0))
    let t = TestSupport.weekday9am
    runTicks(engine, from: t, duration: 5 * 3600)
    _ = engine.handle(TestSupport.stopEvent(at: t.addingTimeInterval(5 * 3600 + 1)))
    let outputs = runTicks(engine, from: t.addingTimeInterval(5 * 3600 + 2), duration: 2 * 3600)
    #expect(!outputs.contains { if case .petDied = $0 { true } else { false } })
    #expect(engine.state.collection.isEmpty)
}
