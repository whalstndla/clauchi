import Foundation

enum EggSprites {
    static let palette: [Character: UInt32] = [
        "K": 0x1C1917FF,   // 외곽선
        "W": 0xFEF3E2FF,   // 껍데기
        "S": 0xFACC15FF,   // 무늬
    ]

    static let frame1 = PixelGrid(rows: [
        "................",
        "......KKKK......",
        ".....KWWWWK.....",
        "....KWWWWWWK....",
        "...KWWWSSWWWK...",
        "...KWWWSSWWWK...",
        "..KWWWWWWWWWWK..",
        "..KWWWWWWWWWWK..",
        "..KWSSWWWWSSWK..",
        "..KWSSWWWWSSWK..",
        "..KWWWWWWWWWWK..",
        "...KWWWWWWWWK...",
        "...KWWWWWWWWK...",
        "....KWWWWWWK....",
        ".....KKKKKK.....",
        "................",
    ], palette: palette)!

    // 흔들림 프레임 — 살짝 기울어짐
    static let frame2 = PixelGrid(rows: [
        "................",
        ".......KKKK.....",
        "......KWWWWK....",
        ".....KWWWWWWK...",
        "....KWWWSSWWWK..",
        "...KWWWSSWWWWK..",
        "..KWWWWWWWWWWK..",
        "..KWWWWWWWWWWK..",
        "..KWSSWWWWSSWK..",
        "..KWSSWWWWSSWK..",
        "..KWWWWWWWWWWK..",
        "...KWWWWWWWWK...",
        "...KWWWWWWWWK...",
        "....KWWWWWWK....",
        ".....KKKKKK.....",
        "................",
    ], palette: palette)!

    static let set = SpriteSet(
        small: [.egg: [frame1, frame2]],
        large: [
            .happy: frame1.scaled(by: 2),
            .sad: frame2.scaled(by: 2),
            .critical: frame2.scaled(by: 2),
        ])
}
