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
    public var ownerName: String        // 빈 문자열이면 성별 기반 기본 호칭 사용
    public var ownerGender: OwnerGender
    public var streakDays: Int          // 연속 사용일 — {streak} 치환·마일스톤 대사용
    public init(situation: DialogueSituation, petName: String,
                stage: Stage, level: Int, satiety: Int, mood: Int = 50,
                userPrompt: String? = nil,
                species: Species = .rat, personality: Personality = .cheerful,
                ownerName: String = "", ownerGender: OwnerGender = .unspecified,
                streakDays: Int = 0) {
        self.situation = situation; self.petName = petName
        self.stage = stage; self.level = level; self.satiety = satiety
        self.mood = mood; self.userPrompt = userPrompt
        self.species = species; self.personality = personality
        self.ownerName = ownerName; self.ownerGender = ownerGender
        self.streakDays = streakDays
    }

    // 호칭 — 이름이 있으면 이름, 없으면 성별 기반 기본 호칭
    public var ownerHonorific: String {
        ownerName.isEmpty ? ownerGender.honorific : ownerName
    }

    // AI 프롬프트용 호칭 지침 — 해결된 호칭 '하나만' 쓰고 다른 호칭(주인님/형/언니 등)을
    // 섞지 않도록 명시. "민수야! 주인님!" 같은 이름+일반호칭 혼용 버그를 막는다.
    public var ownerAddressHint: String {
        "주인을 부를 땐 반드시 '\(ownerHonorific)' 하나만 쓰고, 다른 호칭을 덧붙이지 마. "
    }
}

