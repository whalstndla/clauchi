import Testing
@testable import ClauchiCore

@Test func skipsWhenEitherMalformed() {
    #expect(ReleaseVersionChecker.status(installed: nil, latest: "0.1.0") == .skip)
    #expect(ReleaseVersionChecker.status(installed: "abc", latest: "0.1.0") == .skip)
    #expect(ReleaseVersionChecker.status(installed: "0.1.0", latest: nil) == .skip)
    #expect(ReleaseVersionChecker.status(installed: "0.1.0", latest: "v1") == .skip)
}

@Test func upToDateWhenEqualOrPadded() {
    #expect(ReleaseVersionChecker.status(installed: "0.1.0", latest: "0.1.0") == .upToDate)
    #expect(ReleaseVersionChecker.status(installed: "0.1", latest: "0.1.0") == .upToDate)
}

@Test func updateAvailableWhenLatestHigher() {
    #expect(ReleaseVersionChecker.status(installed: "0.1.0", latest: "0.2.0")
            == .updateAvailable(version: "0.2.0"))
    #expect(ReleaseVersionChecker.status(installed: "0.1.0", latest: "0.1.1")
            == .updateAvailable(version: "0.1.1"))
}

@Test func comparesNumericallyNotLexically() {
    #expect(ReleaseVersionChecker.status(installed: "0.9.0", latest: "0.10.0")
            == .updateAvailable(version: "0.10.0"))
}

@Test func skipsWhenLatestLower() {
    #expect(ReleaseVersionChecker.status(installed: "0.2.0", latest: "0.1.0") == .skip)
}
