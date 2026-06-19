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
    // 톤뿐 아니라 '문장 구성'까지 바뀌도록 구체적인 말투 지시를 담는다(AI 경로용)
    public var aiHint: String {
        switch self {
        case .cheerful: "밝고 에너지 넘치게, 느낌표와 활기찬 표현을 듬뿍 담아"
        case .shy: "수줍게 머뭇거리며, 말끝을 흐리고 조심스러운 문장으로"
        case .aloof: "새침하게(츤데레), 퉁명스럽게 던지듯 말하되 속으론 챙기는 티를 내며"
        case .laidback: "느긋하고 여유롭게, 서두르지 않고 늘어지는 말투로"
        case .grumpy: "까칠하게, 툴툴대고 투덜대는 한마디로"
        case .quirky: "엉뚱하고 4차원스럽게, 예상 밖의 비유를 섞어"
        case .earnest: "진지하고 성실하게, 또박또박 정중한 문장으로"
        case .clingy: "어리광 부리며 응석맞게, 보채듯 매달리는 말투로"
        }
    }

    // 오프라인 폴백에서 한 겹 적용할 데코레이터(접두 또는 접미). 없으면 nil.
    public enum Decorator: Equatable, Sendable {
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