public extension DialogueSituation {
    // AI 응답 대기 한도(초) — 사용자가 직접 보내고 기다리는 말걸기는 더 길게 준다.
    // 그 외(자동 발화)는 짧게 잡아 폴백을 빨리 띄운다.
    var aiResponseTimeoutSeconds: Double { self == .talked ? 4.0 : 1.5 }
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
        // 프롬프트 반응은 작업 키워드에 맞는 대사를 우선 선택(없으면 일반 풀)
        if context.situation == .promptReaction, let prompt = context.userPrompt,
           let keyworded = Self.keywordReaction(for: prompt) {
            return decorate(fill(keyworded, context), for: context)
        }
        // 말걸기는 메시지 의도(인사/칭찬/안부 등)에 맞는 대사를 우선 선택해 대화처럼 반응
        if context.situation == .talked, let message = context.userPrompt,
           let reaction = Self.talkReaction(for: message) {
            return decorate(fill(reaction, context), for: context)
        }
        let pool = Self.pool(for: context.situation)
        let index = min(Int(random() * Double(pool.count)), pool.count - 1)
        return decorate(fill(pool[index], context), for: context)
    }

    // 플레이스홀더 치환 — {name}/{level}/{owner}/{streak}
    private func fill(_ line: String, _ context: DialogueContext) -> String {
        line.replacingOccurrences(of: "{name}", with: context.petName)
            .replacingOccurrences(of: "{level}", with: String(context.level))
            .replacingOccurrences(of: "{owner}", with: context.ownerHonorific)
            .replacingOccurrences(of: "{streak}", with: String(context.streakDays))
    }

    // 작업 프롬프트의 키워드 → 맞춤 반응. 매칭 없으면 nil(→ 일반 풀)
    static func keywordReaction(for prompt: String) -> String? {
        let lowered = prompt.lowercased()
        let table: [(keys: [String], line: String)] = [
            (["버그", "bug", "fix", "오류", "에러", "error", "고쳐", "디버"], "버그 잡으러 출동! 🐛"),
            (["테스트", "test", "스펙", "spec"], "테스트 통과 기원할게! 🙏"),
            (["리팩터", "refactor", "정리", "clean", "개선"], "깔끔하게 정리하자~"),
            (["배포", "deploy", "릴리즈", "release", "출시"], "드디어 배포구나! 두근두근 🚀"),
            (["문서", "doc", "readme", "주석"], "문서화까지 챙기다니 멋져! 📝"),
            (["디자인", "ui", "ux", "스타일", "css"], "예쁘게 만들어보자! 🎨"),
        ]
        for entry in table where entry.keys.contains(where: { lowered.contains($0) }) {
            return entry.line
        }
        return nil
    }

    // 말걸기(.talked) 메시지의 의도 → 맞춤 반응. 매칭 없으면 nil(→ 일반 풀).
    // 일반 풀과 달리 "주인이 한 말"에 직접 반응해 대화가 이어지는 느낌을 준다.
    static func talkReaction(for message: String) -> String? {
        let lowered = message.lowercased()
        let table: [(keys: [String], line: String)] = [
            (["안녕", "하이", "hi", "hello", "ㅎㅇ", "안뇽", "방가", "반가", "왔어"], "안녕! 와줘서 반가워 🐾"),
            (["뭐해", "모해", "뭐 해", "뭐하", "심심", "놀자"], "코드 구경 중이었지~ 넌 뭐 해?"),
            (["귀여", "귀엽", "예뻐", "예쁘", "이뻐", "이쁘", "사랑", "좋아", "최고", "멋져", "멋지", "착해", "대단"], "헤헤, 쑥스럽잖아~ 고마워!"),
            (["고마", "감사", "thx", "thank"], "천만에! 언제든 불러~"),
            (["미안", "sorry", "쏘리"], "괜찮아~ 신경 쓰지 마!"),
            (["잘자", "잘 자", "굿나잇", "굿밤", "자러", "잘게", "bye", "들어가", "쉬어"], "잘 자! 좋은 꿈 꿔~ 🌙"),
            (["배고", "밥", "먹"], "나도 출출해~ 작업 시켜주면 배불러져 🍚"),
            (["힘들", "지쳐", "피곤", "졸려", "스트레스", "지친"], "고생 많아~ 잠깐 쉬어가도 괜찮아!"),
        ]
        for entry in table where entry.keys.contains(where: { lowered.contains($0) }) {
            return entry.line
        }
        return nil
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
            ["좋은 아침! 오늘도 코딩하자!", "왔구나! 기다렸어 🐾", "오늘은 뭘 만들어볼까?",
             "{owner}, 안녕! 오늘도 화이팅!", "또 만났네! 반가워~"]
        case .returnGreeting:
            ["오랜만이야! 보고 싶었어!", "어디 갔다 왔어? 심심했단 말이야!",
             "{owner}! 돌아왔구나, 반가워!"]
        case .levelUp:
            ["레벨 업! 나 Lv.{level} 됐어!", "점점 강해지는 기분이야! Lv.{level}!",
             "Lv.{level} 달성! 다 {owner} 덕분이야"]
        case .hatched:
            ["안녕! 나는 {name}!", "드디어 세상에 나왔다! 나는 {name}!",
             "{owner}, 앞으로 잘 부탁해! 나는 {name}!"]
        case .evolvedToAdult:
            ["나 다 컸어! 멋지지?", "어른이 됐어! 더 열심히 일할게!",
             "성체가 됐어! 한층 든든하지?"]
        case .graduated:
            ["나 졸업해! 그동안 고마웠어!", "도감에서 또 만나자! 안녕!",
             "{owner}, 함께한 시간 잊지 않을게"]
        case .died:
            ["...여기까지인가 봐. 안녕...", "배고팠어... 다음 친구는 잘 챙겨줘...",
             "{owner}... 미안해, 더 못 버텼어..."]
        case .hungryWarning:
            ["배고파... {owner}, Claude한테 일 좀 시켜줘", "꼬르륵... 작업 하나만 부탁해",
             "출출하다~ 코드 한 줄이면 배부를 텐데"]
        case .criticalWarning:
            ["나 진짜 쓰러질 것 같아...!", "살려줘... 밥... 밥이 필요해...!",
             "{owner}, 더는 못 버텨... 작업 좀!"]
        case .permissionWaiting:
            ["{owner}! Claude가 허락 기다리고 있어!", "터미널 좀 봐줘! 기다리는 중이야!",
             "승인 대기 중이래~ 한 번 확인해줘!"]
        case .longWorkBreak:
            ["1시간 넘게 일했어. 스트레칭 한번 어때?", "쉬엄쉬엄 해~ 물도 마시고!",
             "{owner}, 잠깐 쉬어가도 괜찮아!"]
        case .randomChatter:
            ["오늘 코드 잘 짜져?", "버그는 나의 간식!", "심심하다~ 뭐 만들고 있어?",
             "{owner}는 오늘 기분 어때?", "커밋은 자주자주 하는 거 알지?",
             "물 한 잔 마시고 와~ 기다릴게", "오늘도 한 줄 한 줄 멋지다!",
             "잠깐, 변수명은 잘 지었어?", "리팩터링도 가끔은 필요해~", "테스트는 친구야! 🐾"]
        case .vacationReturn:
            ["휴가 잘 다녀왔어! 선물은... 비밀!", "다시 일할 준비 완료!",
             "푹 쉬었더니 개운해! 또 달려보자"]
        case .petted:
            ["헤헤, 간지러워!", "더 쓰다듬어줘~ 🐾", "기분 좋아졌어!"]
        case .rerolled:
            ["새 알이 도착했어! 두근두근", "다음 친구는 누굴까...?",
             "새출발이다! 이번엔 누가 나올까?"]
        case .promptReaction:
            ["오 그거 재밌겠다! 화이팅!", "접수 완료! Claude가 열심히 할 거야",
             "그 작업 끝나면 밥 주는 거지? 🍚", "오~ 그거 궁금했는데!",
             "{owner}, 좋은 선택이야!", "두근두근, 결과가 기대돼!"]
        case .manualFed:
            ["냠냠! 맛있어! 고마워! 🍚", "밥 줘서 기뻐! 더 힘낼 수 있어!", "배가 든든해졌어~",
             "{owner} 최고! 잘 먹었습니다!", "이 맛에 일하지~ 🍚"]
        case .talked:
            ["그거 재밌는 얘기다!", "헤헤, 그렇구나!", "나도 그 생각 했어!",
             "주인이 말 걸어줘서 기뻐!", "오~ 그런 일이 있었어?"]
        case .streakMilestone:
            ["{streak}일 연속이라니! 최고야 🔥", "벌써 {streak}일째 함께! 이 기세로 가자!",
             "{owner}, {streak}일 연속이야! 🔥"]
        case .lateNightWork:
            ["이 시간까지 코딩이라니... 몸 챙겨!", "{owner}, 밤샘은 적당히! 🌙",
             "늦었어~ 무리하지 말고 곧 자자!"]
        case .weekendWork:
            ["주말에도 코딩이라니, 열정 가득! ", "{owner}, 주말엔 좀 쉬어도 돼~",
             "주말 출근(?) 환영! 같이 달려보자"]
        case .workMilestone:
            ["우리 진짜 많이 일했다! 대단해 🎉", "{owner}, 여기까지 함께라니 뿌듯해!",
             "엄청난 작업량이야! 자랑스러워 🎉"]
        }
    }
}
