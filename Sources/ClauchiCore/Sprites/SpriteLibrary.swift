import Foundation

public enum Expression: String, CaseIterable, Sendable { case happy, sad, critical }

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
    // 1차 구현 4종 (스펙 §8) — 종 추가 시 이 배열과 스프라이트 파일만 추가하면 됨
    public static let implementedSpecies: [Species] = [.rat, .ox, .tiger, .rabbit]

    public static let requiredSmallStates: [VisualState] =
        [.idle, .working, .sleeping, .hungry, .critical, .playing]

    // 종별 메인 색 (아기 틴트 + UI 포인트 컬러)
    public static func primaryColor(of species: Species) -> UInt32 {
        switch species {
        case .rat: 0x9CA3AFFF
        case .ox: 0xB45309FF
        case .tiger: 0xF59E42FF
        case .rabbit: 0xE5E7EBFF
        default: 0xF59E42FF   // 미구현 종은 부화 풀에 없어 도달 불가
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
        case .rat: RatSprites.set
        case .ox: OxSprites.set
        case .tiger: TigerSprites.set
        case .rabbit: RabbitSprites.set
        default: RatSprites.set
        }
    }
}
