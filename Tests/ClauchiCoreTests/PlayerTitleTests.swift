import Foundation
import Testing
@testable import ClauchiCore

// 칭호 임계값 경계 검증
@Test func titleTiers() {
    #expect(PlayerTitle.title(forLifetimeStops: 0) == "새내기 코더")
    #expect(PlayerTitle.title(forLifetimeStops: 49) == "새내기 코더")
    #expect(PlayerTitle.title(forLifetimeStops: 50) == "성실한 개발자")
    #expect(PlayerTitle.title(forLifetimeStops: 199) == "성실한 개발자")
    #expect(PlayerTitle.title(forLifetimeStops: 200) == "숙련 개발자")
    #expect(PlayerTitle.title(forLifetimeStops: 1000) == "베테랑 개발자")
    #expect(PlayerTitle.title(forLifetimeStops: 5000) == "코딩 마스터")
    #expect(PlayerTitle.title(forLifetimeStops: 99999) == "코딩 마스터")
}
