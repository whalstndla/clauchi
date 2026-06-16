import Foundation
import Testing
@testable import ClauchiCore

// {streak} 플레이스홀더가 실제 연속 일수로 치환되어야 한다
@Test func streakPlaceholderIsReplaced() async {
    let provider = TemplateDialogueProvider(random: { 0 })
    let context = DialogueContext(situation: .streakMilestone, petName: "냥이",
                                  stage: .adult, level: 12, satiety: 80,
                                  streakDays: 7)
    let line = await provider.line(for: context)
    #expect(line.contains("7"))
    #expect(!line.contains("{streak}"))
}
