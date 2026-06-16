import Foundation
import Testing
@testable import ClauchiCore

// 변경 로그 데이터 — 비어있지 않고, 최신 버전이 맨 앞, 각 항목에 변경 내역 존재
@Test func changelogIsNonEmptyAndDescending() {
    let entries = Changelog.entries
    #expect(!entries.isEmpty)
    #expect(entries.allSatisfy { !$0.changes.isEmpty })
    #expect(entries.allSatisfy { !$0.version.isEmpty })
    // 버전이 내림차순(최신 먼저)인지 — 단순 문자열 비교 대신 컴포넌트 비교
    let versions = entries.map { $0.version }
    let sorted = versions.sorted { lhs, rhs in
        lhs.compare(rhs, options: .numeric) == .orderedDescending
    }
    #expect(versions == sorted)
}

@Test func changelogTopIsCurrentRelease() {
    #expect(Changelog.entries.first?.version == "0.3.7")
}
