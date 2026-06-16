import Foundation

// 누적 작업량에 따른 칭호 — 진행감을 주는 순수 파생 값(게임 수치엔 영향 없음).
// 임계값은 데이터 테이블로 모아 칭호 추가 시 로직 변경이 없게 한다.
public enum PlayerTitle {
    // (최소 누적 작업수, 칭호) — 내림차순으로 첫 충족 항목을 고른다
    private static let tiers: [(threshold: Int, name: String)] = [
        (5000, "코딩 마스터"),
        (1000, "베테랑 개발자"),
        (200, "숙련 개발자"),
        (50, "성실한 개발자"),
        (0, "새내기 코더"),
    ]

    public static func title(forLifetimeStops stops: Int) -> String {
        for tier in tiers where stops >= tier.threshold { return tier.name }
        return tiers.last?.name ?? ""
    }
}
