import Foundation

public enum Species: String, Codable, CaseIterable, Equatable, Sendable {
    case rat, ox, tiger, rabbit, dragon, snake
    case horse, goat, monkey, rooster, dog, pig

    public var koreanName: String {
        switch self {
        case .rat: "쥐돌이"
        case .ox: "우공이"
        case .tiger: "호랑이"
        case .rabbit: "토토"
        case .dragon: "용용이"
        case .snake: "스르륵"
        case .horse: "말랑이"
        case .goat: "양순이"
        case .monkey: "몽키"
        case .rooster: "꼬꼬"
        case .dog: "멍멍이"
        case .pig: "꿀꿀이"
        }
    }
}

public enum Stage: String, Codable, Equatable, Sendable { case egg, baby, adult }

public enum LifeResult: String, Codable, Equatable, Sendable { case graduated, died }

public struct CollectionRecord: Codable, Equatable, Sendable {
    public var species: Species
    public var result: LifeResult
    public var daysLived: Int
    public var finalLevel: Int
    public var endedAt: Date
    public var customName: String?          // 생애 종료 시 보존되는 사용자 지정 이름
    public var personality: Personality?    // 생애 종료 시 보존되는 성격 (레거시는 nil)
    public init(species: Species, result: LifeResult, daysLived: Int, finalLevel: Int,
                endedAt: Date, customName: String? = nil, personality: Personality? = nil) {
        self.species = species; self.result = result
        self.daysLived = daysLived; self.finalLevel = finalLevel; self.endedAt = endedAt
        self.customName = customName; self.personality = personality
    }
}

public struct PetState: Codable, Equatable, Sendable {
    public var species: Species
    public var stage: Stage
    public var customName: String?      // 사용자가 지은 이름 — nil이면 종 기본 이름
    public var level: Int
    public var exp: Int                 // 현재 레벨에서 쌓은 EXP (레벨업 시 차감)
    public var satiety: Double          // 0...100
    public var mood: Double             // 0...100 — 쓰다듬기/레벨업으로 상승 (스펙 §5)
    public var bornAt: Date
    public var criticalAccumulatedSeconds: TimeInterval
    public var personality: Personality

    public var displayName: String {
        customName ?? species.koreanName
    }

    public init(species: Species, stage: Stage, level: Int, exp: Int,
                satiety: Double, mood: Double, bornAt: Date,
                criticalAccumulatedSeconds: TimeInterval,
                personality: Personality = .cheerful, customName: String? = nil) {
        self.species = species; self.stage = stage; self.customName = customName
        self.level = level; self.exp = exp
        self.satiety = satiety; self.mood = mood; self.bornAt = bornAt
        self.criticalAccumulatedSeconds = criticalAccumulatedSeconds
        self.personality = personality
    }

    enum CodingKeys: String, CodingKey {
        case species, stage, customName, level, exp, satiety, mood, bornAt
        case criticalAccumulatedSeconds, personality
    }

    // mood 가 없는 v1 세이브 마이그레이션 — 기본 80 (스펙 §9 버전 대비)
    // customName 이 없는 구버전 세이브 마이그레이션 — nil 디코드
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        species = try container.decode(Species.self, forKey: .species)
        stage = try container.decode(Stage.self, forKey: .stage)
        customName = try container.decodeIfPresent(String.self, forKey: .customName)
        level = try container.decode(Int.self, forKey: .level)
        exp = try container.decode(Int.self, forKey: .exp)
        satiety = try container.decode(Double.self, forKey: .satiety)
        mood = try container.decodeIfPresent(Double.self, forKey: .mood) ?? 80
        bornAt = try container.decode(Date.self, forKey: .bornAt)
        criticalAccumulatedSeconds =
            try container.decode(TimeInterval.self, forKey: .criticalAccumulatedSeconds)
        // personality 없는 구버전 — bornAt 기반 결정적 복원 (스펙 §6.1)
        personality = try container.decodeIfPresent(Personality.self, forKey: .personality)
            ?? Personality.deterministic(from: bornAt)
    }
}

// 주인 성별 — 대사 호칭에만 영향 (게임 수치 무관)
public enum OwnerGender: String, Codable, Equatable, Sendable {
    case unspecified, male, female

    // 이름 미입력 시 사용할 기본 호칭
    public var honorific: String {
        switch self {
        case .unspecified: "주인님"
        case .male: "형"
        case .female: "언니"
        }
    }
}

public struct GameSettings: Codable, Equatable, Sendable {
    public var restWeekdays: Set<Int>   // Calendar.weekday (1=일 ... 7=토)
    public var vacationMode: Bool
    public var dialogueAIEnabled: Bool
    public var launchAtLogin: Bool
    public var ownerName: String        // 빈 문자열이면 성별 기반 기본 호칭 사용
    public var ownerGender: OwnerGender
    public var randomChatterEnabled: Bool   // 심심할 때 거는 랜덤 잡담 on/off
    public init(restWeekdays: Set<Int>, vacationMode: Bool, dialogueAIEnabled: Bool,
                launchAtLogin: Bool, ownerName: String = "",
                ownerGender: OwnerGender = .unspecified, randomChatterEnabled: Bool = true) {
        self.restWeekdays = restWeekdays; self.vacationMode = vacationMode
        self.dialogueAIEnabled = dialogueAIEnabled; self.launchAtLogin = launchAtLogin
        self.ownerName = ownerName; self.ownerGender = ownerGender
        self.randomChatterEnabled = randomChatterEnabled
    }

