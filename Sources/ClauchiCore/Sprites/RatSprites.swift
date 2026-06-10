import Foundation

// 성체 쥐 도트 (스펙 §8)
// 실루엣: 머리 위 둥근 귀 2개 + 옆/아래로 길게 굽은 분홍 꼬리, 직립 치비 비율
enum RatSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기한다.
    // 검증 스크립트가 따옴표 안 대문자 문자열을 프레임 행으로 집계하므로 충돌을 피하기 위함.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{47}": 0x9CA3AFFF,   // G — 회색 몸통
        "\u{44}": 0x6B7280FF,   // D — 진회색 음영
        "\u{57}": 0xFEF3E2FF,   // W — 배/주둥이/창백
        "\u{50}": 0xF472B6FF,   // P — 귀 안쪽/코/꼬리
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16x16 소형 프레임

    // 기본 포즈 — 둥근 귀 + 오른쪽 아래로 굽은 꼬리
    static let idle1Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 땀방울 (W 하이라이트 + P 방울)
    static let working1Rows = [
        "..KKK....KKK.W..",
        ".KGGGK..KGGGK.P.",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK.P.",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 잠 — 눈 감고 오른쪽 위에 zzz 표시 (W 픽셀)
    static let sleeping1Rows = [
        "................",
        "..KKK....KKK..W.",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        ".............W..",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGGGGGGGGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 배고픔 — 벌린 입 (P)
    static let hungry1Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWPPWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK.W.",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWPPWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 위독 — 창백 (몸통 G 와 배 W 반전)
    static let critical1Rows = [
        "................",
        "..KKK....KKK....",
        ".KWWWK..KWWWK...",
        ".KWPWK..KWPWK...",
        "..KWWKKKKWWK....",
        ".KWWWWWWWWWWK...",
        ".KWWEWWWWEWWK...",
        ".KWWWGGGGWWWK...",
        ".KWWGGPPGGWWK...",
        "..KWWGGGGWWK....",
        ".KWWGGGGGGWWK...",
        ".KWGGGGGGGGWKP..",
        ".KWWGGGGGGWWK.P.",
        "..KWWWWWWWWK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        "................",
        "..KKK....KKK....",
        ".KWWWK..KWWWK...",
        ".KWPWK..KWPWK...",
        "..KWWKKKKWWK....",
        ".KWWWWWWWWWWK...",
        ".KWWEWWWWEWWK...",
        ".KWWWGGGGWWWK...",
        ".KWWGGPPGGWWK...",
        "..KWWGGGGWWK....",
        ".KWWGGGGGGWWK...",
        ".KWGGGGGGGGWKP..",
        ".KWWGGGGGGWWK.P.",
        "..KWWWWWWWWK..P.",
        "...KK....KK..PP.",
    ]

    // 휴일 놀기 — 옆에 공 (P 2x2)
    static let playing1Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK...",
        ".KGPGK..KGPGK...",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK..PP",
        ".KGGWWWWWWGGK.PP",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튐
    static let playing2Rows = [
        "................",
        "..KKK....KKK....",
        ".KGGGK..KGGGK.PP",
        ".KGPGK..KGPGK.PP",
        "..KGGKKKKGGK....",
        ".KGGGGGGGGGGK...",
        ".KGGEGGGGEGGK...",
        ".KGGGWWWWGGGK...",
        ".KGGWWPPWWGGK...",
        "..KGGWWWWGGK....",
        ".KGGWWWWWWGGK...",
        ".KGWWWWWWWWGKP..",
        ".KGGWWWWWWGGK.P.",
        "..KGGGGGGGGK..P.",
        "...KK....KK..PP.",
        "................",
    ]

    // MARK: - 32x32 대형 초상화 (수작업 — 음영 D, 수염 K 단일 픽셀, 표정 차등)

    // 행복 — 쫑긋 선 귀, 뜬 눈, 위로 휘어진 미소, 몸 오른쪽 가장자리 D 음영
    static let largeHappyRows = [
        "................................",
        ".....KKKKK............KKKKK.....",
        "....KGGGGGK..........KGGGGGK....",
        "...KGPPPPGK..........KGPPPPGK...",
        "...KGPPPPGK..........KGPPPPGK...",
        "....KGPPGK............KGPPGK....",
        ".....KGGGKKKKKKKKKKKKKKGGGK.....",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGDDK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGDDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGDDK..",
        "..KGGGGGGEEGGGGGGGGGGEEGGGGDDK..",
        "..KGGGGGGEEGGGGGGGGGGEEGGGGDDK..",
        "K.KGGGGGGGGGWWWWWWWWGGGGGGGDDK.K",
        "..KGGGGGGGGGWWWPPWWWGGGGGGGDDK..",
        "K.KGGGGGGGGGWKWWWWKWGGGGGGGDDK.K",
        "..KGGGGGGGGGWWKKKKWWGGGGGGGDDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGDDK...",
        "....KGGGGGGGGGGGGGGGGGGGGDDK....",
        "...KGGGGWWWWWWWWWWWWWWGGGGDDK...",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK..",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDKP.",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK.P",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK.P",
        "...KGGGGWWWWWWWWWWWWWGGGGDDDK..P",
        "....KGGGGWWWWWWWWWWWGGGGDDDK..P.",
        ".....KGGGGGGGGGGGGDDDDDDDDK..P..",
        "......KKKKKKKKKKKKKKKKKKKK.PP...",
        "........KKKK........KKKK.PPP....",
        "................................",
        "................................",
        "................................",
    ]

    // 슬픔 — 축 처진 귀 (바깥쪽으로 늘어짐), 눈물, 아래로 휘어진 입
    static let largeSadRows = [
        "................................",
        "................................",
        "...KKKK..................KKKK...",
        "..KGGGGK................KGGGGK..",
        "..KGPPGGK..............KGGPPGK..",
        "..KGPPGGGK............KGGGPPGK..",
        "...KGGGGGKKKKKKKKKKKKKKGGGGGK...",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGDDK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGDDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGDDK..",
        "..KGGGGGGEEGGGGGGGGGGEEGGGGDDK..",
        "..KGGGGGGEEGGGGGGGGGGEEGGGGDDK..",
        "K.KGGGGGGWGGWWWWWWWWGGGGGGGDDK.K",
        "..KGGGGGGWGGWWWPPWWWGGGGGGGDDK..",
        "K.KGGGGGGGGGWWKKKKWWGGGGGGGDDK.K",
        "..KGGGGGGGGGWKWWWWKWGGGGGGGDDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGDDK...",
        "....KGGGGGGGGGGGGGGGGGGGGDDK....",
        "...KGGGGWWWWWWWWWWWWWWGGGGDDK...",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK..",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDKP.",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK.P",
        "..KGGGGWWWWWWWWWWWWWWWWGGGDDDK.P",
        "...KGGGGWWWWWWWWWWWWWGGGGDDDK..P",
        "....KGGGGWWWWWWWWWWWGGGGDDDK..P.",
        ".....KGGGGGGGGGGGGDDDDDDDDK..P..",
        "......KKKKKKKKKKKKKKKKKKKK.PP...",
        "........KKKK........KKKK.PPP....",
        "................................",
        "................................",
        "................................",
    ]

    // 위독 — 창백한 몸 (W), X 자로 감긴 눈, 일자로 다문 작은 입, 음영은 G 로 연하게
    static let largeCriticalRows = [
        "................................",
        ".....KKKKK............KKKKK.....",
        "....KWWWWWK..........KWWWWWK....",
        "...KWPPPPWK..........KWPPPPWK...",
        "...KWPPPPWK..........KWPPPPWK...",
        "....KWPPWK............KWPPWK....",
        ".....KWWWKKKKKKKKKKKKKKWWWK.....",
        "....KWWWWWWWWWWWWWWWWWWWWWWK....",
        "...KWWWWWWWWWWWWWWWWWWWWWWGGK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWGGK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWGGK..",
        "..KWWWWWEWEWWWWWWWWWWEWEWWWGGK..",
        "..KWWWWWWEWWWWWWWWWWWWEWWWWGGK..",
        "K.KWWWWWEWEWGGGGGGGGWEWEWWWGGK.K",
        "..KWWWWWWWWWGGGPPGGGWWWWWWWGGK..",
        "K.KWWWWWWWWWGGGGGGGGWWWWWWWGGK.K",
        "..KWWWWWWWWWGGGKKGGGWWWWWWWGGK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWGGK...",
        "....KWWWWWWWWWWWWWWWWWWWWGGK....",
        "...KWWWWGGGGGGGGGGGGGGWWWWGGK...",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK..",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGKP.",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK.P",
        "..KWWWWGGGGGGGGGGGGGGGGWWWGGGK.P",
        "...KWWWWGGGGGGGGGGGGGWWWWGGGK..P",
        "....KWWWWGGGGGGGGGGGWWWWGGGK..P.",
        ".....KWWWWWWWWWWWWGGGGGGGGK..P..",
        "......KKKKKKKKKKKKKKKKKKKK.PP...",
        "........KKKK........KKKK.PPP....",
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
