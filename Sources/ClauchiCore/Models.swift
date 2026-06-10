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
    public init(species: Species, result: LifeResult, daysLived: Int, finalLevel: Int, endedAt: Date) {
        self.species = species; self.result = result
        self.daysLived = daysLived; self.finalLevel = finalLevel; self.endedAt = endedAt
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

    public var displayName: String {
        customName ?? species.koreanName
    }

    public init(species: Species, stage: Stage, level: Int, exp: Int,
                satiety: Double, mood: Double, bornAt: Date,
                criticalAccumulatedSeconds: TimeInterval, customName: String? = nil) {
        self.species = species; self.stage = stage; self.customName = customName
        self.level = level; self.exp = exp
        self.satiety = satiety; self.mood = mood; self.bornAt = bornAt
        self.criticalAccumulatedSeconds = criticalAccumulatedSeconds
    }

    enum CodingKeys: String, CodingKey {
        case species, stage, customName, level, exp, satiety, mood, bornAt, criticalAccumulatedSeconds
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
    }
}

public struct GameSettings: Codable, Equatable, Sendable {
    public var restWeekdays: Set<Int>   // Calendar.weekday (1=일 ... 7=토)
    public var vacationMode: Bool
    public var dialogueAIEnabled: Bool
    public var launchAtLogin: Bool
    public init(restWeekdays: Set<Int>, vacationMode: Bool, dialogueAIEnabled: Bool, launchAtLogin: Bool) {
        self.restWeekdays = restWeekdays; self.vacationMode = vacationMode
        self.dialogueAIEnabled = dialogueAIEnabled; self.launchAtLogin = launchAtLogin
    }
    public static let `default` = GameSettings(
        restWeekdays: [1, 7], vacationMode: false, dialogueAIEnabled: true, launchAtLogin: false)
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
    public init(version: Int, pet: PetState, collection: [CollectionRecord],
                settings: GameSettings, eventLogOffset: UInt64,
                lastChatterAt: Date?, lastActivityAt: Date?, continuousWorkStartedAt: Date?) {
        self.version = version; self.pet = pet; self.collection = collection
        self.settings = settings; self.eventLogOffset = eventLogOffset
        self.lastChatterAt = lastChatterAt; self.lastActivityAt = lastActivityAt
        self.continuousWorkStartedAt = continuousWorkStartedAt
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
