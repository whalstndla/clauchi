import Foundation

// 성체 용 도트 (스펙 §8)
// 실루엣: 머리 위 황금 뿔 2개 + 작은 날개 돌기 + 날카로운 황금 눈 + 초록 비늘 몸통
enum DragonSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, G(0x47)=초록 비늘 몸통, D(0x44)=진초록 음영,
    // W(0x57)=배/밝은 부분, Y(0x59)=황금 뿔, E(0x45)=황금 눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{47}": 0x22C55EFF,   // G — 초록 비늘 몸통
        "\u{44}": 0x15803DFF,   // D — 진초록 음영
        "\u{57}": 0xDCFCE7FF,   // W — 배/밝은 부분
        "\u{59}": 0xFBBF24FF,   // Y — 황금 뿔
        "\u{45}": 0xFBBF24FF,   // E — 황금 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 황금 뿔 + 날카로운 황금 눈 + 꼬리 오른쪽 아래
    static let idle1Rows = [
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 불꽃 방울
    static let working1Rows = [
        ".Y......Y..Y....",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 불꽃 방울 낙하
    static let working2Rows = [
        "................",
        ".Y......Y.......",
        ".KYK....KYK..Y..",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
    ]

    // 잠 — 눈 감고 우상단 zzz (W 도트)
    static let sleeping1Rows = [
        ".Y......Y.....W.",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        ".Y......Y..W....",
        ".KYK....KYK..W..",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 배고픔 — 벌린 입 (D 입 안쪽)
    static let hungry1Rows = [
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        "..KGWDDWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물 (W 방울)
    static let hungry2Rows = [
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK.W.",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        "..KGWDDWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
    ]

    // 위독 — 창백 (몸통 G→W, 배 W→G 반전), X자 눈
    static let critical1Rows = [
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KWWWKKWWWK....",
        ".KWWWWWWWWWWK...",
        ".KWWYGGGGYWK....",
        ".KWWGGGGGGWWK...",
        ".KWWGGGGGGWWK...",
        ".KWGGWGGGGWGWK..",
        "..KWGGGGGGWK....",
        ".KWWGGGGGGWWK...",
        ".KWGGGGGGGGWKD..",
        ".KWWGGGGGGWWK.D.",
        "..KWWWWWWWWK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        ".Y......Y.......",
        ".KYK....KYK.....",
        "..KWWWKKWWWK....",
        ".KWWWWWWWWWWK...",
        ".KWWYGGGGYWK....",
        ".KWWGGGGGGWWK...",
        ".KWWGGGGGGWWK...",
        ".KWGGWGGGGWGWK..",
        "..KWGGGGGGWK....",
        ".KWWGGGGGGWWK...",
        ".KWGGGGGGGGWKD..",
        ".KWWGGGGGGWWK.D.",
        "..KWWWWWWWWK..D.",
        "...KK....KK..DD.",
        "................",
    ]

    // 휴일 놀기 — 불꽃(Y) 내뿜기 + 공놀이 (아래)
    static let playing1Rows = [
        ".Y......Y....YY.",
        ".KYK....KYK..Y..",
        "..KGGGKKGGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.DD",
        "..KGGGGGGGGK..DD",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // 휴일 놀기 — 불꽃 위로 + 공 튀어오름
    static let playing2Rows = [
        ".Y..YY..Y.......",
        ".KYK..Y.KYK..DD.",
        "..KGGGKKGGGK.DD.",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGK....",
        ".KGYGGGGGGYGK...",
        ".KGGWWWWWWGGK...",
        ".KGWWDWWWDWGK...",
        "..KGWWWWWWGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKD..",
        ".KGGWWWWWWGGK.D.",
        "..KGGGGGGGGK..D.",
        "...KK....KK..DD.",
        "................",
        "................",
    ]

    // MARK: - 32×32 대형 초상화

    // 행복 — 황금 뿔 크게, 날개 돌기, 활짝 웃는 입, 황금 눈 하이라이트
    static let largeHappyRows = [
        "..YY....................YY......",
        "..KYYK..................KYYK....",
        "..KYYYK................KYYYK....",
        "...KYYK.................KYYK....",
        "....KGGGKKKKKKKKKKKKKKGGGK......",
        "...KGGGGGGGGGGGGGGGGGGGGGGK.....",
        "..KGGGGGGGGGGGGGGGGGGGGGGDDK....",
        "..KGGEGGGGGGGGGGGGGGGGEGDDK.....",
        "..KGYEGGGGGGGGGGGGGGGEYDDK......",
        "..KGGGGGGGGGGGGGGGGGGGGGDDK.....",
        "..KGGGGGGGGGGGGGGGGGGGGGDDK.....",
        "..KGGGWWWWWWWWWWWWWWGGGDDK......",
        "..KGGWWWDWWWWWWWWDWWWGGDDK......",
        "K.KGGGWWWWWWWWWWWWWGGGDDK....K..",
        "..KGGGWWWWWWWWWWWWWGGGDDK.......",
        "K.KGGGWWWKWWWWWWKWWWGGGDDK...K..",
        "..KGGGWWWWKKKKKKKWWWGGGDDK......",
        "...KGGGGGGGGGGGGGGGGGGGDDK......",
        "....KGGGGGGGGGGGGGGGGGGDDK......",
        "...KGGGGWWWWWWWWWWWWGGGGDDK.....",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK....",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDKD...",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK.D..",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK.D..",
        "...KGGGGWWWWWWWWWWWWWGGGGDDK.D..",
        "....KGGGGWWWWWWWWWWWGGGGDDK.D...",
        ".....KGGGGGGGGGGGGDDDDDDDDK.D...",
        "......KKKKKKKKKKKKKKKKKKKK.DD...",
        "........KKKK........KKKK.DDD....",
        "................................",
        "................................",
        "................................",
    ]

    // 슬픔 — 처진 눈썹, 아래로 굽은 입, 눈물 (W)
    static let largeSadRows = [
        "................................",
        "..YY....................YY......",
        "..KYYYK................KYYYK....",
        "...KYYK.................KYYK....",
        "....KGGGKKKKKKKKKKKKKKGGGK......",
        "...KGGGGGGGGGGGGGGGGGGGGGGK.....",
        "..KGGGGGGGGGGGGGGGGGGGGGGDDK....",
        "..KGGGGGGGGGGGGGGGGGGGGGDDK.....",
        "..KGGEGGGGGGGGGGGGGGGGEGDDK.....",
        "..KGYEGGGGGGGGGGGGGGGEYDDK......",
        "..KGGWGGGGGGGGGGGGGGWGGDDK......",
        "..KGGGWWWWWWWWWWWWWWGGGDDK......",
        "..KGGWWWDWWWWWWWWDWWWGGDDK......",
        "K.KGGGWWWWWWWWWWWWWGGGDDK....K..",
        "..KGGGWWWWWWWWWWWWWGGGDDK.......",
        "K.KGGGWWWWKKKKKKKKWWWGGGDDK...K.",
        "..KGGGWWWKWWWWWWWWKWWGGGDDK.....",
        "...KGGGGGGGGGGGGGGGGGGGDDK......",
        "....KGGGGGGGGGGGGGGGGGGDDK......",
        "...KGGGGWWWWWWWWWWWWGGGGDDK.....",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK....",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDKD...",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK.D..",
        "..KGGGGWWWWWWWWWWWWWWGGGDDDK.D..",
        "...KGGGGWWWWWWWWWWWWWGGGGDDK.D..",
        "....KGGGGWWWWWWWWWWWGGGGDDK.D...",
        ".....KGGGGGGGGGGGGDDDDDDDDK.D...",
        "......KKKKKKKKKKKKKKKKKKKK.DD...",
        "........KKKK........KKKK.DDD....",
        "................................",
        "................................",
        "................................",
    ]

    // 위독 — 창백한 비늘 (G↔W 반전), X자 눈, 음영은 G로 연하게
    static let largeCriticalRows = [
        "..YY....................YY......",
        "..KYYYK................KYYYK....",
        "...KYYK.................KYYK....",
        "....KWWWKKKKKKKKKKKKKKWWWK......",
        "...KWWWWWWWWWWWWWWWWWWWWWK......",
        "..KWWWWWWWWWWWWWWWWWWWWWWGGK....",
        "..KWWWWWWWWWWWWWWWWWWWWWWGGK....",
        "..KWWYEWWWWWWWWWWWWWWWEYGGK.....",
        "..KWWWEWWWWWWWWWWWWWWWEWWGGK....",
        "..KWWYEWWWWWWWWWWWWWWWEYGGK.....",
        "..KWWWWWWWWWWWWWWWWWWWWWWGGK....",
        "..KWWWGGGGGGGGGGGGGGWWWWGGK.....",
        "..KWWGGGGDGGGGGGGGDGGWWWWGGK....",
        "K.KWWWGGGGGGGGGGGGGGGGWWGGK...K.",
        "..KWWWGGGGGGGGGGGGGGGWWWGGK.....",
        "K.KWWWGGGGKKKKKKKGGGGWWWGGK...K.",
        "..KWWWGGGGKKKKKKKKGGGGWWWGGK....",
        "...KWWWWWWWWWWWWWWWWWWWWWGGK....",
        "....KWWWWWWWWWWWWWWWWWWWGGK.....",
        "...KWWWWGGGGGGGGGGGGGGWWWWGGK...",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK..",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGKD.",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK.D",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK.D",
        "...KWWWWGGGGGGGGGGGGGGWWWWGGGK.D",
        "....KWWWWGGGGGGGGGGGGWWWWGGGK.D.",
        ".....KWWWWWWWWWWWWGGGGGGGGK.D...",
        "......KKKKKKKKKKKKKKKKKKKK.DD...",
        "........KKKK........KKKK.DDD....",
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
