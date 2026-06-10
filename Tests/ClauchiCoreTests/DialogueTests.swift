import Foundation
import Testing
@testable import ClauchiCore

private let situations: [DialogueSituation] = [
    .greeting, .returnGreeting, .levelUp, .hatched, .evolvedToAdult, .graduated, .died,
    .hungryWarning, .criticalWarning, .permissionWaiting, .longWorkBreak,
    .randomChatter, .vacationReturn,
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
