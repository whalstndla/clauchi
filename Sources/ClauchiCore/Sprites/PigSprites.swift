import Foundation

// 성체 돼지 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 로즈브라운 외곽선 + 파스텔 연핑크 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 얼굴 중앙의 큰 들창코 타원(S 코판 + N 콧구멍 2개)과 머리 위 쫑긋
// 삼각 귀(안쪽 N)가 어떤 상태에서도 돼지임을 보장한다 (잠·위독은 처진 귀 예외).
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum PigSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xC97F8FFF,   // K — 외곽선 (로즈브라운)
        "\u{47}": 0xF8C8CEFF,   // G — 연핑크 몸통
        "\u{44}": 0xEBA8B2FF,   // D — 음영
        "\u{53}": 0xF2A0B0FF,   // S — 코판 (진핑크 타원)
        "\u{4E}": 0xE76E8AFF,   // N — 콧구멍·귀 안쪽
        "\u{42}": 0xFBD9DEFF,   // B — 볼터치
        "\u{57}": 0xFFF1F2FF,   // W — 배
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 쫑긋 삼각 귀(안쪽 N) + 큰 눈(좌상단 H) + 들창코(S 코판 + 콧구멍 N 2px) + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 깜빡임 — 눈을 몸색 G로 감춰 깜빡이는 대비를 만든다
    static let idle2Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 땀방울 H
    static let working1Rows = [
        "....K......K..H.",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK.H.",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 귀 옆으로 축 처짐 + 눈 감음(가로 E 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "................",
        ".............W..",
        "................",
        ".KK..........KK.",
        ".KGNK......KNGK.",
        "..KKKKKKKKKKKK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KGNK......KNGK.",
        "..KKKKKKKKKKKK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 코 아래 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 귀 완전 처짐 + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KWNK......KNWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWSSSSSSWDK..",
        "..KWWSNSSNSWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KWNK......KNWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWSSSSSSWDK..",
        "..KWWSNSSNSWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK.NN",
        "....KKKKKKKK..NN",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "....K......K....",
        "...KGNK..KNGK...",
        "...KGGKKKKGGK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGSSSSSSGDK..",
        "..KBGSNSSNSBDKNN",
        "..KGWWWWWWWWDKNN",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 32x32 초상 — 행복: 쫑긋 삼각 귀 + 큰 들창코(콧구멍 N 1×2 두 개) + 웃는 입
    // + 우측 꼬불 꼬리 1줄 (몸통 우하단 K 갈고리)
    static let largeHappyRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        ".......K................K.......",
        "......KNK..............KNK......",
        ".....KNNNK............KNNNK.....",
        ".....KNNNK............KNNNK.....",
        "....KGNNNGK..........KGNNNGK....",
        "....KKGGGGKKKKKKKKKKKKGGGGKK....",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGGGGGGSSSSSSGGGGGGGBBGDK.",
        ".KGGBBGGGGGGSSNSSNSSGGGGGGBBGDK.",
        ".KGGGGGGGGGGSSNSSNSSGGGGGGGGGDK.",
        ".KGGGGGGGGGGSSSSSSSSGGGGGGGGGDK.",
        ".KGGGGGGGGGGGSSSSSSGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGMGGMGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGMMGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK..K...",
        "......KGGGWWWWWWWWWWWWGGDKKK....",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 상단이 비고 귀가 좌우 바깥으로 늘어짐(안쪽 N 줄무늬)
    // + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        ".KKKK......................KKKK.",
        ".KGNKKKKKKKKKKKKKKKKKKKKKKKKNGK.",
        "KGNKKGGGGGGGGGGGGGGGGGGGGGGKKNGK",
        "KNKKGGGGGGGGGGGGGGGGGGGGGGGGKKNK",
        "KKKGGGGGGGGGGGGGGGGGGGGGGGGGDKKK",
        "..KGGGGGGMMGGGGGGGGGGMMGGGGGDK..",
        ".KGGGGGMMGGGGGGGGGGGGGGMMGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGHGGGGSSSSSSGGGGGGGBBGDK.",
        ".KGGBBGGGGGGSSNSSNSSGGGGGGBBGDK.",
        ".KGGGGGGGGGGSSNSSNSSGGGGGGGGGDK.",
        ".KGGGGGGGGGGSSSSSSSSGGGGGGGGGDK.",
        ".KGGGGGGGGGGGSSSSSSGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGMMGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGMGGMGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK..K...",
        "......KGGGWWWWWWWWWWWWGGDKKK....",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 귀 완전 처짐
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 볼터치·꼬리 제거
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
        ".KKKK......................KKKK.",
        ".KWNKKKKKKKKKKKKKKKKKKKKKKKKNWK.",
        "KWNKKWWWWWWWWWWWWWWWWWWWWWWKKNWK",
        "KNKKWWWWWWWWWWWWWWWWWWWWWWWWKKNK",
        "KKKWWWWWWWWWWWWWWWWWWWWWWWWWDKKK",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWSSSSSSWWWWWWWWWWDK.",
        ".KWWWWWWWWWWSSNSSNSSWWWWWWWWWDK.",
        ".KWWWWWWWWWWWSSSSSSWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWMMWWWWWWWWWWWWDK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWWGGGGGGGGGGWWWDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
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
