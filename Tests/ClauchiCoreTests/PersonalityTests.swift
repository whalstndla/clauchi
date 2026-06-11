import Foundation
import Testing
@testable import ClauchiCore

@Test func everyPersonalityHasKoreanNameAndAIHint() {
    #expect(Personality.allCases.count == 8)
    for personality in Personality.allCases {
        #expect(!personality.koreanName.isEmpty)
        #expect(!personality.aiHint.isEmpty)
    }
}

@Test func randomPersonalityIsDeterministicWithInjectedRandom() {
    // random()==0 → 첫 케이스, 0.99 → 마지막 케이스
    #expect(Personality.random({ 0 }) == Personality.allCases.first)
    #expect(Personality.random({ 0.99 }) == Personality.allCases.last)
}

@Test func deterministicPersonalityIsStablePerBornAt() {
    let born = Date(timeIntervalSince1970: 1_781_082_000)
    #expect(Personality.deterministic(from: born) == Personality.deterministic(from: born))
}

@Test func somePersonalitiesHaveOfflineDecorator() {
    #expect(Personality.cheerful.decorator == nil)        // 데코 없음
    #expect(Personality.aloof.decorator == .prefix("흥, ")) // 접두
    #expect(Personality.shy.decorator == .suffix("…"))     // 접미
}
