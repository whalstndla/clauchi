import Foundation
import Testing
@testable import ClauchiCore

private let situations: [DialogueSituation] = [
    .greeting, .returnGreeting, .levelUp, .hatched, .evolvedToAdult, .graduated, .died,
    .hungryWarning, .criticalWarning, .permissionWaiting, .longWorkBreak,
    .randomChatter, .vacationReturn, .petted, .rerolled,
]

@Test func everySituationHasNonEmptySingleLinePool() {
    for situation in situations {
        let pool = TemplateDialogueProvider.pool(for: situation)
        #expect(!pool.isEmpty, "\(situation) 풀이 비어있음")
        for line in pool {
            #expect(!line.contains("\n"))
            #expect(!line.isEmpty)
        }
    }
}

@Test func placeholdersAreSubstituted() async {
    let provider = TemplateDialogueProvider(random: { 0 })   // 풀의 첫 대사 고정
    let context = DialogueContext(situation: .hatched, petName: "호랑이",
                                  stage: .baby, level: 1, satiety: 100)
    let line = await provider.line(for: context)
    #expect(line.contains("호랑이"))
    #expect(!line.contains("{name}"))
}

@Test func levelPlaceholderSubstituted() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .levelUp, petName: "호랑이",
                                  stage: .adult, level: 12, satiety: 80)
    let line = await provider.line(for: context)
    #expect(line.contains("12"))
    #expect(!line.contains("{level}"))
}

@Test func promptReactionPoolExists() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let line = await provider.line(for: DialogueContext(
        situation: .promptReaction, petName: "쿠키", stage: .adult, level: 5, satiety: 80))
    #expect(!line.isEmpty)
}

@Test func dialogueContextCarriesSpeciesAndPersonality() {
    let context = DialogueContext(situation: .greeting, petName: "멍멍이",
                                  stage: .baby, level: 1, satiety: 100,
                                  species: .dog, personality: .aloof)
    #expect(context.species == .dog)
    #expect(context.personality == .aloof)
}

@Test func dialogueContextDefaultsKeepExistingCallSitesCompiling() {
    // 종/성격 미지정 시 기본값으로 컴파일 (기존 호출부 호환)
    let context = DialogueContext(situation: .greeting, petName: "x",
                                  stage: .baby, level: 1, satiety: 100)
    #expect(context.species == .rat)
    #expect(context.personality == .cheerful)
}
