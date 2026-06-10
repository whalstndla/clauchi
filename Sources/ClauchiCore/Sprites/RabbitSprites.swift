import Foundation

// 성체 토끼 도트 (스펙 §8)
// 실루엣: 상단 3~4행을 차지하는 길게 솟은 두 귀(안쪽 핑크) + 둥근 머리 + 콤팩트한 꼬마 몸통.
// 귀가 세로 공간을 차지하므로 몸통을 납작하게 눌러 병아리형 아기(BabySprites)와 뚜렷이 구분된다.
enum RabbitSprites {
    // 팔레트 — 키는 유니코드 이스케이프로 표기해 행 문자열 길이 검증 스크립트가 행만 세도록 한다.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{4C}": 0xE5E7EBFF,   // L — 밝은 회백색 몸통
        "\u{44}": 0x9CA3AFFF,   // D — 회색 음영
        "\u{50}": 0xF472B6FF,   // P — 귀 안쪽/코/소품 핑크
        "\u{57}": 0xFEF3E2FF,   // W — 배/창백
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 쫑긋 선 두 귀 + 둥근 머리 + 납작한 몸통
    static let idle1Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLLLLLLLLLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프 + 땀방울
    static let working1Rows = [
        "....KK....KK..P.",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 변경
    static let working2Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK.P.",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 잠 — 귀 옆으로 축 처짐 + 감은 눈 + 우상단 z 표시
    static let sleeping1Rows = [
        "................",
        ".............W..",
        "................",
        ".KK..........KK.",
        ".KLPK......KPLK.",
        "..KKKKKKKKKKKK..",
        "..KLDDLLLLDDLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 잠 — z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "................",
        ".KK..........KK.",
        ".KLPK......KPLK.",
        "..KKKKKKKKKKKK..",
        "..KLDDLLLLDDLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 배고픔 — 벌린 입
    static let hungry1Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLKKLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLKW.",
        "..KLLLLPPLLLLK..",
        "..KLDLLKKLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 위독 — 창백(몸통/배 색 반전) + 귀 축 처짐
    static let critical1Rows = [
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KWPK......KPWK.",
        "..KKKKKKKKKKKK..",
        "..KWWEWWWWEWWK..",
        "..KWWWWPPWWWWK..",
        "..KWDWWWWWWDWK..",
        "..KWLLLLLLLLWK..",
        "..KWLLLLLLLLWK..",
        "...KWLLLLLLWK...",
        "...KWWWWWWWWK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 위독 — 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KWPK......KPWK.",
        "..KKKKKKKKKKKK..",
        "..KWWEWWWWEWWK..",
        "..KWWWWPPWWWWK..",
        "..KWDWWWWWWDWK..",
        "..KWLLLLLLLLWK..",
        "..KWLLLLLLLLWK..",
        "...KWLLLLLLWK...",
        "...KWWWWWWWWK...",
        "....KKKKKKKK....",
        "....K......K....",
    ]

    // 휴일 놀기 — 발치의 공
    static let playing1Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLK..",
        "..KLWWWWWWWWLK..",
        "...KLWWWWWWLK.PP",
        "...KLLLLLLLLK.PP",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 휴일 놀기 — 공이 튀어오름
    static let playing2Rows = [
        "................",
        "....KK....KK....",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLELLLLELLK..",
        "..KLLLLPPLLLLK..",
        "..KLDLLLLLLDLK..",
        "..KLWWWWWWWWLKPP",
        "..KLWWWWWWWWLKPP",
        "...KLWWWWWWLK...",
        "...KLLLLLLLLK...",
        "....KKKKKKKK....",
        "....K......K....",
        "................",
    ]

    // 32x32 초상 — 행복: 쫑긋 선 긴 귀 + 눈 하이라이트 + 활짝 웃는 입 + 우측 음영
    static let largeHappyRows = [
        "........KKK..........KKK........",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLPPK........KPPLK.......",
        ".......KLLLK........KLLLK.......",
        ".......KLLDK........KDLLK.......",
        ".......KLLLKKKKKKKKKKLLLK.......",
        ".....KKLLLLLLLLLLLLLLLLLLKK.....",
        "....KLLLLLLLLLLLLLLLLLLLLLLK....",
        "...KLLLLLLLLLLLLLLLLLLLLLLLLK...",
        "...KLLLLLLLLLLLLLLLLLLLLLLLDK...",
        "...KLLLLLEEWLLLLLLLLWEELLLLDK...",
        "...KLLLLLEEELLLLLLLLEEELLLLDK...",
        "...KLLLLLEEELLLLLLLLEEELLLLDK...",
        "...KLLPPLLLLLLLPPLLLLLLLPPLDK...",
        "...KLLLLLLLLLKPPPPKLLLLLLLLDK...",
        "...KLLLLLLLLLLKKKKLLLLLLLLDDK...",
        "...KLLLLLLLLLLLLLLLLLLLLLLDDK...",
        "....KLLLLLLLLLLLLLLLLLLLLDDK....",
        ".....KLLLLLLLLLLLLLLLLLLDDK.....",
        "......KKLLLLLLLLLLLLLLLLKK......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLLWWWWWWWWLDDDK.......",
        ".......KLLLLLLLLLLLLDDDDK.......",
        ".......KKKKKKKKKKKKKKKKKK.......",
        ".........KK..........KK.........",
    ]

    // 32x32 초상 — 슬픔: 귀가 양옆으로 축 처짐 + 안쪽으로 올라간 눈썹 + 눈물 + 처진 입
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "....KKLLLLLLLLLLLLLLLLLLLLKK....",
        "..KKKLLLLLLLLLLLLLLLLLLLLLLKKK..",
        ".KPKKLLLLLLLLLLLLLLLLLLLLLLKKPK.",
        ".KPKKLLLLLLLLLLLLLLLLLLLLLDKKPK.",
        ".KPKKLLLLLKKLLLLLLLLKKLLLLDKKPK.",
        ".KPKKLLLLEEELLLLLLLLEEELLLDKKPK.",
        ".KPKKLLLLEEELLLLLLLLEEELLLDKKPK.",
        ".KPKKLLLLLWLLLLPPLLLLLLLLLDKKPK.",
        ".KKKKLLLLLLLLLKKKKLLLLLLLLDKKKK.",
        "....KLLLLLLLLKLLLLKLLLLLLDDK....",
        "....KLLLLLLLLLLLLLLLLLLLLDDK....",
        ".....KLLLLLLLLLLLLLLLLLLDDK.....",
        "......KLLLLLLLLLLLLLLLLDDK......",
        "......KKLLLLLLLLLLLLLLLLKK......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLWWWWWWWWWWLDDK.......",
        ".......KLLLLWWWWWWWWLDDDK.......",
        ".......KLLLLLLLLLLLLDDDDK.......",
        ".......KKKKKKKKKKKKKKKKKK.......",
        ".........KK..........KK.........",
    ]

    // 32x32 초상 — 위독: 창백(몸통 W·배 L 반전) + X자 눈 + 귀 완전 처짐 + 몸 주저앉음
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "....KKWWWWWWWWWWWWWWWWWWWWKK....",
        "..KKKWWWWWWWWWWWWWWWWWWWWWWKKK..",
        ".KPKKWWWWWWWWWWWWWWWWWWWWWWKKPK.",
        ".KPKKWWWWWWWWWWWWWWWWWWWWWDKKPK.",
        ".KPKKWWWWEWEWWWWWWWWEWEWWWDKKPK.",
        ".KPKKWWWWWEWWWWWWWWWWEWWWWDKKPK.",
        ".KPKKWWWWEWEWWWWWWWWEWEWWWDKKPK.",
        ".KPKKWWWWWWWWWWPPWWWWWWWWWDKKPK.",
        ".KKKKWWWWWWWWWWKKWWWWWWWWWDKKKK.",
        "....KWWWWWWWWWWWWWWWWWWWWDDK....",
        ".....KWWWWWWWWWWWWWWWWWWDDK.....",
        "......KWWWWWWWWWWWWWWWWDDK......",
        "......KKWWWWWWWWWWWWWWWWKK......",
        ".......KWWWLLLLLLLLLLWDDK.......",
        ".......KWWWLLLLLLLLLLWDDK.......",
        ".......KWWWWLLLLLLLLWDDDK.......",
        ".......KWWWWWWWWWWWWDDDDK.......",
        ".......KKKKKKKKKKKKKKKKKK.......",
        ".........KK..........KK.........",
    ]

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
