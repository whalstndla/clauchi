import Foundation
import Testing
@testable import ClauchiCore

// 모든 상황이 비어있지 않은 템플릿을 ≥2개 가져야 한다 (랜덤 인덱싱 안전 + 반복感 방지)
@Test func everySituationHasAtLeastTwoNonEmptyTemplates() {
    for situation in DialogueSituation.allCases {
        let pool = TemplateDialogueProvider.pool(for: situation)
        #expect(pool.count >= 2, "\(situation) 템플릿이 2개 미만")
        #expect(pool.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
                "\(situation)에 빈 템플릿 존재")
    }
}

// 폴백 대사 생성이 어떤 상황에서도 빈 문자열을 내지 않는다 (결정적 random=0)
@Test func fallbackNeverReturnsEmpty() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    for situation in DialogueSituation.allCases {
        let context = DialogueContext(situation: situation, petName: "테스트",
                                      stage: .baby, level: 3, satiety: 50)
        let line = await provider.line(for: context)
        #expect(!line.isEmpty, "\(situation) 폴백이 빈 문자열")
    }
}
