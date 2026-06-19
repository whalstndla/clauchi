import Foundation
import Testing
@testable import ClauchiCore

// 말걸기(.talked) — 메시지 의도에 맞는 반응을 우선 선택해 대화처럼 느껴지게 한다

@Test func greetingMatches() {
    #expect(TemplateDialogueProvider.talkReaction(for: "안녕")?.contains("반가") == true)
    #expect(TemplateDialogueProvider.talkReaction(for: "hello there")?.contains("반가") == true)
}

@Test func complimentMatches() {
    #expect(TemplateDialogueProvider.talkReaction(for: "너 진짜 귀엽다")?.contains("고마워") == true)
}

@Test func thanksMatches() {
    #expect(TemplateDialogueProvider.talkReaction(for: "고마워!")?.contains("천만에") == true)
}

@Test func tiredMatches() {
    #expect(TemplateDialogueProvider.talkReaction(for: "오늘 너무 힘들었어")?.contains("고생") == true)
}

@Test func noIntentReturnsNil() {
    #expect(TemplateDialogueProvider.talkReaction(for: "오늘 하늘이 파랗다") == nil)
}

@Test func talkedUsesIntentReaction() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .talked, petName: "냥이",
                                  stage: .baby, level: 3, satiety: 80,
                                  userPrompt: "안녕!")
    let line = await provider.line(for: context)
    #expect(line.contains("반가"))
}

@Test func talkedFallsBackWhenNoIntent() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .talked, petName: "냥이",
                                  stage: .baby, level: 3, satiety: 80,
                                  userPrompt: "오늘 하늘이 파랗다")
    let line = await provider.line(for: context)
    #expect(!line.isEmpty)   // 일반 풀로 폴백
}
