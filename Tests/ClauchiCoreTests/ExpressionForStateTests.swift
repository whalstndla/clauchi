import Foundation
import Testing
@testable import ClauchiCore

// 표정 매핑 — 수면/휴식 등은 슬픔이 아니라 기분 기반
@Test func sleepingWithGoodMoodIsHappy() {
    // 버그 재현: 컨디션 좋은데 자는 펫이 슬퍼 보이던 문제
    #expect(Expression.forState(.sleeping, mood: 99, sadThreshold: 25) == .happy)
}

@Test func criticalAndHungryAreNegative() {
    #expect(Expression.forState(.critical, mood: 99, sadThreshold: 25) == .critical)
    #expect(Expression.forState(.hungry, mood: 99, sadThreshold: 25) == .sad)
}

@Test func lowMoodIsSadRegardlessOfIdleState() {
    #expect(Expression.forState(.idle, mood: 10, sadThreshold: 25) == .sad)
    #expect(Expression.forState(.sleeping, mood: 10, sadThreshold: 25) == .sad)
}

@Test func goodMoodIdleWorkingPlayingAreHappy() {
    #expect(Expression.forState(.idle, mood: 80, sadThreshold: 25) == .happy)
    #expect(Expression.forState(.working, mood: 80, sadThreshold: 25) == .happy)
    #expect(Expression.forState(.playing, mood: 80, sadThreshold: 25) == .happy)
}
