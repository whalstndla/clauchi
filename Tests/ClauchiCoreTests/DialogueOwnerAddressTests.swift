import Foundation
import Testing
@testable import ClauchiCore

// 호칭 지침 — AI가 이름+일반호칭("민수야! 주인님!")을 섞지 않도록 단일 호칭만 주입한다.

private func ctx(name: String, gender: OwnerGender) -> DialogueContext {
    DialogueContext(situation: .greeting, petName: "초코", stage: .adult,
                    level: 5, satiety: 50, ownerName: name, ownerGender: gender)
}

@Test func ownerAddressUsesNameWhenSet() {
    let context = ctx(name: "민수", gender: .male)
    #expect(context.ownerHonorific == "민수")
    #expect(context.ownerAddressHint.contains("민수"))
    // 이름이 있으면 일반 호칭이 섞이면 안 된다
    #expect(!context.ownerAddressHint.contains("주인님"))
    #expect(!context.ownerAddressHint.contains("형"))
}

@Test func ownerAddressFallsBackToGenderHonorific() {
    #expect(ctx(name: "", gender: .male).ownerHonorific == "형")
    #expect(ctx(name: "", gender: .female).ownerHonorific == "언니")
    #expect(ctx(name: "", gender: .male).ownerAddressHint.contains("형"))
}

@Test func ownerAddressUnspecifiedUsesDefaultHonorific() {
    let context = ctx(name: "", gender: .unspecified)
    #expect(context.ownerHonorific == "주인님")
    #expect(context.ownerAddressHint.contains("주인님"))
}

@Test func personalityAIHintsAreDistinctAndNonEmpty() {
    let hints = Personality.allCases.map { $0.aiHint }
    #expect(hints.allSatisfy { !$0.isEmpty })
    #expect(Set(hints).count == Personality.allCases.count)
}
