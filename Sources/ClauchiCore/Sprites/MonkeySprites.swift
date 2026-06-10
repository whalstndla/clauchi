import Foundation

// 성체 원숭이 도트 (스펙 §8)
// 실루엣: 머리 양옆에 크고 둥근 귀(분홍 안쪽) + 밝은 베이지 얼굴 + 갈색 몸통 + 아래로 굽은 긴 꼬리, 직립 치비 비율
enum MonkeySprites {
    // 팔레트 키는 유니코드 이스케이프로 표기한다.
    // 검증 스크립트가 따옴표 안 대문자 문자열을 프레임 행으로 집계하므로 충돌을 피하기 위함.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{42}": 0x92400EFF,   // B — 갈색 몸통
        "\u{44}": 0x78350FFF,   // D — 진갈색 음영
        "\u{46}": 0xFDE68AFF,   // F — 밝은 베이지 얼굴
        "\u{57}": 0xFEF3E2FF,   // W — 배/창백
        "\u{50}": 0xFBCFE8FF,   // P — 분홍 귀 안쪽
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 양옆 둥근 귀 + 베이지 얼굴 + 아래로 굽은 꼬리
    static let idle1Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFBBBFBKPK",
        "..KKBFBBBBBBBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 일하는 중 — 1px 폴짝 + 우상단 땀방울
    static let working1Rows = [
        "....KKKKKKK....F",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 낙하
    static let working2Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK..F",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 잠 — 눈 감음 + 우상단 zzz (F 도트)
    static let sleeping1Rows = [
        "..............F.",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFBBBFBKPK",
        "..KKBFBBBBBBBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        ".............F..",
        "..............F.",
        "....KKKKKKK.....",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFBBBFBKPK",
        "..KKBFBBBBBBBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 배고픔 — 벌린 입 (K 테두리로 표현)
    static let hungry1Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFKKKFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPKF",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFKKKFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 위독 — 창백 (몸통 B 와 얼굴 F 반전)
    static let critical1Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KWWWK.KK...",
        ".KPKKKWBWKKKPK..",
        ".KPPKWBBBBWKPPK.",
        ".KPKWBBBEWWBKPK.",
        "..KKWBBEWWWWBKK.",
        "...KWBWWWWWWWK..",
        "...KWWBWWBWWWK..",
        "...KWWWWWWWWWK..",
        "...KWWBBBBBBWK..",
        "...KDWBBBBBBWDK.",
        "....KWWWWWWWWKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        "................",
        "....KKKKKKK.....",
        "..KK.KWWWK.KK...",
        ".KPKKKWBWKKKPK..",
        ".KPPKWBBBBWKPPK.",
        ".KPKWBBBEWWBKPK.",
        "..KKWBBEWWWWBKK.",
        "...KWBWWWWWWWK..",
        "...KWWBWWBWWWK..",
        "...KWWWWWWWWWK..",
        "...KWWBBBBBBWK..",
        "...KDWBBBBBBWDK.",
        "....KWWWWWWWWKD.",
        ".....KKKKKKK..D.",
        "..............K.",
    ]

    // 휴일 놀기 — 공이 오른쪽 아래 (P 2×2)
    static let playing1Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK...",
        ".KPKKKBFBKKKPK..",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDKPP",
        "....KBBBBBBBBKPP",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // 휴일 놀기 — 공이 위로 튐
    static let playing2Rows = [
        "................",
        "....KKKKKKK.....",
        "..KK.KBBBK.KK.PP",
        ".KPKKKBFBKKKPKPP",
        ".KPPKBFFFFBKPPK.",
        ".KPKBFFFEFFBKPK.",
        "..KKBFFEFFFFBKK.",
        "...KBFFFFFFFBK..",
        "...KBBFFFBFFBK..",
        "...KBBBBBBBBBK..",
        "...KBBWWWWWBBK..",
        "...KDBWWWWWBDK..",
        "....KBBBBBBBBKD.",
        ".....KKKKKKK..D.",
        "..............D.",
        "..............K.",
    ]

    // MARK: - 32×32 대형 초상화 (수작업 — 음영 D, 표정 차등)

    // 행복 — 양옆 큰 귀, 뜬 눈, 위로 휘어진 미소, 우측 D 음영
    static let largeHappyRows = [
        "................................",
        "......KKKKKKKKKKKKKK............",
        "...KK..KBBBBBBBBBBBK..KK........",
        "..KPPK.KBFFFFFFFFBK..KPPK.......",
        ".KPPPKKBFFFFFFFFFBKKPPPK........",
        ".KPPPKBFFFFFFFFFFFFFFFFFBKPPPK..",
        "..KPKKBFFFFFFFFFFFFFFFFFBKKPK...",
        "...KKKBFFFFFFEFFFEFFFFFFFBKKK...",
        "....KBFFFFFFFEEFEEFFFFFFFFFFBK..",
        "....KBFFFFFFFFFFFFFFFFFFBBBBDK..",
        "....KBFFFFFFEFFFFFFFEFFFFFBBDDK.",
        "....KBFFFFFFFFFFFFFFFFFFFFFFFDK.",
        "....KBFFFFKFFFFFFFKFFFFBBBBDDDK.",
        "....KBFFFFKKFFFFFKKFFFFBBBBDDDDK",
        ".....KBBFFFFFFFFFFFFFFBBBBBDDDK.",
        ".....KBBBBBBBBBBBBBBBBBBBBBDDDK.",
        "....KBBBWWWWWWWWWWWWWWWBBBBDDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "....KBBBBBWWWWWWWWWWWWBBBBBDDDK.",
        ".....KBBBBBWWWWWWWWWWBBBBBDDDDK.",
        "......KBBBBBBBBBBBBBBBBBBBBDDKK.",
        ".......KBBBBBBBBBBBBBBBBBBBBDK..",
        "........KKKKBBBBBBBBBBBBKKKK....",
        "..........KBBBBBBBBBBBBK........",
        "..........KBBBWWWWWWBBBK........",
        "..........KBBWWWWWWWBBK.........",
        "...........KBBWWWWWBBK..........",
        "...........KBBBBBBBBK...........",
        "............KKKKKKKK............",
        "................................",
    ]

    // 슬픔 — 양옆 귀 축 처짐, 눈물, 아래로 굽은 입
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "...KK......................KK...",
        "..KPPK..KKKKKKKKKKKKKK..KPPK....",
        ".KPPPK.KBBBBBBBBBBBBBBK.KPPPK...",
        ".KPPKKKBBBBBBBBBBBBBBBBBKKKPPK..",
        "..KPKKBFFFFFFFFFFFFFFFFFBKKPK...",
        "...KKKBFFFFFFFFFFFFFFFFFFBKKK...",
        "....KBFFFFFFEFFFEFFFFFFFBBDDK...",
        "....KBFFFFFFFEEFEEFFFFFFFBBDDK..",
        "....KBFFFFFFFFFFFFFFFFFFFFFFDDK.",
        "....KBFFFBFFFFFFFFFFFBFFBBBBDDK.",
        "....KBFFFFKFFFFFFFKFFFFBBBBDDDK.",
        ".....KBBFFFFFFFFFFFFBBBBBBBDDDK.",
        ".....KBBBBBBBBBBBBBBBBBBBBBDDDK.",
        "....KBBBWWWWWWWWWWWWWWWBBBBDDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "...KBBBBWWWWWWWWWWWWWWWWBBBBDDK.",
        "....KBBBBBWWWWWWWWWWWWBBBBBDDDK.",
        ".....KBBBBBWWWWWWWWWWBBBBBDDDDK.",
        "......KBBBBBBBBBBBBBBBBBBBBDDKK.",
        ".......KBBBBBBBBBBBBBBBBBBBBDK..",
        "........KKKKBBBBBBBBBBBBKKKK....",
        "..........KBBBBBBBBBBBBK........",
        "..........KBBBWWWWWWBBBK........",
        "..........KBBWWWWWWWBBK.........",
        "...........KBBWWWWWBBK..........",
        "...........KBBBBBBBBK...........",
        "............KKKKKKKK............",
        "................................",
    ]

