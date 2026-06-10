import Foundation

// 게임 튜닝 수치 — 하드코딩 금지, 전부 여기로 모은다 (스펙 §5)
public struct GameConfig: Codable, Equatable, Sendable {
    public var satietyPerStop: Double = 10            // Stop 1회 포만감
    public var satietyGainCapPerMinute: Double = 20   // 분당 포만감 획득 상한
    public var expPerStop: Int = 5                    // Stop 1회 EXP
    public var satietyDecayPerHour: Double = 10       // 깨어있는 1시간당 감소
    public var hatchExp: Int = 30                     // 알 → 아기
    public var adultLevel: Int = 10                   // 아기 → 성체
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

    public static let `default` = GameConfig()
    public init() {}

    // 레벨 n → n+1 에 필요한 EXP (스펙 §5: 10 × n)
    public func expToNextLevel(from level: Int) -> Int { 10 * level }
}
