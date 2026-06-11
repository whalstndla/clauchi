import Foundation

// 성체 원숭이 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 진한 웜 브라운 외곽선 + 따뜻한 갈색 몸통.
// 시그니처: 얼굴 중앙의 하트형 크림 패널 F(이마 가운데가 살짝 파인 하트 윤곽,
// 눈·코·입은 패널 안에 자리한다) + 머리 양옆 둥근 귀(안쪽 크림 F) +
// 옆으로 말려 올라간 꼬리. 이 세 요소가 어떤 상태에서도 원숭이임을 보장한다
// (잠·위독은 처진 귀 예외). 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum MonkeySprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    // 검증 스크립트가 따옴표 안 대문자 문자열을 프레임 행으로 집계하므로 충돌을 피한다.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x7F5433FF,   // K — 외곽선 (진한 웜 브라운)
        "\u{47}": 0xC98E5FFF,   // G — 갈색 몸통
        "\u{44}": 0xAD7347FF,   // D — 음영 (우측·하단)
        "\u{46}": 0xF4E3C8FF,   // F — 얼굴·귀 안쪽 (크림)
        "\u{42}": 0xF2B8A0FF,   // B — 볼터치
        "\u{57}": 0xF8EDD9FF,   // W — 배
        "\u{4D}": 0x6E4526FF,   // M — 코·입
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 하이라이트
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 양옆 둥근 귀(안쪽 F) + 하트형 크림 패널 F(이마 V 파임) +
    // 큰 눈 2px(+H) + 코·입 M + 볼터치 B + 옆으로 말린 꼬리(우측 1줄)
    static let idle1Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFHEFEHFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 깜빡임 — 눈을 몸색 F로 감춰 깜빡이는 대비를 만든다
    static let idle2Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFFFFFFFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 우상단 땀방울 H
    static let working1Rows = [
        "..KK......KK..H.",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFHEFEHFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 낙하(위치 이동)
    static let working2Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK.H.",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFHEFEHFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 잠 — 귀 옆으로 축 처짐 + 눈 감음(가로 E 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "................",
        ".............W..",
        "................",
        ".KK........KK...",
        ".KFGKKKKKKKGFK..",
        "..KGFFFFFFGK.KK.",
        "..KGFFFFFFFGKKGK",
        "..KGFEEFEEFGKGDK",
        "..KGFFFMFFFGKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "................",
        "................",
        ".KK........KK...",
        ".KFGKKKKKKKGFK..",
        "..KGFFFFFFGK.KK.",
        "..KGFFFFFFFGKKGK",
        "..KGFEEFEEFGKGDK",
        "..KGFFFMFFFGKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 벌린 입 (M 2px) + 눈 일반
    static let hungry1Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFFEFEFFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFFFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFMMFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFFFFFFFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFFFFGBKKKH",
        "..KGFFMMMFFGK...",
        "..KGGFMMFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 귀 완전 처짐 + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "................",
        "................",
        ".KK........KK...",
        ".KWFKKKKKKKFWK..",
        "..KWFFFFFFWK.KK.",
        "..KWFFEFEFWKKWK.",
        "..KWFFEFEFWKWDK.",
        "..KWWFFMFFWWKKK.",
        "..KWFFMMMFFWK...",
        "..KWWFFFFFWWK...",
        "...KWGGGGGWDK...",
        "...KWGGGGGWDK...",
        "...KDWGGGWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "................",
        "................",
        ".KK........KK...",
        ".KWFKKKKKKKFWK..",
        "..KWFFFFFFWK.KK.",
        "..KWFFEFEFWKKWK.",
        "..KWFFEFEFWKWDK.",
        "..KWWFFMFFWWKKK.",
        "..KWFFMMMFFWK...",
        "..KWWFFFFFWWK...",
        "...KWGGGGGWDK...",
        "...KWGGGGGWDK...",
        "...KDWGGGWWDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (M 2×2) 우측 아래
    static let playing1Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGK...",
        "..KGFFFFFFGK.KK.",
        "..KGFHEFEHFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDKMM.",
        "...KDGWWWGGDKMM.",
        "....KKKKKKKK....",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "..KK......KK....",
        ".KFGK....KGFK...",
        ".KFFGKKKKGFFK...",
        ".KGGKFGFGKGGKMM.",
        "..KGFFFFFFGKMM..",
        "..KGFHEFEHFGKKGK",
        "..KGFFEFEFFGKGDK",
        "..KBGFFMFFGBKKK.",
        "..KGFFMMMFFGK...",
        "..KGGFFFFFGGK...",
        "...KGWWWWWGDK...",
        "...KGWWWWWGDK...",
        "...KDGWWWGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // MARK: - 32×32 대형 초상화 (수작업 — 음영 D, 표정 차등)

    // 행복 — 양옆 큰 둥근 귀(안쪽 F) + 하트형 크림 패널(이마 V 파임) +
    // 뜬 눈(HEE) + 볼터치 + ∪ 미소 + 옆으로 말린 꼬리(우측) + 우측 D 음영
    static let largeHappyRows = [
        "................................",
        "....KKKK..............KKKK......",
        "...KFFGGK............KGGFFK.....",
        "..KFFFFGGK..........KGGFFFFK....",
        "..KFFFFFGGKKKKKKKKKKGGFFFFFK....",
        "..KGGGGGKFFFGFFFGFFFKGGGGGDK....",
        "...KKKGGFFFFFFFFFFFFFFGGKKDK....",
        ".....KGFFFFFFFFFFFFFFFFGDK......",
        "....KGFFFFFFFFFFFFFFFFFFGDK.....",
        "...KGFFFFHEEFFFFFFHEEFFFFGDK....",
        "..KGFFFFFEEEFFFFFFEEEFFFFFGDK...",
        "..KGFFFFFEEEFFFFFFEEEFFFFFGDK...",
        "..KGFBBFFFFFFFFFFFFFFFFBBFGDK...",
        "..KGFBBFFFFFFFMMFFFFFFFBBFGDK...",
        "..KGFFFFFFFFFMMMMFFFFFFFFGDK..KK",
        "...KGFFFFFFFFFMMMMFFFFFFGDK.KGGK",
        "...KGGFFFFFFMFFFFMMFFFFGGDK.KGDK",
        "....KGGFFFFFMMMMMMFFFFGGDDKKKDK.",
        ".....KGGFFFFFFFFFFFFFGGDDKDDDK..",
        "......KKGGGGGGGGGGGGGGKKDDDK....",
        "........KGWWWWWWWWWWGDK.........",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGGWWWWWWWWWWGGDK........",
        "........KGGWWWWWWWWGGDK.........",
        ".........KGGGGGGGGGGDK..........",
        "..........KGGWWWWGGDK...........",
        "...........KGWWWWGDK............",
        "...........KGGWWGGDK............",
        "............KKKKKKKK............",
        "................................",
    ]

    // 슬픔 — 상단이 비고 귀가 좌우 바깥으로 처짐(안쪽 F) + 안쪽으로 올라간
    // 눈썹(M) + 왼눈 아래 눈물 1px(H) + ∩ 입 곡선 + 처진 귀 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        ".KKKK......................KKKK.",
        "KFFGK......................KGFFK",
        "KFFGGKKKKKKKKKKKKKKKKKKKKKKGGFFK",
        "KGGGKFFFGFFFGFFFGFFFGFFFGFKGGGDK",
        ".KKKGGFFFFFFFFFFFFFFFFFFFFGGKKDK",
        "...KGFFFFFFFFFFFFFFFFFFFFFFGDK..",
        "...KGFFFFMMFFFFFFFFFFMMFFFFGDK..",
        "..KGFFFMMFFFFFFFFFFFFFFMMFFGDK..",
        "..KGFFFFHEEFFFFFFFFHEEFFFFFGDK..",
        "..KGFFFFFEEEFFFFFFFEEEFFFFFGDK..",
        "..KGFBBFFEEEFFFFFFFEEEFFBBFGDK..",
        "..KGFBBFFHFFFFFFFFFFFFFFBBFGDK..",
        "..KGFFFFFFFFFFMMMMFFFFFFFFGDK...",
        "...KGFFFFFFFMMFFFFMMFFFFFGDK....",
        "...KGFFFFFFMFFFFFFFFMFFFFGDK....",
        "....KGGFFFFFFFFFFFFFFFFGGDK.....",
        ".....KKGGGGGGGGGGGGGGGGKKDK.....",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGWWWWWWWWWWWWGDK........",
        ".......KGGWWWWWWWWWWGGDK........",
        "........KGGWWWWWWWWGGDK.........",
        ".........KGGGGGGGGGGDK..........",
        "..........KGGWWWWGGDK...........",
        "...........KGWWWWGDK............",
        "...........KGGWWGGDK............",
        "............KKKKKKKK............",
        "................................",
    ]

    // 위독 — 몸 G↔W 반전(창백) + X자 눈(E 대각) + 귀 완전 처짐 + 볼터치 제거
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움)
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        ".KKKK......................KKKK.",
        "KWWFK......................KFWWK",
        "KWWFFKKKKKKKKKKKKKKKKKKKKKKFFWWK",
        "KFFFKWWWFWWWFWWWFWWWFWWWFWKFFFDK",
        ".KKKFFWWWWWWWWWWWWWWWWWWWWFFKKDK",
        "...KFWWWWWWWWWWWWWWWWWWWWWWFDK..",
        "...KFWWWWWWWWWWWWWWWWWWWWWWFDK..",
        "..KFWWWWWWWWWWWWWWWWWWWWWWWWFDK.",
        "..KFWWWEWWEWWWWWWWWWEWWEWWWWFDK.",
        "..KFWWWWEWWWWWWWWWWWWWEWWWWWFDK.",
        "..KFWWWEWWEWWWWWWWWWEWWEWWWWFDK.",
        "..KFWWWWWWWWWWWWWWWWWWWWWWWWFDK.",
        "..KFWWWWWWWWWWWMMWWWWWWWWWWWFDK.",
        "...KFWWWWWWWWWMMMMWWWWWWWWWFDK..",
        "...KFWWWWWWWWWMMMMWWWWWWWWWFDK..",
        "....KFFWWWWWWWWWWWWWWWWWWFFDK...",
        ".....KKFFWWWWWWWWWWWWWWFFKKDK...",
        ".......KFGGGGGGGGGGGGFDK........",
        ".......KFGGGGGGGGGGGGFDK........",
        ".......KFGGGGGGGGGGGGFDK........",
        ".......KFFGGGGGGGGGGFFDK........",
        "........KFFGGGGGGGGFFDK.........",
        ".........KFFFFFFFFFFDK..........",
        "..........KFFGGGGFFDK...........",
        "...........KFGGGGFDK............",
        "...........KFFGGFFDK............",
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
