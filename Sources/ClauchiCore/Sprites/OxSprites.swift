import Foundation

// 임시 구현 — Task 14~15에서 진짜 성체 도트로 교체
enum OxSprites {
    static let set: SpriteSet = BabySprites.set(tint: SpriteLibrary.primaryColor(of: .ox))
}
