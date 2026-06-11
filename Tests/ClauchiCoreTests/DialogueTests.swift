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

@Test func offlineAppendsSpeciesInterjectionForNormalSituation() async {
    // random 0 → 풀 첫 대사 + interjection 첫 항목("멍!")
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .greeting, petName: "멍멍이",
                                  stage: .baby, level: 1, satiety: 100,
                                  species: .dog, personality: .cheerful)
    let line = await provider.line(for: context)
    #expect(line.hasSuffix("멍!"))
}

@Test func offlineSkipsDecorationForSomberSituations() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .died, petName: "멍멍이",
                                  stage: .adult, level: 5, satiety: 0,
                                  species: .dog, personality: .aloof)
    let line = await provider.line(for: context)
    #expect(!line.contains("멍!"))   // 종 감탄사 미적용
    #expect(!line.hasPrefix("흥, ")) // 성격 데코 미적용
}

@Test func offlineAppliesPersonalityPrefixAndSpeciesInterjection() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .greeting, petName: "멍멍이",
                                  stage: .baby, level: 1, satiety: 100,
                                  species: .dog, personality: .aloof)
    let line = await provider.line(for: context)
    #expect(line.hasPrefix("흥, "))  // 새침 접두
    #expect(line.hasSuffix("멍!"))   // 강아지 감탄사
}

@Test func offlineAppliesPersonalitySuffixAfterInterjection() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .greeting, petName: "스르륵",
                                  stage: .baby, level: 1, satiety: 100,
                                  species: .snake, personality: .shy)
    let line = await provider.line(for: context)
    #expect(line.hasSuffix("…"))            // 수줍음 접미가 가장 끝
    #expect(line.contains("스르륵~"))        // 뱀 감탄사가 접미 앞
}

@Test func offlineSkipsDecorationForGraduatedSituation() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .graduated, petName: "멍멍이",
                                  stage: .adult, level: 5, satiety: 100,
                                  species: .dog, personality: .aloof)
    let line = await provider.line(for: context)
    #expect(!line.contains("멍!"))
    #expect(!line.hasPrefix("흥, "))
}
