import Foundation

public enum Expression: String, CaseIterable, Sendable { case happy, sad, critical }

extension Expression {
    // 패널 큰 스프라이트 표정 결정 — 위급/배고픔만 명시적 부정 표정,
    // 그 외(수면·휴식·작업·평상)는 기분 기반(낮으면 슬픔, 아니면 행복).
    // 수면을 슬픔으로 보지 않는다 — 컨디션 좋은데 자는 펫이 슬퍼 보이던 문제 방지.
    public static func forState(_ visualState: VisualState,
                                mood: Double, sadThreshold: Double) -> Expression {
        switch visualState {
        case .critical: .critical
        case .hungry: .sad
        default: mood <= sadThreshold ? .sad : .happy
        }
    }
}

public struct SpriteSet: Sendable {
    public let small: [VisualState: [PixelGrid]]   // 16×16 상태별 프레임
    public let large: [Expression: PixelGrid]      // 32×32 표정 (토스트·확장 패널)
    public init(small: [VisualState: [PixelGrid]], large: [Expression: PixelGrid]) {
        self.small = small; self.large = large
    }

    // 상태에 맞는 프레임 — 없으면 idle → egg 순 폴백 (vacation 등 미정의 상태용)
    public func frames(for state: VisualState) -> [PixelGrid] {
        small[state] ?? small[.idle] ?? small[.egg] ?? []
    }
}

public enum SpriteLibrary {
    // 12지신 전종 구현 완료
    public static let implementedSpecies: [Species] = [
        .rat, .ox, .tiger, .rabbit, .dragon, .snake,
        .horse, .goat, .monkey, .rooster, .dog, .pig,
    ]

    public static let requiredSmallStates: [VisualState] =
        [.idle, .working, .sleeping, .hungry, .critical, .playing]

    // 종별 메인 색 (아기 틴트 + UI 포인트 컬러) — 스타일 C 팔레트의 몸색
    public static func primaryColor(of species: Species) -> UInt32 {
        switch species {
        case .rat:     0xD9DCE3FF
        case .ox:      0xE8C49CFF
        case .tiger:   0xF6A85CFF
        case .rabbit:  0xF5EDE3FF
        case .dragon:  0x8FD9A8FF
        case .snake:   0xBCD96CFF
        case .horse:   0xD8A06AFF
        case .goat:    0xF4F1EAFF
        case .monkey:  0xC98E5FFF
        case .rooster: 0xF5ECD7FF
        case .dog:     0xEFC07EFF
        case .pig:     0xF8C8CEFF
        }
    }

    public static func spriteSet(for species: Species, stage: Stage) -> SpriteSet {
        switch stage {
        case .egg: EggSprites.set
        case .baby: BabySprites.set(tint: primaryColor(of: species))
        case .adult: adultSet(for: species)
        }
    }

    private static func adultSet(for species: Species) -> SpriteSet {
        switch species {
        case .rat:     RatSprites.set
        case .ox:      OxSprites.set
        case .tiger:   TigerSprites.set
        case .rabbit:  RabbitSprites.set
        case .dragon:  DragonSprites.set
        case .snake:   SnakeSprites.set
        case .horse:   HorseSprites.set
        case .goat:    GoatSprites.set
        case .monkey:  MonkeySprites.set
        case .rooster: RoosterSprites.set
        case .dog:     DogSprites.set
        case .pig:     PigSprites.set
        }
    }
}
