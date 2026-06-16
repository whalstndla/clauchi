import Foundation
import ClauchiCore
#if canImport(FoundationModels)
import FoundationModels
#endif

// 온디바이스 AI 대사 — 1.5초 내 응답 없거나 실패하면 템플릿 폴백 (스펙 §6)
struct FoundationModelsDialogueProvider: DialogueProviding {
    let fallback: any DialogueProviding

    // 첫 호출이 모델 로드 때문에 ~4초 걸림 (실측) — 앱 시작 시 미리 예열해
    // 이후 호출을 0.5초 수준으로 만든다
    static func warmUp() {
        #if canImport(FoundationModels)
        guard case .available = SystemLanguageModel.default.availability else { return }
        Task.detached(priority: .utility) {
            let session = LanguageModelSession(instructions: instructions)
            session.prewarm()
        }
        #endif
    }

    func line(for context: DialogueContext) async -> String {
        #if canImport(FoundationModels)
        guard case .available = SystemLanguageModel.default.availability else {
            return await fallback.line(for: context)
        }
        do {
            return try await withThrowingTaskGroup(of: String.self) { group in
                group.addTask {
                    let session = LanguageModelSession(instructions: Self.instructions)
                    let response = try await session.respond(to: Self.prompt(for: context))
                    // 한글 무포함·모델 누수·과길이 출력은 nil → 폴백으로 넘김
                    guard let cleaned = AIDialogueValidator.cleanLine(response.content) else {
                        throw CancellationError()
                    }
                    return cleaned
                }
                group.addTask {
                    try await Task.sleep(for: .seconds(1.5))
                    throw CancellationError()
                }
                guard let first = try await group.next(), !first.isEmpty else {
                    throw CancellationError()
                }
                group.cancelAll()
                return first
            }
        } catch {
            return await fallback.line(for: context)
        }
        #else
        return await fallback.line(for: context)
        #endif
    }

    static let instructions = """
        너는 맥북 노치에 사는 픽셀 다마고치 펫이다. 주인은 개발자다. \
        반말로, 한국어 한 문장(최대 40자)으로만 답한다. 이모지는 최대 1개. \
        따옴표나 설명 없이 대사만 출력한다.
        """

    static func prompt(for context: DialogueContext) -> String {
        let speech = SpeciesSpeech.style(for: context.species)
        // AI 경로는 죽음/졸업 상황에도 성격 힌트를 그대로 주입한다(오프라인 decorate는
        // 슬픈 상황에 데코를 생략 — 의도된 비대칭). 상황 설명이 톤을 지배하므로 충돌 없음.
        var ownerInfo = ""
        if !context.ownerName.isEmpty {
            ownerInfo = "주인 이름은 \(context.ownerName). "
        }
        ownerInfo += context.ownerGender == .unspecified ? "" :
            "주인 성별은 \(context.ownerGender == .male ? "남성" : "여성"). "
        // 스트릭 마일스톤 상황에선 연속 일수를 프롬프트에 넣어 AI가 숫자를 언급하게 한다
        let streakInfo = context.situation == .streakMilestone && context.streakDays > 0
            ? "연속 사용 \(context.streakDays)일째. " : ""
        let base = "너는 \(speech.aiHint) 말투의 \(context.petName)(Lv.\(context.level), " +
                   "포만감 \(context.satiety)/100, 기분 \(context.mood)/100). " +
                   "성격은 \(context.personality.aiHint). " + ownerInfo + streakInfo
        if let userPrompt = context.userPrompt {
            if context.situation == .talked {
                return base + "주인이 너에게 건넨 말: \"\(Self.sanitizeInput(userPrompt))\". " +
                              "이 말에 펫답게 대화로 반응 한마디:"
            }
            return base + "주인이 방금 Claude에게 시킨 작업: \"\(Self.sanitizeInput(userPrompt))\". " +
                          "이 작업에 대해 펫답게 응원/반응 한마디:"
        }
        return base + "상황: \(situationDescription(context.situation)). 지금 주인에게 할 한마디:"
    }

    // 사용자 프롬프트를 모델 프롬프트에 끼우기 전 정제 — 따옴표 프레임 깨짐/줄바꿈 방지
    static func sanitizeInput(_ raw: String) -> String {
        let cleaned = raw
            .replacingOccurrences(of: "\"", with: "'")
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.count > 120 ? String(cleaned.prefix(120)) : cleaned
    }

    static func situationDescription(_ situation: DialogueSituation) -> String {
        switch situation {
        case .greeting: "주인이 Claude Code 세션을 시작했다"
        case .returnGreeting: "주인이 오랜만에 돌아왔다"
        case .levelUp: "방금 레벨업했다"
        case .hatched: "방금 알에서 태어났다"
        case .evolvedToAdult: "방금 성체로 진화했다"
        case .graduated: "최종 성장을 마치고 졸업한다. 작별과 감사"
        case .died: "굶어서 죽는다. 짧은 작별 인사"
        case .hungryWarning: "배가 고프다. Claude 작업(=밥)을 부탁"
        case .criticalWarning: "굶어 죽기 직전. 긴급 호소"
        case .permissionWaiting: "Claude가 터미널에서 주인의 허락을 기다리는 중"
        case .longWorkBreak: "주인이 1시간 넘게 연속 작업 중. 휴식 권유"
        case .randomChatter: "심심해서 거는 잡담"
        case .vacationReturn: "휴가에서 막 복귀했다"
        case .petted: "주인이 쓰다듬어줘서 기분이 좋다"
        case .rerolled: "주인이 새 알을 뽑았다. 새 알의 설렘을 전한다"
        case .promptReaction: "주인이 방금 Claude에게 새 작업을 시켰다"
        case .manualFed: "주인이 직접 밥을 줬다. 기쁘고 감사하다"
        case .talked: "주인이 펫에게 말을 걸어왔다. 대화에 즐겁게 반응"
        case .streakMilestone: "주인이 여러 날 연속으로 Claude를 써서 함께한 기념일이다. 꾸준함을 축하"
        case .lateNightWork: "주인이 한밤중(새벽)에 작업을 시작했다. 밤샘을 걱정하며 건강을 챙기라고"
        case .weekendWork: "주인이 주말에 작업을 시작했다. 주말에도 일하는 걸 보고 한마디(응원 또는 쉬라고)"
        case .workMilestone: "주인과 함께한 누적 작업이 큰 숫자에 도달했다. 그동안의 노고를 축하·자랑"
        }
    }

}
