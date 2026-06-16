import Foundation
import Testing
@testable import ClauchiCore

// 종합 컨디션 라벨 경계 — (포만감+기분)/2 평균 기준
@Test func conditionTiers() {
    #expect(PetCondition.label(satiety: 100, mood: 100) == "최상 컨디션 ✨")  // 평균 100
    #expect(PetCondition.label(satiety: 80, mood: 80) == "최상 컨디션 ✨")    // 평균 80 경계
    #expect(PetCondition.label(satiety: 80, mood: 60) == "기분 좋아 😊")      // 평균 70
    #expect(PetCondition.label(satiety: 50, mood: 50) == "그럭저럭 😐")       // 평균 50
    #expect(PetCondition.label(satiety: 30, mood: 30) == "시무룩 😟")         // 평균 30
    #expect(PetCondition.label(satiety: 10, mood: 0) == "위급해요 😰")        // 평균 5
}
