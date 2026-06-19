import Foundation
import Testing
@testable import ClauchiCore

// AI 타임아웃 안내 — 말걸기에 한해 "너무 어려웠어" 식 귀여운 둘러대기, 그 외는 nil(일반 폴백)

private func ctx(_ situation: DialogueSituation) -> DialogueContext {
    DialogueContext(situation: situation, petName: "초코", stage: .adult,
                    level: 5, satiety: 50, userPrompt: "양자컴퓨팅 원리 설명해줘")
}

@Test func timeoutLineNilForNonTalked() {
    let provider = TemplateDialogueProvider(random: { 0 })
    #expect(provider.timeoutLine(for: ctx(.greeting)) == nil)
    #expect(provider.timeoutLine(for: ctx(.promptReaction)) == nil)
}

@Test func timeoutLineForTalkedIsCuteApology() {
    let provider = TemplateDialogueProvider(random: { 0 })   // 풀 첫 줄 선택
    let line = provider.timeoutLine(for: ctx(.talked))
    #expect(line != nil)
    #expect(line?.isEmpty == false)
    #expect(line?.contains("어려") == true)   // random 0 → "…좀 어려운 말이야"
}

@Test func defaultTimeoutLineIsNil() {
    // 프로토콜 기본 구현은 nil — Template만 말걸기 안내를 제공
    struct Bare: DialogueProviding {
        func line(for context: DialogueContext) async -> String { "x" }
    }
    #expect(Bare().timeoutLine(for: ctx(.talked)) == nil)
}
