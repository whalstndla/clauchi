import Foundation

// 병아리형 공용 아기 — 팔레트의 T 가 종별 틴트로 치환된다 (스펙 §8)
enum BabySprites {
    static func palette(tint: UInt32) -> [Character: UInt32] {
        [
            "K": 0x1C1917FF,   // 외곽선
            "T": tint,         // 몸통 (종별 색)
            "W": 0xFEF3E2FF,   // 배/볼/창백
            "E": 0x1C1917FF,   // 눈
            "P": 0xF472B6FF,   // 볼터치/소품
        ]
    }

    private static func grid(_ rows: [String], tint: UInt32) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette(tint: tint))!
    }

    // 기본 포즈 — 둥근 병아리형
    static let idle1Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTTTTTTTTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 일하는 중 — 폴짝 뛰기 + 땀방울
    static let working1Rows = [
        "................",
        ".....KKKKK..P...",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
        "................",
    ]

    static let working2Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK..P..",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 잠 — 눈 감고 zzz
    static let sleeping1Rows = [
        "................",
        "............W...",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTTTTTTTTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    static let sleeping2Rows = [
        ".............W..",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTTTTTTTTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 배고픔 — 벌린 입
    static let hungry1Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWPWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 배고픔 + 눈물
    static let hungry2Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK.W.",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWPWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 위독 — 창백 (몸통/배 색 반전)
    static let critical1Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KWWWWWK.....",
        "...KWWWWWWWK....",
        "..KWWEWWWEWWK...",
        "..KWWWWWWWWWK...",
        "..KWPWWWWWPWK...",
        "..KWWTTTTTWWK...",
        "...KWTTTTTWK....",
        "...KWWTTTWWK....",
        "....KWWWWWK.....",
        "....KWWWWWK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    // 위독 — 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "................",
        ".....KKKKK......",
        "....KWWWWWK.....",
        "...KWWWWWWWK....",
        "..KWWEWWWEWWK...",
        "..KWWWWWWWWWK...",
        "..KWPWWWWWPWK...",
        "..KWWTTTTTWWK...",
        "...KWTTTTTWK....",
        "...KWWTTTWWK....",
        "....KWWWWWK.....",
        "....KWWWWWK.....",
        ".....KKKKK......",
        "....K.....K.....",
    ]

    // 휴일 놀기 — 공놀이
    static let playing1Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK....",
        "....KTTTTTK.....",
        "....KTTTTTK..PP.",
        ".....KKKKK...PP.",
        "....K.....K.....",
        "................",
    ]

    static let playing2Rows = [
        "................",
        "................",
        ".....KKKKK......",
        "....KTTTTTK.....",
        "...KTTTTTTTK....",
        "..KTTETTTETTK...",
        "..KTTTTTTTTTK...",
        "..KTPTTTTTPTK...",
        "..KTTWWWWWTTK...",
        "...KTWWWWWTK....",
        "...KTTWWWTTK.PP.",
        "....KTTTTTK..PP.",
        "....KTTTTTK.....",
        ".....KKKKK......",
        "....K.....K.....",
        "................",
    ]

    static func set(tint: UInt32) -> SpriteSet {
        let idle1 = grid(idle1Rows, tint: tint)
        let hungry1 = grid(hungry1Rows, tint: tint)
        let critical1 = grid(critical1Rows, tint: tint)
        let small: [VisualState: [PixelGrid]] = [
            .idle: [idle1, grid(idle2Rows, tint: tint)],
            .working: [grid(working1Rows, tint: tint), grid(working2Rows, tint: tint)],
            .sleeping: [grid(sleeping1Rows, tint: tint), grid(sleeping2Rows, tint: tint)],
            .hungry: [hungry1, grid(hungry2Rows, tint: tint)],
            .critical: [critical1, grid(critical2Rows, tint: tint)],
            .playing: [grid(playing1Rows, tint: tint), grid(playing2Rows, tint: tint)],
        ]
        return SpriteSet(small: small,
                         large: [.happy: idle1.scaled(by: 2),
                                 .sad: hungry1.scaled(by: 2),
                                 .critical: critical1.scaled(by: 2)])
    }
}
