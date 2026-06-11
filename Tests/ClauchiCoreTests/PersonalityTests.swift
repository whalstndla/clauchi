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
    // 1_781_082_000 % 8 == 0 → 첫 케이스
    let born = Date(timeIntervalSince1970: 1_781_082_000)
    #expect(Personality.deterministic(from: born) == Personality.allCases[0])
    // +1초 → % 8 == 1 → 두 번째 케이스 (날짜가 다르면 다른 성격)
    let nextBorn = Date(timeIntervalSince1970: 1_781_082_001)
    #expect(Personality.deterministic(from: nextBorn) == Personality.allCases[1])
    #expect(Personality.deterministic(from: born) != Personality.deterministic(from: nextBorn))
}

@Test func somePersonalitiesHaveOfflineDecorator() {
    #expect(Personality.cheerful.decorator == nil)        // 데코 없음
    #expect(Personality.aloof.decorator == .prefix("흥, ")) // 접두
    #expect(Personality.shy.decorator == .suffix("…"))     // 접미
    #expect(Personality.clingy.decorator == .suffix("잉~"))
}
