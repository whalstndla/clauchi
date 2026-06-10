import Foundation
import Testing
@testable import ClauchiCore

@Test func pixelGridParsesValidRows() {
    let grid = PixelGrid(rows: ["KW", ".K"], palette: ["K": 0x000000FF, "W": 0xFFFFFFFF])
    #expect(grid?.width == 2)
    #expect(grid?.height == 2)
    #expect(grid?.pixels == [0x000000FF, 0xFFFFFFFF, 0, 0x000000FF])
}

@Test func pixelGridRejectsRaggedAndUnknown() {
    #expect(PixelGrid(rows: ["KW", "K"], palette: ["K": 1, "W": 2]) == nil)
    #expect(PixelGrid(rows: ["KX"], palette: ["K": 1]) == nil)
}

@Test func scaledDoublesEveryPixel() {
    let grid = PixelGrid(rows: ["K.", ".K"], palette: ["K": 0xFF0000FF])!
    let scaled = grid.scaled(by: 2)
    #expect(scaled.width == 4 && scaled.height == 4)
    #expect(scaled.pixels[0] == 0xFF0000FF && scaled.pixels[1] == 0xFF0000FF)
    #expect(scaled.pixels[2] == 0 && scaled.pixels[5] == 0xFF0000FF)
}

@Test func eggSpriteComplete() {
    let set = SpriteLibrary.spriteSet(for: .rat, stage: .egg)
    let frames = set.frames(for: .egg)
    #expect(frames.count == 2)
    for frame in frames { #expect(frame.width == 16 && frame.height == 16) }
    for expression in Expression.allCases {
        #expect(set.large[expression]?.width == 32)
        #expect(set.large[expression]?.height == 32)
    }
}

@Test func babySpritesCompleteForAllImplementedSpecies() {
    for species in SpriteLibrary.implementedSpecies {
        let set = SpriteLibrary.spriteSet(for: species, stage: .baby)
        for state in SpriteLibrary.requiredSmallStates {
            let frames = set.small[state]   // 폴백 없이 직접 조회 — 전 상태 필수
            #expect(frames?.count == 2, "\(species) baby \(state)")
            for frame in frames ?? [] { #expect(frame.width == 16 && frame.height == 16) }
        }
        for expression in Expression.allCases {
            #expect(set.large[expression]?.width == 32)
        }
    }
}

@Test func babyTintDiffersBySpecies() {
    let ratBaby = SpriteLibrary.spriteSet(for: .rat, stage: .baby)
    let tigerBaby = SpriteLibrary.spriteSet(for: .tiger, stage: .baby)
    #expect(ratBaby.small[.idle]?[0].pixels != tigerBaby.small[.idle]?[0].pixels)
}

@Test func babyStatesAreVisuallyDistinct() {
    let set = SpriteLibrary.spriteSet(for: .rat, stage: .baby)
    let idle = set.small[.idle]![0]
    #expect(set.small[.sleeping]![0] != idle)
    #expect(set.small[.critical]![0] != idle)
    #expect(set.small[.working]![0] != idle)
    #expect(set.small[.hungry]![0] != idle)
    #expect(set.small[.playing]![0] != idle)
    #expect(set.small[.idle]![1] != idle)   // 깜빡임 프레임
}
