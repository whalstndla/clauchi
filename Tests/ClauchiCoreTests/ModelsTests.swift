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
