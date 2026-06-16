import Foundation
import Testing
@testable import ClauchiCore

// 오프라인 프롬프트 반응 — 작업 키워드에 맞는 대사를 우선 선택

@Test func bugKeywordMatches() {
    #expect(TemplateDialogueProvider.keywordReaction(for: "이 버그 좀 고쳐줘")?.contains("버그") == true)
    #expect(TemplateDialogueProvider.keywordReaction(for: "fix the error")?.contains("버그") == true)
}

@Test func deployKeywordMatches() {
    #expect(TemplateDialogueProvider.keywordReaction(for: "릴리즈 준비하자")?.contains("배포") == true)
}

@Test func noKeywordReturnsNil() {
    #expect(TemplateDialogueProvider.keywordReaction(for: "오늘 점심 뭐 먹지") == nil)
}

@Test func promptReactionUsesKeywordLine() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .promptReaction, petName: "냥이",
                                  stage: .baby, level: 3, satiety: 80,
                                  userPrompt: "테스트 코드 짜줘")
    let line = await provider.line(for: context)
    #expect(line.contains("테스트"))
}

@Test func promptReactionFallsBackWhenNoKeyword() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .promptReaction, petName: "냥이",
                                  stage: .baby, level: 3, satiety: 80,
                                  userPrompt: "음 그냥 이것저것")
    let line = await provider.line(for: context)
    #expect(!line.isEmpty)   // 일반 풀로 폴백
}
