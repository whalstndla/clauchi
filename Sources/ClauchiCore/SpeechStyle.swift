import Foundation

// 종별 말투 데이터 — 게임 로직과 분리(스프라이트 패턴). 종 추가 = 이 테이블에 한 줄 추가.
public struct SpeechStyle: Equatable, Sendable {
    public var aiHint: String          // AI 프롬프트 주입용 종 말투 묘사
    public var interjections: [String] // 오프라인 폴백에서 문장 끝에 붙일 감탄사
    public init(aiHint: String, interjections: [String]) {
        self.aiHint = aiHint
        self.interjections = interjections
    }
}

public enum SpeciesSpeech {
    public static func style(for species: Species) -> SpeechStyle {
        switch species {
        case .rat: SpeechStyle(aiHint: "잽싸고 약삭빠른 쥐", interjections: ["찍!", "찍찍"])
        case .ox: SpeechStyle(aiHint: "느릿하고 우직한 소", interjections: ["음메", "끄응"])
        case .tiger: SpeechStyle(aiHint: "용맹하고 기개 있는 호랑이", interjections: ["어흥!", "크르릉"])
        case .rabbit: SpeechStyle(aiHint: "깡총거리고 발랄한 토끼", interjections: ["깡총!", "토토!"])
        case .dragon: SpeechStyle(aiHint: "위엄 있고 고풍스러운 용", interjections: ["허허", "이 몸이"])
        case .snake: SpeechStyle(aiHint: "말끝을 늘이는 능청스러운 뱀", interjections: ["스르륵~", "~지이"])
        case .horse: SpeechStyle(aiHint: "활기차고 질주하는 말", interjections: ["히힝!", "다그닥"])
        case .goat: SpeechStyle(aiHint: "순하고 부드러운 양", interjections: ["메에", "음메에"])
        case .monkey: SpeechStyle(aiHint: "장난기 많고 까부는 원숭이", interjections: ["끼끼!", "우끼"])
        case .rooster: SpeechStyle(aiHint: "아침형이고 자신만만한 닭", interjections: ["꼬끼오!", "꼬꼬"])
        case .dog: SpeechStyle(aiHint: "충직하고 활발한 강아지", interjections: ["멍!", "왈왈"])
        case .pig: SpeechStyle(aiHint: "먹보에 낙천적인 돼지", interjections: ["꿀!", "꿀꿀"])
        }
    }
}
