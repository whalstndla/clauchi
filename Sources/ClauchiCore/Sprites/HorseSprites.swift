import Foundation

// 성체 말 도트 (스펙 §8) — 말랑이
// 실루엣: 머리 위 뾰족 갈기(M) + 뭉툭한 넓적 주둥이(W) + 큰 눈 + 갈색 직립 치비 말
enum HorseSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, B(0x42)=갈색 몸통, D(0x44)=진갈색 음영,
    // W(0x57)=밝은 베이지 배/주둥이/창백, M(0x4D)=진한 갈기색, E(0x45)=눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{42}": 0xA16207FF,   // B — 갈색 몸통
        "\u{44}": 0x78350FFF,   // D — 진갈색 음영
        "\u{57}": 0xFEF3E2FF,   // W — 밝은 베이지 배/주둥이/창백
        "\u{4D}": 0x292524FF,   // M — 진한 갈기색
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 머리 위 뾰족 갈기 3가닥 + 뭉툭 주둥이 + 배 흰 무늬
    static let idle1Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 오른쪽 위 땀방울
    static let working1Rows = [
        "....MMM.......W.",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 이동
    static let working2Rows = [
        "................",
        "....MMM.........",
        "...KMMMK......W.",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
    ]

    // 잠 — 눈 감음 + 오른쪽 위 zzz 표시
    static let sleeping1Rows = [
        "....MMM.......W.",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        "....MMM...W.....",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBK.....",
        ".KBBBBBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 배고픔 — 입 벌림
    static let hungry1Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWKKWBBK....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBKW....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWKKWBBK....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 위독 — 창백 (몸통 B와 배 W 반전)
    static let critical1Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMWWWK.......",
        "..KWWWWWK.......",
        ".KWWWWWWWWK.....",
        ".KWWEWWWWWK.....",
        ".KWWWEWWWWWK....",
        ".KWWWBBBBWWK....",
        ".KWWBBBBBBWK....",
        "..KWWBBBWWK.....",
        ".KWWBBBBBBWWK...",
        ".KWBBBBBBBBWK...",
        ".KWWBBBBBBWWK...",
        "..KWWWWWWWWWK...",
        "...KWK....KWK...",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        "....MMM.........",
        "...KMMMK........",
        "..KMMWWWK.......",
        "..KWWWWWK.......",
        ".KWWWWWWWWK.....",
        ".KWWEWWWWWK.....",
        ".KWWWEWWWWWK....",
        ".KWWWBBBBWWK....",
        ".KWWBBBBBBWK....",
        "..KWWBBBWWK.....",
        ".KWWBBBBBBWWK...",
        ".KWBBBBBBBBWK...",
        ".KWWBBBBBBWWK...",
        "..KWWWWWWWWWK...",
        "...KWK....KWK...",
    ]

    // 휴일 놀기 — 옆에 공 (아래)
    static let playing1Rows = [
        "....MMM.........",
        "...KMMMK........",
        "..KMMBBBK.......",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBKMM.",
        ".KBWWWWWWWWBKMM.",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튐
    static let playing2Rows = [
        "....MMM.........",
        "...KMMMK....MM..",
        "..KMMBBBK...MM..",
        "..KBBBBBK.......",
        ".KBBBBBBBBK.....",
        ".KBBEBBBBBK.....",
        ".KBBBEBBBBBK....",
        ".KBBBWWWWBBK....",
        ".KBBWWWWWBBK....",
        "..KBBWWWBBK.....",
        ".KBBWWWWWWBBK...",
        ".KBWWWWWWWWBK...",
        ".KBBWWWWWWBBK...",
        "..KBBBBBBBBBK...",
        "...KBK....KBK...",
        "................",
    ]

    // MARK: - 32×32 대형 초상화 (수작업 — 16×16 확대본 아님)

    // 행복 — 풍성한 갈기 + 눈 하이라이트 + 활짝 웃는 입 + 볼터치 없는 순박한 표정
    static let largeHappyRows = [
        "................................",
        ".......MMMMMM...................",
        "......KMMMMMMMK.................",
        ".....KMMMBBBBBMK................",
        ".....KMMBBBBBBMK................",
        ".....KMMBBBBBBMMK...............",
        "....KBBBBBBBBBBBK...............",
        "...KBBBBBBBBBBBBBBK.............",
        "..KBBBBBBBBBBBBBBBBK............",
        "..KBBBBBBBBBBBBBBBBBK...........",
        "..KBBBBBBBBBBBBBBBBBBK..........",
        "..KBBBBBBEEBBBBBBEEBBBBK........",
        "..KBBBBBBEEBBBBBBEEBBBBK........",
        "..KBBBBBBBBBBBBBBBBBBBDBK.......",
        "..KBBBBBBBBBBBBBBBBBBBBDBK......",
        "..KBBBBBBBBWWWWWWWWBBBBBDBK.....",
        "..KBBBBBBBWWWWWWWWWBBBBBBDK.....",
        "..KBBBBBBBWWKWWWWKWWBBBBBDK.....",
        "..KBBBBBBBWWKKKKKKWWBBBBBDK.....",
        "...KBBBBBBBBWWWWWWBBBBBBDK......",
        "....KBBBBBBBBBBBBBBBBBBBDK......",
        "....KBBBBBBBBBBBBBBBBBBDDK......",
        "...KBBBBBBWWWWWWWWWWWWBBDK......",
        "..KBBBBBBWWWWWWWWWWWWWWBDDK.....",
        "..KBBBBBBWWWWWWWWWWWWWWBDDDK....",
        "..KBBBBBBWWWWWWWWWWWWWWBDDDK....",
        "...KBBBBBWWWWWWWWWWWWWBBDDDK....",
        "....KBBBBBBBBBBBBBBBBBBDDDDK....",
        ".....KKKKKKKKKKKKKKKKKKKKKK.....",
        ".......KBBK............KBBK.....",
        ".......KKKK............KKKK.....",
        "................................",
    ]

    // 슬픔 — 갈기 축 처짐 + 눈물 + 아래로 굽은 입
    static let largeSadRows = [
        "................................",
        "................................",
        "......MMMMM.....................",
        ".....KMMMMMMK...................",
        "....KMMMBBBBMK..................",
        "....KMMBBBBBBMK.................",
        "....KMMBBBBBBMMK................",
        "...KBBBBBBBBBBBK................",
        "..KBBBBBBBBBBBBBBK..............",
        "..KBBBBBBBBBBBBBBBK.............",
        "..KBBBBBBBBBBBBBBBBK............",
        "..KBBBBBBEEBBBBBBEEBBBBK........",
        "..KBBBBBBEEBBBBBBEEBBBBK........",
        "..KBBBBBBBBWBBBBBBWBBBBDBK......",
        "..KBBBBBBBBBBBBBBBBBBBBBDBK.....",
        "..KBBBBBBBBWWWWWWWWBBBBBBBDK....",
        "..KBBBBBBBWWWWWWWWWBBBBBBDDK....",
        "..KBBBBBBBWWKKKKKKWWBBBBBDDK....",
        "..KBBBBBBBWWKWWWWKWWBBBBBDDK....",
        "...KBBBBBBBBWWWWWWBBBBBBDDK.....",
        "....KBBBBBBBBBBBBBBBBBBBDDK.....",
        "....KBBBBBBBBBBBBBBBBBBDDDK.....",
        "...KBBBBBBWWWWWWWWWWWWBBDDDK....",
        "..KBBBBBBWWWWWWWWWWWWWWBDDDDK...",
        "..KBBBBBBWWWWWWWWWWWWWWBDDDDK...",
        "..KBBBBBBWWWWWWWWWWWWWWBDDDDK...",
        "...KBBBBBWWWWWWWWWWWWWBBDDDDK...",
        "....KBBBBBBBBBBBBBBBBBBDDDDDK...",
        ".....KKKKKKKKKKKKKKKKKKKKKK.....",
        ".......KBBK............KBBK.....",
        ".......KKKK............KKKK.....",
        "................................",
    ]

    // 위독 — 창백한 몸 (몸통 B와 배 W 반전), X자 눈, 힘없는 일자 입
    static let largeCriticalRows = [
        "................................",
        ".......MMMMMM...................",
        "......KMMMMMMMK.................",
        ".....KMMWWWWWWMK................",
        ".....KMMWWWWWWMK................",
        ".....KMMWWWWWWMMK...............",
        "....KWWWWWWWWWWWK...............",
        "...KWWWWWWWWWWWWWWK.............",
        "..KWWWWWWWWWWWWWWWWK............",
        "..KWWWWWWWWWWWWWWWWWK...........",
        "..KWWWWWWWWWWWWWWWWWWK..........",
        "..KWWWWWWEWEWWWWWWEWEWWWWK......",
        "..KWWWWWWWEWWWWWWWWWEWWWWK......",
        "..KWWWWWWEWEWWWWWWEWEWWWWBBK....",
        "..KWWWWWWWWWWWWWWWWWWWWWWBBK....",
        "..KWWWWWWWWBBBBBBBBWWWWWWWBBK...",
        "..KWWWWWWWBBBBBBBBBBWWWWWWBBK...",
        "..KWWWWWWWBBBBBBBBBBWWWWWWBBK...",
        "..KWWWWWWWBBBBKKKKBBWWWWWWBBK...",
        "...KWWWWWWWWBBBBBBWWWWWWWBBK....",
        "....KWWWWWWWWWWWWWWWWWWWBBK.....",
        "....KWWWWWWWWWWWWWWWWWWWBBK.....",
        "...KWWWWWWBBBBBBBBBBBBWWWBBK....",
        "..KWWWWWWBBBBBBBBBBBBBBWWBBBK...",
        "..KWWWWWWBBBBBBBBBBBBBBWWBBBK...",
        "..KWWWWWWBBBBBBBBBBBBBBWWBBBK...",
        "...KWWWWWBBBBBBBBBBBBWWWWBBBK...",
        "....KWWWWWWWWWWWWWWWWWWWBBBBK...",
        ".....KKKKKKKKKKKKKKKKKKKKKKKK...",
        ".......KWWK............KWWK.....",
        ".......KKKK............KKKK.....",
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
