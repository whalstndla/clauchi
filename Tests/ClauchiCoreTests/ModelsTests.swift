import Foundation
import Testing
@testable import ClauchiCore

@Test func gameStateCodableRoundtrip() throws {
    let now = Date(timeIntervalSince1970: 1_780_000_000)
    let state = GameState(
        version: 1,
        pet: PetState(species: .tiger, stage: .adult, level: 7, exp: 12,
                      satiety: 64, mood: 70, bornAt: now, criticalAccumulatedSeconds: 0),
        collection: [CollectionRecord(species: .rat, result: .graduated,
                                      daysLived: 14, finalLevel: 30, endedAt: now)],
        settings: .default,
        eventLogOffset: 123,
        lastChatterAt: nil, lastActivityAt: now, continuousWorkStartedAt: nil)

    let data = try JSONEncoder.clauchi.encode(state)
    let decoded = try JSONDecoder.clauchi.decode(GameState.self, from: data)
    #expect(decoded == state)
}

@Test func expCurveIsLinearTimesTen() {
    let config = GameConfig.default
    #expect(config.expToNextLevel(from: 1) == 10)
    #expect(config.expToNextLevel(from: 9) == 90)
}

@Test func defaultSettingsRestOnWeekend() {
    // Calendar.weekday: 1 = 일요일, 7 = 토요일
    #expect(GameSettings.default.restWeekdays == [1, 7])
}

@Test func allTwelveSpeciesExistWithKoreanNames() {
    #expect(Species.allCases.count == 12)
    for species in Species.allCases {
        #expect(!species.koreanName.isEmpty)
    }
}

@Test func customNameMissingDecodesAsNil() throws {
    // customName이 없는 구버전 세이브 — nil 디코드 + 종 기본 이름 표시
    let json = #"{"species":"tiger","stage":"adult","level":15,"exp":0,"satiety":80,"bornAt":"2026-06-01T00:00:00Z","criticalAccumulatedSeconds":0}"#
    let pet = try JSONDecoder.clauchi.decode(PetState.self, from: Data(json.utf8))
    #expect(pet.customName == nil)
    #expect(pet.displayName == "호랑이")
}

@Test func displayNamePrefersCustomName() {
    var pet = TestSupport.makeState().pet
    pet.customName = "쿠키"
    #expect(pet.displayName == "쿠키")
}

@Test func customNameSurvivesRoundtrip() throws {
    var state = TestSupport.makeState()
    state.pet.customName = "쿠키"
    let data = try JSONEncoder.clauchi.encode(state)
    let decoded = try JSONDecoder.clauchi.decode(GameState.self, from: data)
    #expect(decoded.pet.customName == "쿠키")
}

@Test func personalitySurvivesRoundtrip() throws {
    var state = TestSupport.makeState()
    state.pet.personality = .quirky
    let data = try JSONEncoder.clauchi.encode(state)
    let decoded = try JSONDecoder.clauchi.decode(GameState.self, from: data)
    #expect(decoded.pet.personality == .quirky)
}

@Test func personalityMissingDecodesDeterministicallyFromBornAt() throws {
    // 성격 필드 없는 구버전 PetState — bornAt 기반 결정적 복원
    let json = #"{"species":"tiger","stage":"adult","level":15,"exp":0,"satiety":80,"bornAt":"2026-06-01T00:00:00Z","criticalAccumulatedSeconds":0}"#
    let pet = try JSONDecoder.clauchi.decode(PetState.self, from: Data(json.utf8))
    let expected = Personality.deterministic(
        from: ISO8601DateFormatter().date(from: "2026-06-01T00:00:00Z")!)
    #expect(pet.personality == expected)
}

@Test func collectionRecordPersonalitySurvivesRoundtrip() throws {
    let now = Date(timeIntervalSince1970: 1_780_000_000)
    let record = CollectionRecord(species: .rat, result: .graduated,
                                  daysLived: 3, finalLevel: 30, endedAt: now,
                                  personality: .grumpy)
    let data = try JSONEncoder.clauchi.encode(record)
    let decoded = try JSONDecoder.clauchi.decode(CollectionRecord.self, from: data)
    #expect(decoded.personality == .grumpy)
}

@Test func collectionRecordPersonalityMissingDecodesAsNil() throws {
    // 성격 필드 없는 구버전 레코드 — nil 디코드
    let json = #"{"species":"rat","result":"graduated","daysLived":3,"finalLevel":30,"endedAt":"2026-06-01T00:00:00Z"}"#
    let record = try JSONDecoder.clauchi.decode(CollectionRecord.self, from: Data(json.utf8))
    #expect(record.personality == nil)
}
