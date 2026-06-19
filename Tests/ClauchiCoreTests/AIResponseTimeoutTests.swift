import Foundation
import Testing
@testable import ClauchiCore

// AI 응답 대기 한도 — 사용자가 직접 기다리는 말걸기는 더 길게, 자동 발화는 짧게

@Test func talkedHasLongerTimeout() {
    #expect(DialogueSituation.talked.aiResponseTimeoutSeconds == 4.0)
}

@Test func automaticSituationsUseShortTimeout() {
    #expect(DialogueSituation.greeting.aiResponseTimeoutSeconds == 1.5)
    #expect(DialogueSituation.promptReaction.aiResponseTimeoutSeconds == 1.5)
    #expect(DialogueSituation.hungryWarning.aiResponseTimeoutSeconds == 1.5)
}

@Test func talkedTimeoutIsLongerThanOthers() {
    let talked = DialogueSituation.talked.aiResponseTimeoutSeconds
    for situation in DialogueSituation.allCases where situation != .talked {
        #expect(situation.aiResponseTimeoutSeconds < talked)
    }
}
