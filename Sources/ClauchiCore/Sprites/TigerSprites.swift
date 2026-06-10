import Foundation

// 성체 호랑이 도트 (스펙 §8)
// 실루엣: 머리 위 둥근 귀 2개 + 이마 세로 줄무늬 + 연한 주둥이 + 몸통 옆 줄무늬 + 짧은 꼬리, 직립 치비 비율
enum TigerSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기한다.
    // 검증 스크립트가 따옴표 안 대문자 문자열을 프레임 행으로 집계하므로 충돌을 피하기 위함.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선 + 줄무늬
        "\u{4F}": 0xF59E42FF,   // O — 주황 몸통
        "\u{44}": 0xC2702AFF,   // D — 진한 주황 음영
        "\u{57}": 0xFEF3E2FF,   // W — 배/주둥이/창백
        "\u{50}": 0xF472B6FF,   // P — 코/공/소품
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16x16 소형 프레임

    // 기본 포즈 — 둥근 귀 + 이마 줄무늬 + 연한 주둥이 + 오른쪽 꼬리
    static let idle1Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 깜빡임 — 눈을 감아 음영 선만 남김
    static let idle2Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOODOOOOOODOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 점프 + 오른쪽 위 땀방울
    static let working1Rows = [
        "..KKK......KKK.W",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 자세 + 땀방울이 아래로 이동
    static let working2Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOKW",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 잠 — 눈 감음 + 오른쪽 위 잠 표시
    static let sleeping1Rows = [
        "..............W.",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOODOOOOOODOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 잠 — 잠 표시가 아래로 이동
    static let sleeping2Rows = [
        "................",
        "..KKK......KKK.W",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOODOOOOOODOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 배고픔 — 입을 크게 벌림
    static let hungry1Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWKKKKWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈가 눈물
    static let hungry2Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOKW",
        ".KOOWWWPPWWWOOK.",
        ".KODWWKKKKWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 위독 — 창백 (몸통 주황과 배 색을 맞바꿈, 줄무늬 유지)
    static let critical1Rows = [
        "................",
        "..KKK......KKK..",
        ".KWDWK....KWDWK.",
        ".KWWWKKKKKKWWWK.",
        ".KWWWWWWWWWWWWK.",
        ".KWWKWWKKWWKWWK.",
        ".KWWEWWWWWWEWWK.",
        ".KWWOOOPPOOOWWK.",
        ".KWDOOOKKOOODWK.",
        "..KWWOOOOOOWWK..",
        "..KWKWOOOOWKWKD.",
        "..KWWOOOOOOWWKD.",
        "..KWKWOOOOWKWK..",
        "..KWWWWWWWWWWK..",
        "...KKK....KKK...",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "..KKK......KKK..",
        ".KWDWK....KWDWK.",
        ".KWWWKKKKKKWWWK.",
        ".KWWWWWWWWWWWWK.",
        ".KWWKWWKKWWKWWK.",
        ".KWWEWWWWWWEWWK.",
        ".KWWOOOPPOOOWWK.",
        ".KWDOOOKKOOODWK.",
        "..KWWOOOOOOWWK..",
        "..KWKWOOOOWKWKD.",
        "..KWWOOOOOOWWKD.",
        "..KWKWOOOOWKWK..",
        "..KWWWWWWWWWWK..",
        "...KKK....KKK...",
    ]

    // 휴일 놀기 — 왼쪽 아래 공
    static let playing1Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "..KOKOWWWWOKOKD.",
        "..KOOWWWWWWOOKD.",
        "PPKOKOWWWWOKOK..",
        "PPKOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어 오름
    static let playing2Rows = [
        "................",
        "..KKK......KKK..",
        ".KODOK....KODOK.",
        ".KOOOKKKKKKOOOK.",
        ".KOOOOOOOOOOOOK.",
        ".KOOKOOKKOOKOOK.",
        ".KOOEOOOOOOEOOK.",
        ".KOOWWWPPWWWOOK.",
        ".KODWWWKKWWWDOK.",
        "..KOOWWWWWWOOK..",
        "PPKOKOWWWWOKOKD.",
        "PPKOOWWWWWWOOKD.",
        "..KOKOWWWWOKOK..",
        "..KOOOOOOOOOOK..",
        "...KKK....KKK...",
        "................",
    ]

    // MARK: - 32x32 대형 초상화 (수작업 도트 — 16x16 확대본 아님)

    // 행복 — 이마의 임금 왕 자 줄무늬 + 눈 하이라이트 + 활짝 웃는 입 + 수염
    static let largeHappyRows = [
        "................................",
        ".....KKKK..............KKKK.....",
        "....KOOOOK............KOOOOK....",
        "...KODDDDOK..........KODDDDOK...",
        "...KODDDDOKKKKKKKKKKKKODDDDOK...",
        "..KOOOOOOOOOOOOOOOOOOOOOOOOOOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOKKOOOOOOOOOKKOOOOOOOOOKKOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOOOOOOOOOOOOKKOOOOOOOOOOOOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOOOOOOOOOOOOOOOOOOOOOOODDDK..",
        "..KOOOOOEWOOOOOOOOOOOOEWOOOOOK..",
        "..KKOOOOEEOOOOOOOOOOOOEEOOOOKK..",
        "..KOKOOOOOOOOOOOOOOOOOOOOOOKOK..",
        "..KOOOOOOOWWWWPPPPWWWWOOOOOOOK..",
        "K.KOOOOOOOWWWWWPPWWWWWOOOOOOOK.K",
        "..KOOOOOOOWKWWWWWWWWKWOOOOOOOK..",
        "K.KOOOOOOOWWKKKKKKKKWWOOOOOOOK.K",
        "..KOOOOOOOWWWWWWWWWWWWOOOOOOOK..",
        "..KOOOOOOOOWWWWWWWWWWOOOOODDDK..",
        "...KOOOOOOOOOOOOOOOOOOOOODDDK...",
        "....KOOOOOOOOOOOOOOOOOOODDDK....",
        "...KOOOOOOOWWWWWWWWWWOOOOOOOK...",
        "...KOKKOOOOWWWWWWWWWWOOOOKKOK...",
        "...KOOOOOOOWWWWWWWWWWOOOOOOOK...",
        "...KOKKOOOOWWWWWWWWWWOOOOKKOK...",
        "...KOOOOOOOWWWWWWWWWWOOOODDDK...",
        "...KOODOOOOWWWWWWWWWWOOOOODDK...",
        "....KOOOOOOOOOOOOOOOOOOODDDK....",
        ".......KKKKK........KKKKK.......",
        "................................",
    ]

    // 슬픔 — 처진 귀 + 눈물 + 아래로 굽은 입
    static let largeSadRows = [
        "................................",
        "................................",
        "...KKKK..................KKKK...",
        "..KODDOK................KODDOK..",
        "..KODDDOKKKKKKKKKKKKKKKKODDDOK..",
        "..KOOOOOOOOOOOOOOOOOOOOOOOOOOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOKKOOOOOOOOOKKOOOOOOOOOKKOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOOOOOOOOOOOOKKOOOOOOOOOOOOK..",
        "..KOOOOOOOOOOKKKKKKOOOOOOOOOOK..",
        "..KOOOOOOOOOOOOOOOOOOOOOOODDDK..",
        "..KOOOOOEEOOOOOOOOOOOOEEOOOOOK..",
        "..KKOOOOEEOOOOOOOOOOOOEEOOOOKK..",
        "..KOKOOOOWOOOOOOOOOOOOWOOOOKOK..",
        "..KOOOOOOOWWWWPPPPWWWWOOOOOOOK..",
        "K.KOOOOOOOWWWWWPPWWWWWOOOOOOOK.K",
        "..KOOOOOOOWWKKKKKKKKWWOOOOOOOK..",
        "K.KOOOOOOOWKWWWWWWWWKWOOOOOOOK.K",
        "..KOOOOOOOWWWWWWWWWWWWOOOOOOOK..",
        "..KOOOOOOOOWWWWWWWWWWOOOOODDDK..",
        "...KOOOOOOOOOOOOOOOOOOOOODDDK...",
        "....KOOOOOOOOOOOOOOOOOOODDDK....",
        "...KOOOOOOOWWWWWWWWWWOOOOOOOK...",
        "...KOKKOOOOWWWWWWWWWWOOOOKKOK...",
        "...KOOOOOOOWWWWWWWWWWOOOOOOOK...",
        "...KOKKOOOOWWWWWWWWWWOOOOKKOK...",
        "...KOOOOOOOWWWWWWWWWWOOOODDDK...",
        "...KOODOOOOWWWWWWWWWWOOOOODDK...",
        "....KOOOOOOOOOOOOOOOOOOODDDK....",
        ".......KKKKK........KKKKK.......",
        "................................",
    ]

    // 위독 — 창백한 몸 (몸통 주황과 배 색을 맞바꿈), X 자 눈, 벌어진 입, 줄무늬 유지
    static let largeCriticalRows = [
        "................................",
        ".....KKKK..............KKKK.....",
        "....KWWWWK............KWWWWK....",
        "...KWDDDDWK..........KWDDDDWK...",
        "...KWDDDDWKKKKKKKKKKKKWDDDDWK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWWK..",
        "..KWWWWWWWWWWKKKKKKWWWWWWWWWWK..",
        "..KWKKWWWWWWWWWKKWWWWWWWWWKKWK..",
        "..KWWWWWWWWWWKKKKKKWWWWWWWWWWK..",
        "..KWWWWWWWWWWWWKKWWWWWWWWWWWWK..",
        "..KWWWWWWWWWWKKKKKKWWWWWWWWWWK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWDDDK..",
        "..KWWWWEWEWWWWWWWWWWWWEWEWWWWK..",
        "..KWWWWWEWWWWWWWWWWWWWWEWWWWWK..",
        "..KWWWWEWEWWWWWWWWWWWWEWEWWWWK..",
        "..KWWWWWWWOOOOPPPPOOOOWWWWWWWK..",
        "K.KWWWWWWWOOOOOPPOOOOOWWWWWWWK.K",
        "..KWWWWWWWOOOOKKKKOOOOWWWWWWWK..",
        "K.KWWWWWWWOOOOKKKKOOOOWWWWWWWK.K",
        "..KWWWWWWWOOOOOOOOOOOOWWWWWWWK..",
        "..KWWWWWWWWOOOOOOOOOOWWWWWDDDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWDDDK...",
        "....KWWWWWWWWWWWWWWWWWWWDDDK....",
        "...KWWWWWWWOOOOOOOOOOWWWWWWWK...",
        "...KWKKWWWWOOOOOOOOOOWWWWKKWK...",
        "...KWWWWWWWOOOOOOOOOOWWWWWWWK...",
        "...KWKKWWWWOOOOOOOOOOWWWWKKWK...",
        "...KWWWWWWWOOOOOOOOOOWWWWDDDK...",
        "...KWWDWWWWOOOOOOOOOOWWWWWDDK...",
        "....KWWWWWWWWWWWWWWWWWWWDDDK....",
        ".......KKKKK........KKKKK.......",
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
