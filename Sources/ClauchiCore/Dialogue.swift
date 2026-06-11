import Foundation

// 대사 생성 입력 (스펙 §6)
public struct DialogueContext: Equatable, Sendable {
    public var situation: DialogueSituation
    public var petName: String
    public var stage: Stage
    public var level: Int
    public var satiety: Int
    public var mood: Int
    public var userPrompt: String?
    public var species: Species
    public var personality: Personality
    public init(situation: DialogueSituation, petName: String,
                stage: Stage, level: Int, satiety: Int, mood: Int = 50,
                userPrompt: String? = nil,
                species: Species = .rat, personality: Personality = .cheerful) {
        self.situation = situation; self.petName = petName
        self.stage = stage; self.level = level; self.satiety = satiety
        self.mood = mood; self.userPrompt = userPrompt
        self.species = species; self.personality = personality
    }
}

public protocol DialogueProviding: Sendable {
    func line(for context: DialogueContext) async -> String
}

// 오프라인 폴백 — 상황별 템플릿 풀에서 랜덤 (스펙 §6)
public struct TemplateDialogueProvider: DialogueProviding {
    private let random: @Sendable () -> Double
    public init(random: @escaping @Sendable () -> Double = { Double.random(in: 0..<1) }) {
        self.random = random
    }

    public func line(for context: DialogueContext) async -> String {
        let pool = Self.pool(for: context.situation)
        let index = min(Int(random() * Double(pool.count)), pool.count - 1)
        let base = pool[index]
            .replacingOccurrences(of: "{name}", with: context.petName)
            .replacingOccurrences(of: "{level}", with: String(context.level))
        return decorate(base, for: context)
    }

    // 슬픈 상황엔 장난스러운 말끝/데코를 적용하지 않는다(원문 유지)
    private static let somberSituations: Set<DialogueSituation> = [.died, .graduated]

    // 종 감탄사 + 성격 데코(한 겹)를 입히는 순수 함수.
    // 순서: 성격 접두 → 종 감탄사 → 성격 접미 (자연스러운 문장 끝)
    private func decorate(_ line: String, for context: DialogueContext) -> String {
        guard !Self.somberSituations.contains(context.situation) else { return line }
        var result = line
        let decorator = context.personality.decorator
        if case .prefix(let prefix) = decorator { result = prefix + result }
        let interjections = SpeciesSpeech.style(for: context.species).interjections
        if !interjections.isEmpty {
            let index = max(0, min(Int(random() * Double(interjections.count)), interjections.count - 1))
            result += " " + interjections[index]
        }
        if case .suffix(let suffix) = decorator { result += suffix }
        return result
    }

    static func pool(for situation: DialogueSituation) -> [String] {
        switch situation {
        case .greeting:
            ["좋은 아침! 오늘도 코딩하자!", "왔구나! 기다렸어 🐾", "오늘은 뭘 만들어볼까?"]
        case .returnGreeting:
            ["오랜만이야! 보고 싶었어!", "어디 갔다 왔어? 심심했단 말이야!"]
        case .levelUp:
            ["레벨 업! 나 Lv.{level} 됐어!", "점점 강해지는 기분이야! Lv.{level}!"]
        case .hatched:
            ["안녕! 나는 {name}!", "드디어 세상에 나왔다! 나는 {name}!"]
        case .evolvedToAdult:
            ["나 다 컸어! 멋지지?", "어른이 됐어! 더 열심히 일할게!"]
        case .graduated:
            ["나 졸업해! 그동안 고마웠어!", "도감에서 또 만나자! 안녕!"]
        case .died:
            ["...여기까지인가 봐. 안녕...", "배고팠어... 다음 친구는 잘 챙겨줘..."]
        case .hungryWarning:
            ["배고파... 클로드한테 일 좀 시켜줘", "꼬르륵... 작업 하나만 부탁해"]
        case .criticalWarning:
            ["나 진짜 쓰러질 것 같아...!", "살려줘... 밥... 밥이 필요해...!"]
        case .permissionWaiting:
            ["주인님! Claude가 허락 기다리고 있어!", "터미널 좀 봐줘! 기다리는 중이야!"]
        case .longWorkBreak:
            ["1시간 넘게 일했어. 스트레칭 한번 어때?", "쉬엄쉬엄 해~ 물도 마시고!"]
        case .randomChatter:
            ["오늘 코드 잘 짜져?", "버그는 나의 간식!", "심심하다~ 뭐 만들고 있어?"]
        case .vacationReturn:
            ["휴가 잘 다녀왔어! 선물은... 비밀!", "다시 일할 준비 완료!"]
        case .petted:
            ["헤헤, 간지러워!", "더 쓰다듬어줘~ 🐾", "기분 좋아졌어!"]
        case .rerolled:
            ["새 알이 도착했어! 두근두근", "다음 친구는 누굴까...?"]
        case .promptReaction:
            ["오 그거 재밌겠다! 화이팅!", "접수 완료! Claude가 열심히 할 거야",
             "그 작업 끝나면 밥 주는 거지? 🍚"]
        }
    }
}
