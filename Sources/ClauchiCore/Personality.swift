import Foundation

// 종 무관 공통 성격 — 대사 색채에만 영향(게임 수치 불변). 부화 시 랜덤 배정.
public enum Personality: String, Codable, CaseIterable, Equatable, Sendable {
    case cheerful   // 명랑
    case shy        // 수줍음
    case aloof      // 새침(츤데레)
    case laidback   // 느긋
    case grumpy     // 까칠
    case quirky     // 엉뚱
    case earnest    // 진지
    case clingy     // 응석

    // UI(패널·도감) 표시용 이름
    public var koreanName: String {
        switch self {
        case .cheerful: "명랑"
        case .shy: "수줍음"
        case .aloof: "새침"
        case .laidback: "느긋"
        case .grumpy: "까칠"
        case .quirky: "엉뚱"
        case .earnest: "진지"
        case .clingy: "응석"
        }
    }

    // AI 프롬프트에 주입할 톤 묘사
    public var aiHint: String {
        switch self {
        case .cheerful: "밝고 에너지 넘치게"
        case .shy: "수줍고 머뭇거리게"
        case .aloof: "새침하고 솔직하지 못하게(츤데레)"
        case .laidback: "느긋하고 여유롭게"
        case .grumpy: "까칠하고 툴툴대게"
        case .quirky: "엉뚱하고 4차원스럽게"
        case .earnest: "진지하고 성실하게"
        case .clingy: "어리광 부리고 응석맞게"
        }
    }

    // 오프라인 폴백에서 한 겹 적용할 데코레이터(접두 또는 접미). 없으면 nil.
    public enum Decorator: Equatable {
        case prefix(String)
        case suffix(String)
    }
    public var decorator: Decorator? {
        switch self {
        case .cheerful: nil
        case .shy: .suffix("…")
        case .aloof: .prefix("흥, ")
        case .laidback: .prefix("음~ ")
        case .grumpy: .prefix("에휴, ")
        case .quirky: .prefix("어? ")
        case .earnest: nil
        case .clingy: .suffix("잉~")
        }
    }

    // 부화 시 랜덤 배정 — 주입된 random으로 결정적
    public static func random(_ random: () -> Double) -> Personality {
        let all = allCases
        let index = max(0, min(Int(random() * Double(all.count)), all.count - 1))
        return all[index]
    }

    // 레거시 세이브 복원 — bornAt 기반 결정적(랜덤 없이 안정)
    public static func deterministic(from bornAt: Date) -> Personality {
        let seconds = Int(bornAt.timeIntervalSince1970.rounded())
        let all = allCases
        let index = abs(seconds) % all.count
        return all[index]
    }
}