    enum CodingKeys: String, CodingKey {
        case restWeekdays, vacationMode, dialogueAIEnabled, launchAtLogin
        case ownerName, ownerGender, randomChatterEnabled
    }

    // 구버전 세이브 마이그레이션 — 없는 필드는 기본값으로
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restWeekdays = try container.decode(Set<Int>.self, forKey: .restWeekdays)
        vacationMode = try container.decode(Bool.self, forKey: .vacationMode)
        dialogueAIEnabled = try container.decode(Bool.self, forKey: .dialogueAIEnabled)
        launchAtLogin = try container.decode(Bool.self, forKey: .launchAtLogin)
        ownerName = try container.decodeIfPresent(String.self, forKey: .ownerName) ?? ""
        ownerGender = try container.decodeIfPresent(OwnerGender.self, forKey: .ownerGender)
            ?? .unspecified
        randomChatterEnabled = try container.decodeIfPresent(
            Bool.self, forKey: .randomChatterEnabled) ?? true
    }

    public static let `default` = GameSettings(
        restWeekdays: [1, 7], vacationMode: false, dialogueAIEnabled: true,
        launchAtLogin: false, ownerName: "", ownerGender: .unspecified)
}

public struct GameState: Codable, Equatable, Sendable {
    public var version: Int
    public var pet: PetState
    public var collection: [CollectionRecord]
    public var settings: GameSettings
    public var eventLogOffset: UInt64
    public var lastChatterAt: Date?
    public var lastActivityAt: Date?
    public var continuousWorkStartedAt: Date?
    public var streakDays: Int               // 연속 사용일 (스트릭) — 활동 없는 날이 끼면 1로 리셋
    public var lastStreakDay: Date?          // 스트릭에 마지막으로 반영된 '날'(startOfDay)
    public var lifetimeStops: Int            // 누적 작업(Stop) 횟수 — 펫을 넘어 영구 집계
    public var lifetimeManualFeeds: Int      // 누적 수동 급식 횟수
    public var lifetimePets: Int             // 누적 쓰다듬기 횟수
    public init(version: Int, pet: PetState, collection: [CollectionRecord],
                settings: GameSettings, eventLogOffset: UInt64,
                lastChatterAt: Date?, lastActivityAt: Date?, continuousWorkStartedAt: Date?,
                streakDays: Int = 0, lastStreakDay: Date? = nil,
                lifetimeStops: Int = 0, lifetimeManualFeeds: Int = 0, lifetimePets: Int = 0) {
        self.version = version; self.pet = pet; self.collection = collection
        self.settings = settings; self.eventLogOffset = eventLogOffset
        self.lastChatterAt = lastChatterAt; self.lastActivityAt = lastActivityAt
        self.continuousWorkStartedAt = continuousWorkStartedAt
        self.streakDays = streakDays; self.lastStreakDay = lastStreakDay
        self.lifetimeStops = lifetimeStops; self.lifetimeManualFeeds = lifetimeManualFeeds
        self.lifetimePets = lifetimePets
    }

    enum CodingKeys: String, CodingKey {
        case version, pet, collection, settings, eventLogOffset
        case lastChatterAt, lastActivityAt, continuousWorkStartedAt
        case streakDays, lastStreakDay, lifetimeStops, lifetimeManualFeeds, lifetimePets
    }

    // 신규 필드(streak/lifetime)가 없는 구버전 세이브 마이그레이션 — 기본 0 / nil
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(Int.self, forKey: .version)
        pet = try container.decode(PetState.self, forKey: .pet)
        collection = try container.decode([CollectionRecord].self, forKey: .collection)
        settings = try container.decode(GameSettings.self, forKey: .settings)
        eventLogOffset = try container.decode(UInt64.self, forKey: .eventLogOffset)
        lastChatterAt = try container.decodeIfPresent(Date.self, forKey: .lastChatterAt)
        lastActivityAt = try container.decodeIfPresent(Date.self, forKey: .lastActivityAt)
        continuousWorkStartedAt = try container.decodeIfPresent(Date.self, forKey: .continuousWorkStartedAt)
        streakDays = try container.decodeIfPresent(Int.self, forKey: .streakDays) ?? 0
        lastStreakDay = try container.decodeIfPresent(Date.self, forKey: .lastStreakDay)
        lifetimeStops = try container.decodeIfPresent(Int.self, forKey: .lifetimeStops) ?? 0
        lifetimeManualFeeds = try container.decodeIfPresent(Int.self, forKey: .lifetimeManualFeeds) ?? 0
        lifetimePets = try container.decodeIfPresent(Int.self, forKey: .lifetimePets) ?? 0
    }
}

// 프로젝트 공용 JSON 코더 — 날짜는 ISO8601 고정
extension JSONEncoder {
    public static var clauchi: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }
}
extension JSONDecoder {
    public static var clauchi: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
