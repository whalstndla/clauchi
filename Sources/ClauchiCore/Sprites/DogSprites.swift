import Foundation

// 성체 강아지 도트 (스펙 §8)
// 실루엣: 치비 직립 몸 + 양쪽으로 축 처진 큰 귀 + 동그란 눈 + 검은 코 + 밝은 주둥이
enum DogSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, T(0x54)=황갈색 몸통, D(0x44)=진갈색 음영,
    // W(0x57)=밝은 배/주둥이/창백, N(0x4E)=검은 코, E(0x45)=눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{54}": 0xD97706FF,   // T — 황갈색 몸통
        "\u{44}": 0xB45309FF,   // D — 진갈색 음영
        "\u{57}": 0xFEF3E2FF,   // W — 밝은 배/주둥이/창백
        "\u{4E}": 0x1C1917FF,   // N — 검은 코
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 양쪽 축 처진 귀 + 동그란 눈 + 검은 코 + 밝은 주둥이
    // 귀는 머리 양 옆에서 아래쪽으로 늘어지는 형태
    static let idle1Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 일하는 중 — 1px 위로 폴짝 + 오른쪽 위 땀방울 (W 픽셀)
    static let working1Rows = [
        "..KTKKKKKKKTK.W.",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK.W.",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 잠 — 눈 감고 오른쪽 위에 zzz (W 픽셀)
    static let sleeping1Rows = [
        "................",
        "..KTKKKKKKKTK.W.",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 잠 — zzz 한 칸 위로 떠오름
    static let sleeping2Rows = [
        ".............W..",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 배고픔 — 입 벌림 (주둥이 아래 W 픽셀로 벌린 모양)
    static let hungry1Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWWTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 배고픔 — 입 벌림 + 눈물 (E 아래 W 픽셀)
    static let hungry2Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KKW",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWWTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 위독 — 창백 (몸통 T↔W, 배 W↔T 반전). 눈 X자
    static let critical1Rows = [
        "................",
        "..KWKKKKKKKKWK..",
        ".KWWWKKKKKWWWK..",
        "KWWK.KWWWWK.KWK.",
        "KWK..KWWWWK..KWK",
        "KWK..KWWWWK..KWK",
        "KWK..KWTWTWK.KWK",
        ".KK..KWTWTWK.KK.",
        ".....KWTNNWTK...",
        ".....KWTTTWTK...",
        ".....KTTTTTTTK..",
        ".....KWWTWWWK...",
        ".....KWWDWWWK...",
        "......KWWWWK....",
        "......KK..KK....",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        "................",
        "..KWKKKKKKKKWK..",
        ".KWWWKKKKKWWWK..",
        "KWWK.KWWWWK.KWK.",
        "KWK..KWWWWK..KWK",
        "KWK..KWWWWK..KWK",
        "KWK..KWTWTWK.KWK",
        ".KK..KWTWTWK.KK.",
        ".....KWTNNWTK...",
        ".....KWTTTWTK...",
        ".....KTTTTTTTK..",
        ".....KWWTWWWK...",
        ".....KWWDWWWK...",
        "......KWWWWK....",
        "......KK..KK....",
    ]

    // 휴일 놀기 — 오른쪽 아래에 공 (D 2×2)
    static let playing1Rows = [
        "................",
        "..KTKKKKKKKTK...",
        ".KTTTKKKKTTTK...",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK.DD",
        ".....KWWWWWWK.DD",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튐
    static let playing2Rows = [
        "................",
        "..KTKKKKKKKTK.DD",
        ".KTTTKKKKTTTK.DD",
        "KTTK.KTTTTK.KTK.",
        "KTK..KTTTTK..KTK",
        "KTK..KTTTTK..KTK",
        "KTK..KETTTEK.KTK",
        ".KK..KTWTWTK.KK.",
        ".....KTWNNWTK...",
        ".....KTWWWWTK...",
        ".....KWWWWWWK...",
        ".....KTTWTTTK...",
        ".....KTTDTTTK...",
        "......KTTTTK....",
        "......KK..KK....",
        "................",
    ]

    // MARK: - 32×32 대형 초상화

    // 행복 — 쫑긋한 귀(축 처져도 폭 넓게), 뜬 눈, 올라간 미소, 오른쪽 D 음영
    static let largeHappyRows = [
        "................................",
        "KTTK............................",
        "KTTK....KTTTKKKKKKKTTTK.........",
        "KTTTK..KTTTTTKKKKKTTTTTK........",
        ".KTTTKKTTTTTTTKKKTTTTTTTK.......",
        "..KTTTTTTTTTTTTKTTTTTTTTTK......",
        "...KTTTTTTTTTTTTTTTTTTTTTTK.....",
        "....KTTTTTTTTTTTTTTTTTTTTTTK....",
        "....KTTTTTTTTTTTTTTTTTTTTTDDK...",
        "...KTTTTTTTTTTTTTTTTTTTTTTDDDDK.",
        "..KTTTTTTTTTTTTTTTTTTTTTTTTDDDK.",
        "..KTTTTTTTTTTTTTTTTTTTTTTTTDDDK.",
        "..KTTTTTTEETTTTTTTTTEETTTTTTDDK.",
        "..KTTTTTTEETTTTTTTTTEETTTTTTDDK.",
        "..KTTTTTTTTTTWWWWWWWTTTTTTTTDDK.",
        "..KTTTTTTTTTTWWNNNNWTTTTTTTTDDK.",
        "..KTTTTTTTTTTWWWWWWWTTTTTTTTDDK.",
        "...KTTTTTTTTTTWWWWWTTTTTTTTDDDK.",
        "....KTTTTTTTTTTTTTTTTTTTTTTDDKK.",
        "...KTTTTTWWWWWWWWWWWWWWTTTTDDK..",
        "..KTTTTTWWWWWWWWWWWWWWWWTTTTDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTTDDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTDDDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTDDDK..",
        "...KTTTTTWWWWWWWWWWWWWTTTTDDDKK.",
        "....KTTTTTTTTTTTTTTTTTTTTTDDKK..",
        ".....KTTTTTTTTTTTTTTTTTTDDDDK...",
        "......KKKKKKKKKKKKKKKKKKKKKK....",
        "........KKKK........KKKK........",
        "................................",
        "................................",
        "................................",
    ]

    // 슬픔 — 축 처진 귀(더 아래로 늘어짐), 내려간 눈썹, 눈물, 내려간 입꼬리
    static let largeSadRows = [
        "................................",
        "................................",
        "KTTK............................",
        "KTTTTK..KTTTKKKKKKKTTTK.........",
        ".KTTTTKKTTTTTKKKKKTTTTTK........",
        "..KTTTTTTTTTTTTKTTTTTTTTTK......",
        "...KTTTTTTTTTTTTTTTTTTTTTTK.....",
        "....KTTTTTTTTTTTTTTTTTTTTTTK....",
        "....KTTTTTTTTTTTTTTTTTTTTTDDK...",
        "...KTTTTTTTTTTTTTTTTTTTTTTDDDDK.",
        "..KTTTTTTTTTTTTTTTTTTTTTTTTDDDK.",
        "..KTTTTTTTTTTTTTTTTTTTTTTTTDDDK.",
        "..KTTTTTTTEETTTTTTTTTEETTTTDDK..",
        "..KTTTTTTTEETTTTTTTTTEETTTTDDK..",
        "K.KTTTTTTTTTTWWWWWWWTTTTTTTTDDK.",
        "..KTTTTTTTTTTWWNNNNWTTTTTTTTDDK.",
        "K.KTTTTTTTTTTWTTTTTWTTTTTTTDDK..",
        "..KTTTTTTTTTTTWWWWTTTTTTTTTDDK..",
        "...KTTTTTTTTTTTTTTTTTTTTTTDDDK..",
        "...KTTTTTTWWWWWWWWWWWWWWTTDDK...",
        "..KTTTTTWWWWWWWWWWWWWWWWTTTTDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTTDDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTDDDDK.",
        "..KTTTTTWWWWWWWWWWWWWWWWTTDDDK..",
        "...KTTTTTWWWWWWWWWWWWWTTTTDDDKK.",
        "....KTTTTTTTTTTTTTTTTTTTTTDDKK..",
        ".....KTTTTTTTTTTTTTTTTTTDDDDK...",
        "......KKKKKKKKKKKKKKKKKKKKKK....",
        "........KKKK........KKKK........",
        "................................",
        "................................",
        "................................",
    ]

    // 위독 — 창백한 몸(W), X자 눈, 일자 입, 음영은 T로 연하게
    static let largeCriticalRows = [
        "................................",
        "KWWK............................",
        "KWWK....KWWWKKKKKKKWWWK.........",
        "KWWWK..KWWWWWKKKKKWWWWWK........",
        ".KWWWKKWWWWWWWKKKWWWWWWWK.......",
        "..KWWWWWWWWWWWWKWWWWWWWWWK......",
        "...KWWWWWWWWWWWWWWWWWWWWWWK.....",
        "....KWWWWWWWWWWWWWWWWWWWWWWK....",
        "....KWWWWWWWWWWWWWWWWWWWWWTTK...",
        "...KWWWWWWWWWWWWWWWWWWWWWWTTTK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWTTTK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWTTTK.",
        "..KWWWWWWTWWWWWWWWWWTWWWWWWTTTK.",
        "..KWWWWWWWTWWWWWWWWTWWWWWWWTTTK.",
        "..KWWWWWWWWWWTTTTTTTWWWWWWWTTTK.",
        "..KWWWWWWWWWWTTNNNNTTWWWWWWTTTK.",
        "..KWWWWWWWWWWTTTTTTTWWWWWWWTTTK.",
        "...KWWWWWWWWWWTTTTTTWWWWWWWTTTK.",
        "....KWWWWWWWWWWWWWWWWWWWWWTTTKK.",
        "...KWWWWWTTTTTTTTTTTTTTTWWWWTTK.",
        "..KWWWWWTTTTTTTTTTTTTTTTTTWWWTTK",
        "..KWWWWWTTTTTTTTTTTTTTTTTTWWTTTK",
        "..KWWWWWTTTTTTTTTTTTTTTTTTWTTTTK",
        "..KWWWWWTTTTTTTTTTTTTTTTTTWTTTKK",
        "...KWWWWWTTTTTTTTTTTTTTTWTTTTKK.",
        "....KWWWWWWWWWWWWWWWWWWWWWTTKKK.",
        ".....KWWWWWWWWWWWWWWWWWWWTTTK...",
        "......KKKKKKKKKKKKKKKKKKKKKK....",
        "........KKKK........KKKK........",
        "................................",
        "................................",
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
