import Testing
@testable import ClauchiCore

@Test func packageBuilds() {
    let config = GameConfig()
    #expect(type(of: config) == GameConfig.self)
}
