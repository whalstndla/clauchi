import Foundation
import Testing
@testable import ClauchiCore

@Test func skipsWhenBuildCommitUnknown() {
    #expect(UpdateChecker.status(buildCommit: nil, remoteCommit: "abc",
                                 buildIsAncestorOfRemote: true) == .skip)
}

@Test func skipsWhenRemoteUnknown() {
    #expect(UpdateChecker.status(buildCommit: "abc", remoteCommit: nil,
                                 buildIsAncestorOfRemote: false) == .skip)
}

@Test func upToDateWhenEqual() {
    #expect(UpdateChecker.status(buildCommit: "abc", remoteCommit: "abc",
                                 buildIsAncestorOfRemote: false) == .upToDate)
}

@Test func updateAvailableWhenRemoteAhead() {
    #expect(UpdateChecker.status(buildCommit: "old", remoteCommit: "new",
                                 buildIsAncestorOfRemote: true)
            == .updateAvailable(remoteCommit: "new"))
}

@Test func skipsWhenRemoteBehindOrDiverged() {
    #expect(UpdateChecker.status(buildCommit: "x", remoteCommit: "y",
                                 buildIsAncestorOfRemote: false) == .skip)
}
