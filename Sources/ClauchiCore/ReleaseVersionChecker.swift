import Foundation   // ComparisonResult

// 릴리스 업데이트 판정 결과
public enum ReleaseUpdateStatus: Equatable, Sendable {
    case upToDate
    case updateAvailable(version: String)
    case skip   // 파싱 실패 / 최신이 설치보다 낮음(다운그레이드 방지)
}

// git을 모르는 순수 semver 판정. installed/latest는 "x.y.z" (태그의 v 접두는 호출부에서 제거).
public enum ReleaseVersionChecker {
    public static func status(installed: String?, latest: String?) -> ReleaseUpdateStatus {
        guard let installedParts = parse(installed),
              let latest, let latestParts = parse(latest) else { return .skip }
        switch compare(latestParts, installedParts) {
        case .orderedDescending: return .updateAvailable(version: latest)
        case .orderedSame: return .upToDate
        case .orderedAscending: return .skip
        }
    }

    // "0.10.2" → [0, 10, 2]. 빈/숫자 아님 → nil
    static func parse(_ raw: String?) -> [Int]? {
        guard let raw, !raw.isEmpty else { return nil }
        let parts = raw.split(separator: ".", omittingEmptySubsequences: false)
        guard !parts.isEmpty else { return nil }
        var numbers: [Int] = []
        for part in parts {
            guard let number = Int(part), number >= 0 else { return nil }
            numbers.append(number)
        }
        return numbers
    }

    // 길이 다르면 짧은 쪽 0 패딩 후 수치 비교
    static func compare(_ a: [Int], _ b: [Int]) -> ComparisonResult {
        let count = max(a.count, b.count)
        for index in 0..<count {
            let x = index < a.count ? a[index] : 0
            let y = index < b.count ? b[index] : 0
            if x > y { return .orderedDescending }
            if x < y { return .orderedAscending }
        }
        return .orderedSame
    }
}
