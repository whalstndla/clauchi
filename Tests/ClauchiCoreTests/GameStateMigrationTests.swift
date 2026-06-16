import Foundation
import Testing
@testable import ClauchiCore

// streakDays/lastStreakDay가 없는 구버전 세이브도 안전히 디코드(기본 0/nil)되어야 한다
@Test func gameStateDecodesOldSaveWithoutStreakFields() throws {
    let original = TestSupport.makeState()
    let encoded = try JSONEncoder.clauchi.encode(original)
    var dict = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
    dict.removeValue(forKey: "streakDays")
    dict.removeValue(forKey: "lastStreakDay")

    let stripped = try JSONSerialization.data(withJSONObject: dict)
    let decoded = try JSONDecoder.clauchi.decode(GameState.self, from: stripped)

    #expect(decoded.streakDays == 0)
    #expect(decoded.lastStreakDay == nil)
    #expect(decoded.pet == original.pet)   // 나머지 필드는 그대로
}

// 라운드트립 — 인코드 후 디코드하면 동일
@Test func gameStateRoundTripsWithStreak() throws {
    var state = TestSupport.makeState()
    state.streakDays = 7
    state.lastStreakDay = TestSupport.weekday9am
    let data = try JSONEncoder.clauchi.encode(state)
    let decoded = try JSONDecoder.clauchi.decode(GameState.self, from: data)
    #expect(decoded.streakDays == 7)
    #expect(decoded.lastStreakDay == TestSupport.weekday9am)
}
