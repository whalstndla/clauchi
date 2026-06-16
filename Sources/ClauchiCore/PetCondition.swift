import Foundation

// 포만감·기분을 종합한 한눈 컨디션 라벨 — 순수 파생 값(게임 수치엔 영향 없음).
// 임계값은 데이터로 모아 문구 조정 시 로직 변경이 없게 한다.
public enum PetCondition {
    // (평균 하한, 라벨) — 내림차순으로 첫 충족 항목 선택
    private static let tiers: [(minAverage: Double, label: String)] = [
        (80, "최상 컨디션 ✨"),
        (60, "기분 좋아 😊"),
        (40, "그럭저럭 😐"),
        (20, "시무룩 😟"),
        (0, "위급해요 😰"),
    ]

    public static func label(satiety: Double, mood: Double) -> String {
        let average = (satiety + mood) / 2
        for tier in tiers where average >= tier.minAverage { return tier.label }
        return tiers.last?.label ?? ""
    }
}