    // 위독 — 창백한 몸 (B↔F 반전: 몸=베이지F, 얼굴=갈색B), E는 X자 눈으로 유지
    static let largeCriticalRows = [
        "................................",
        "......KKKKKKKKKKKKKK............",
        "...KK..KFFFFFFFFFFFK..KK........",
        "..KPPK.KFBBBBBBBBFK..KPPK.......",
        ".KPPPKKFBBBBBBBBBFKKPPPK........",
        ".KPPPKFBBBBBBBBBBBBBBBBBFKPPPK..",
        "..KPKKFBBBBBBBBBBBBBBBBBFKKPK...",
        "...KKKFBBBBBBEBBBEBBBBBBBFKKK...",
        "....KFBBBBBBBEEBEEBBBBBBBBBBFK..",
        "....KFBBBBBBBBBBBBBBBBBBFFFFDK..",
        "....KFBBBBBBEBBBBBBBEBBBBBFFDDK.",
        "....KFBBBBBBBBBBBBBBBBBBBBBBBDK.",
        "....KFBBBBKBBBBBBBKBBBBFFFFDDDK.",
        "....KFBBBBKKBBBBBKKBBBBFFFFDDDDK",
        ".....KFFBBBBBBBBBBBBBBFFFFFDDDK.",
        ".....KFFFFFFFFFFFFFFFFFFFFFDDDK.",
        "....KFFFFFFFFFFFFFFFFFFFFFFDDDK.",
        "...KFFFFFFFFFFFFFFFFFFFFFFFFDDK.",
        "...KFFFFFFFFFFFFFFFFFFFFFFFFDDK.",
        "...KFFFFFFFFFFFFFFFFFFFFFFFFDDK.",
        "....KFFFFFFFFFFFFFFFFFFFFFFDDDK.",
        ".....KFFFFFFFFFFFFFFFFFFFFDDDDK.",
        "......KFFFFFFFFFFFFFFFFFFFFDDKK.",
        ".......KFFFFFFFFFFFFFFFFFFFFDK..",
        "........KKKKFFFFFFFFFFFFKKKK....",
        "..........KFFFFFFFFFFFFK........",
        "..........KFFFFFFFFFFFFK........",
        "..........KFFFFFFFFFFFK.........",
        "...........KFFFFFFFFFK..........",
        "...........KFFFFFFFFK...........",
        "............KKKKKKKK............",
        "................................",
    ]

    // MARK: - 스프라이트 세트

    static let set = SpriteSet(
        small: [
            .idle: [grid(idle1Rows), grid(idle2Rows)],
            .working: [grid(working1Rows), grid(working2Rows)],
            .sleeping: [grid(sleeping1Rows), grid(sleeping2Rows)],
            .hungry: [grid(hungry1Rows), grid(hungry2Rows)],
            .critical: [grid(critical1Rows), grid(critical2Rows)],
            .playing: [grid(playing1Rows), grid(playing2Rows)],
        ],
        large: [
            .happy: grid(largeHappyRows),
            .sad: grid(largeSadRows),
            .critical: grid(largeCriticalRows),
        ])
}
