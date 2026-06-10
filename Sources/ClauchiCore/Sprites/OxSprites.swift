import Foundation

// 성체 소 도트 (스펙 §8)
// 실루엣: 머리 양옆에서 위로 솟은 상아색 뿔 + 넓은 크림색 주둥이(콧구멍 2개) + 다부진 통통한 몸
enum OxSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, B(0x42)=갈색 몸통, D(0x44)=진한 갈색 음영,
    // H(0x48)=상아색 뿔, W(0x57)=주둥이·배·창백, P(0x50)=콧구멍·볼터치·소품, E(0x45)=눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{42}": 0xB45309FF,   // B — 갈색 몸통
        "\u{44}": 0x7C2D12FF,   // D — 진한 갈색 음영
        "\u{48}": 0xFDE68AFF,   // H — 상아색 뿔
        "\u{57}": 0xFEF3E2FF,   // W — 주둥이/배/창백
        "\u{50}": 0xF472B6FF,   // P — 콧구멍/볼터치/소품
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 상태별 프레임

    // 기본 포즈 — 뿔 + 넓은 주둥이 + 배 무늬
    static let idle1Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBBBBBBBBBBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 땀방울
    static let working1Rows = [
        "..HH........HH..",
        ".KHHK......KHHKP",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 낙하
    static let working2Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK.P",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 잠 — 눈 감고 zzz (우상단 W 도트)
    static let sleeping1Rows = [
        "..............W.",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBBBBBBBBBBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    static let sleeping2Rows = [
        ".............W..",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBBBBBBBBBBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 배고픔 — 벌린 입
    static let hungry1Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWPPWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBKW",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWPPWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 위독 — 창백 (몸통·주둥이 색 반전)
    static let critical1Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KWWWWWWWWWWK..",
        ".KWWEWWWWWWEWWK.",
        ".KWPWWWWWWWWPWK.",
        ".KWBBBBBBBBBBWK.",
        ".KWBBPBBBBPBBWK.",
        "..KWBBBBBBBBWK..",
        "..KWWWWWWWWWWK..",
        "..KWWBBBBBBWWK..",
        "..KDWBBBBBBWDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // 위독 — 창백 + 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KWWWWWWWWWWK..",
        ".KWWEWWWWWWEWWK.",
        ".KWPWWWWWWWWPWK.",
        ".KWBBBBBBBBBBWK.",
        ".KWBBPBBBBPBBWK.",
        "..KWBBBBBBBBWK..",
        "..KWWWWWWWWWWK..",
        "..KWWBBBBBBWWK..",
        "..KDWBBBBBBWDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
    ]

    // 휴일 놀기 — 공놀이 (공이 아래)
    static let playing1Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBK..",
        "..KBBWWWWWWBBK..",
        "..KDBWWWWWWBDKPP",
        "..KKKKKKKKKKKKPP",
        "...KDK....KDK...",
        "................",
    ]

    // 휴일 놀기 — 공이 튀어오름
    static let playing2Rows = [
        "................",
        "..HH........HH..",
        ".KHHK......KHHK.",
        "..KHKKKKKKKKHK..",
        "..KBBBBBBBBBBK..",
        ".KBBEBBBBBBEBBK.",
        ".KBPBBBBBBBBPBK.",
        ".KBWWWWWWWWWWBK.",
        ".KBWWPWWWWPWWBK.",
        "..KBWWWWWWWWBK..",
        "..KBBBBBBBBBBKPP",
        "..KBBWWWWWWBBKPP",
        "..KDBWWWWWWBDK..",
        "..KKKKKKKKKKKK..",
        "...KDK....KDK...",
        "................",
    ]

    // MARK: - 32×32 표정 초상화 (수작업 — 16×16 확대본 아님)

    // 행복 — 활짝 웃는 입, 눈 하이라이트, 볼터치, 앞머리 갈기와 귀, 가슴 무늬
    static let happyLargeRows = [
        "................................",
        "..KHHK....................KHHK..",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHHK..KKKKKKKKKKKK..KHHHHHK.",
        "..KHHHHK.KBBBBBBBBBBBBK.KHHHHK..",
        "....KHHKKBBBBDDDDDDBBBBKKHHK....",
        "...KKKKKBBBBBDDDDDDBBBBBKKKKK...",
        "..KBBDDKBBBBBBDDDDBBBBBBKDDBBK..",
        "...KKKKKBBDDDBBBBBBDDDBBKKKKK...",
        ".......KBBWEEBBBBBBWEEBBK.......",
        ".......KBBEEEBBBBBBEEEBBK.......",
        ".......KPPBBBBBBBBBBBBPPK.......",
        ".......KBBWWWWWWWWWWWWBBK.......",
        ".......KBWWWWWWWWWWWWWWBK.......",
        ".......KBWWPPWWWWWWPPWWBK.......",
        ".......KBWWPPWWWWWWPPWWBK.......",
        ".......KBWWKWWWWWWWWKWWBK.......",
        ".......KBWWWKKKKKKKKWWWBK.......",
        ".......KBBWWWWWWWWWWWWBBK.......",
        ".......KBBBDDDDDDDDDDBBBK.......",
        "....KKKKBBBBBBBBBBBBBBBBKKKK....",
        "...KDDDBBBBBBBBBBBBBBBBBBDDDK...",
        "..KDDBBBBBBWWWWWWWWWWBBBBBBDDK..",
        "..KDBBBBBBWWWWWWWWWWWWBBBBBBDK..",
        "..KDBBBBBBWWWWWWWWWWWWBBBBBBDK..",
        "..KDDBBBBBWWWWWWWWWWWWBBBBBDDK..",
        "..KDDDBBBBWWWWWWWWWWWWBBBBDDDK..",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        "....KDDK................KDDK....",
        "....KKKK................KKKK....",
        "................................",
    ]

    // 슬픔 — 고개 1px 처짐, 처진 눈썹, 눈물, 아래로 굽은 입
    static let sadLargeRows = [
        "................................",
        "................................",
        "..KHHK....................KHHK..",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHHK..KKKKKKKKKKKK..KHHHHHK.",
        "..KHHHHK.KBBBBBBBBBBBBK.KHHHHK..",
        "....KHHKKBBBBDDDDDDBBBBKKHHK....",
        "...KKKKKBBBBBDDDDDDBBBBBKKKKK...",
        "..KBBDDKBBBBBBDDDDBBBBBBKDDBBK..",
        "...KKKKKBBBDDDBBBBDDDBBBKKKKK...",
        ".......KBBEEEBBBBBBEEEBBK.......",
        ".......KBBEEEBBBBBBEEEBBK.......",
        ".......KBBBWBBBBBBBBWBBBK.......",
        ".......KBBWWWWWWWWWWWWBBK.......",
        ".......KBWWWWWWWWWWWWWWBK.......",
        ".......KBWWPPWWWWWWPPWWBK.......",
        ".......KBWWPPWWWWWWPPWWBK.......",
        ".......KBWWWKKKKKKKKWWWBK.......",
        ".......KBWWKWWWWWWWWKWWBK.......",
        ".......KBBWWWWWWWWWWWWBBK.......",
        ".......KBBBDDDDDDDDDDBBBK.......",
        "....KKKKBBBBBBBBBBBBBBBBKKKK....",
        "...KDDDBBBBBBBBBBBBBBBBBBDDDK...",
        "..KDDBBBBBBWWWWWWWWWWBBBBBBDDK..",
        "..KDBBBBBBWWWWWWWWWWWWBBBBBBDK..",
        "..KDBBBBBBWWWWWWWWWWWWBBBBBBDK..",
        "..KDDBBBBBWWWWWWWWWWWWBBBBBDDK..",
        "..KDDDBBBBWWWWWWWWWWWWBBBBDDDK..",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        "....KDDK................KDDK....",
        "....KKKK................KKKK....",
    ]

    // 위독 — X자 눈 + 창백한 몸 (몸통·주둥이·가슴 색 반전), 힘없는 일자 입
    static let criticalLargeRows = [
        "................................",
        "..KHHK....................KHHK..",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHK..................KHHHHK.",
        ".KHHHHHK..KKKKKKKKKKKK..KHHHHHK.",
        "..KHHHHK.KWWWWWWWWWWWWK.KHHHHK..",
        "....KHHKKWWWWDDDDDDWWWWKKHHK....",
        "...KKKKKWWWWWDDDDDDWWWWWKKKKK...",
        "..KWWDDKWWWWWWDDDDWWWWWWKDDWWK..",
        "...KKKKKWWWWWWWWWWWWWWWWKKKKK...",
        ".......KWWEWEWWWWWWEWEWWK.......",
        ".......KWWWEWWWWWWWWEWWWK.......",
        ".......KWWEWEWWWWWWEWEWWK.......",
        ".......KWWBBBBBBBBBBBBWWK.......",
        ".......KWBBBBBBBBBBBBBBWK.......",
        ".......KWBBPPBBBBBBPPBBWK.......",
        ".......KWBBPPBBBBBBPPBBWK.......",
        ".......KWBBBBBBBBBBBBBBWK.......",
        ".......KWBBBBKKKKKKBBBBWK.......",
        ".......KWWBBBBBBBBBBBBWWK.......",
        ".......KWWWDDDDDDDDDDWWWK.......",
        "....KKKKWWWWWWWWWWWWWWWWKKKK....",
        "...KDDDWWWWWWWWWWWWWWWWWWDDDK...",
        "..KDDWWWWWWBBBBBBBBBBWWWWWWDDK..",
        "..KDWWWWWWBBBBBBBBBBBBWWWWWWDK..",
        "..KDWWWWWWBBBBBBBBBBBBWWWWWWDK..",
        "..KDDWWWWWBBBBBBBBBBBBWWWWWDDK..",
        "..KDDDWWWWBBBBBBBBBBBBWWWWDDDK..",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        "....KDDK................KDDK....",
        "....KKKK................KKKK....",
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
            .happy: grid(happyLargeRows),
            .sad: grid(sadLargeRows),
            .critical: grid(criticalLargeRows),
        ])
}
