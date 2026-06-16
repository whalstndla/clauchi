import Foundation

// 게임 튜닝 수치 — 하드코딩 금지, 전부 여기로 모은다 (스펙 §5)
public struct GameConfig: Codable, Equatable, Sendable {
    public var satietyPerStop: Double = 10            // Stop 1회 포만감
    public var satietyPerManualFeed: Double = 20      // 수동 밥주기 1회 포만감
    public var manualFeedCooldownSeconds: TimeInterval = 300  // 수동 밥주기 5분 쿨다운
    public var satietyGainCapPerMinute: Double = 20   // 분당 포만감 획득 상한
    public var expPerStop: Int = 5                    // Stop 1회 EXP
    public var satietyPerToolUse: Double = 2          // tool-use(능동 작업) 1회 포만감 — Stop의 1/5
    public var expPerToolUse: Int = 1                 // tool-use 1회 EXP
    public var toolUseExpGainCapPerMinute: Int = 6    // 분당 tool-use EXP 상한 (폭주 방지)
    public var satietyDecayPerHour: Double = 10       // 깨어있는 1시간당 감소
    public var hatchExp: Int = 30                     // 알 → 아기
    public var adultLevel: Int = 5                    // 아기 → 성체
    public var rerollLockLevel: Int = 10              // 이 레벨 이상이면 리세마라 잠금
    public var graduateLevel: Int = 30                // 성체 → 졸업
    public var hungryThreshold: Double = 20           // 배고픔 경고선
    public var criticalSecondsToDeath: TimeInterval = 6 * 3600
    public var tickDeltaCapSeconds: TimeInterval = 5  // 틱 간격 상한 (잠자기 공백 무시)
    public var workingWindowSeconds: TimeInterval = 30
    public var sleepAfterIdleSeconds: TimeInterval = 600
    public var chatterCooldownSeconds: TimeInterval = 1800
    public var longWorkSeconds: TimeInterval = 3600
    public var returnGreetingAfterSeconds: TimeInterval = 8 * 3600
    public var greetingGapSeconds: TimeInterval = 1800
    public var notificationSpeakCooldownSeconds: TimeInterval = 300
    public var promptReactionCooldownSeconds: TimeInterval = 90   // 프롬프트 반응 쿨다운
    public var promptReactionFreshnessSeconds: TimeInterval = 120   // 이보다 오래된 프롬프트 반응은 버림 (백로그 리플레이 폭주 방지)

    // 기분 (스펙 §5 — 사용자 요청으로 관리 스탯으로 승격)
    public var moodPerPet: Double = 10                // 쓰다듬기 1회
    public var moodGainCapPerMinute: Double = 20      // 쓰다듬기 분당 상한
    public var moodPerStop: Double = 2                // 밥 먹을 때
    public var moodPerLevelUp: Double = 15
    public var moodPerStageChange: Double = 30        // 부화/진화
    public var moodDecayPerHour: Double = 5
    public var moodExtraDecayWhenHungryPerHour: Double = 10
    public var moodRestGainPerHour: Double = 5        // 휴일에 놀면서 회복
    public var moodHappyThreshold: Double = 70        // 이상이면 EXP 보너스
    public var moodSadThreshold: Double = 25          // 이하면 시무룩 표정
    public var happyExpBonusPerStop: Int = 1

    // 연속 사용일(스트릭) 마일스톤 — 이 일수에 도달하면 축하 대사 (스펙 §5 확장 2026-06-16)
    public var streakMilestones: [Int] = [3, 7, 14, 30, 50, 100]

    // 심야(밤샘) 시간대 — 이 시각에 세션을 시작하면 걱정하는 인사 (로컬 시 기준)
    public var lateNightHours: Set<Int> = [0, 1, 2, 3, 4]

    // 주말 요일(그레고리력: 일=1, 토=7) — 주말 세션 시작 시 전용 인사
    public var weekendWeekdays: Set<Int> = [1, 7]

    public static let `default` = GameConfig()
    public init() {}

    // 레벨 n → n+1 에 필요한 EXP (스펙 §5: 10 × n)
    public func expToNextLevel(from level: Int) -> Int { 10 * level }
}
