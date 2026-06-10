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
