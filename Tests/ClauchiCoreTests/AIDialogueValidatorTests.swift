import Foundation
import Testing
@testable import ClauchiCore

// AI 대사 후보 검증 — 부적합(빈값·영어·모델누수·과길이)은 nil(→폴백), 정상은 정제 후 통과

@Test func rejectsEmptyOrWhitespace() {
    #expect(AIDialogueValidator.cleanLine("") == nil)
    #expect(AIDialogueValidator.cleanLine("   \n  ") == nil)
}

@Test func rejectsNoHangul() {
    // 영어 거부문 — 한글이 없으면 폴백
    #expect(AIDialogueValidator.cleanLine("I cannot help with that.") == nil)
    #expect(AIDialogueValidator.cleanLine("123 !!!") == nil)
}

@Test func rejectsModelLeakage() {
    #expect(AIDialogueValidator.cleanLine("나는 언어 모델이라 몰라") == nil)
    #expect(AIDialogueValidator.cleanLine("As an AI, 나는 도와줄게") == nil)
}

@Test func joinsMultilineAndStripsQuotes() {
    #expect(AIDialogueValidator.cleanLine("\"안녕!\"") == "안녕!")
    #expect(AIDialogueValidator.cleanLine("안녕\n반가워") == "안녕 반가워")
}

@Test func collapsesExtraSpaces() {
    #expect(AIDialogueValidator.cleanLine("냠냠   맛있어") == "냠냠 맛있어")
}

@Test func truncatesOverLength() {
    let long = String(repeating: "가", count: 50)
    let result = AIDialogueValidator.cleanLine(long, maxLength: 40)
    #expect(result?.count == 40)
}

@Test func passesNormalKoreanLine() {
    #expect(AIDialogueValidator.cleanLine("냠냠 맛있어! 🍚") == "냠냠 맛있어! 🍚")
}
