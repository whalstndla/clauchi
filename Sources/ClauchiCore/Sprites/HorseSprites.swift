import Foundation

// 성체 말 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8) — 말랑이
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 브라운 외곽선 + 파스텔 밤색 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 이마 중앙에서 머리 위→옆으로 흐르는 다크브라운 갈기(R)와 살짝 긴
// 크림 주둥이(W + 콧구멍 N 2개), 쫑긋 선 두 귀가 어떤 상태에서도 조랑말임을
// 보장한다 (잠·위독은 처진 귀 예외). 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum HorseSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x91603AFF,   // K — 외곽선 (브라운)
        "\u{47}": 0xD8A06AFF,   // G — 밤색 몸통
        "\u{44}": 0xBE8450FF,   // D — 음영·귀 안쪽
        "\u{52}": 0x8A5A38FF,   // R — 갈기 (다크브라운)
        "\u{57}": 0xF0DFC8FF,   // W — 크림 주둥이·배
        "\u{4E}": 0x7A4E30FF,   // N — 콧구멍
        "\u{42}": 0xF4C0AAFF,   // B — 볼터치
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 쫑긋 선 두 귀(안쪽 D) + 이마 앞갈기(R 2~3px, 오른쪽으로 흐름)
    // + 큰 눈(좌상단 H) + 크림 주둥이(콧구멍 N 2개) + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        "....K......K....",
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        "...KGDKRRKDGK.H.",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        ".KGDK......KDGK.",
        "..KKKKKKKKKKKK..",
        "..KGGGRRRGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        ".KGDK......KDGK.",
        "..KKKKKKKKKKKK..",
        "..KGGGRRRGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 주둥이 아래 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "....K......K....",
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
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
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
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
        ".KWDK......KDWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWRRRWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWGGNGNGGGDK..",
        "..KWWWWWWWWWDK..",
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
        ".KWDK......KDWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWRRRWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWGGNGNGGGDK..",
        "..KWWWWWWWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "....K......K....",
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDK..",
        "..KGGGGGGGGGDK..",
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
        "...KGDKRRKDGK...",
        "...KGGKRRKGGK...",
        "..KGGGGRRRGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGWWWWWGBDK..",
        "..KGWWNWNWWWDKNN",
        "..KGGGGGGGGGDKNN",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 32x32 초상 — 행복: 쫑긋 선 두 귀(안쪽 음영 D) + 두피를 덮는 갈기 밴드(R)
    // — 이마 중앙 앞갈기가 눈 사이로 살짝 내려오고 오른쪽 옆머리로 흘러내림 —
    // + 살짝 긴 크림 주둥이(콧구멍 N 1×2 두 개) + 웃는 입(∪) + 볼터치 + 배 W
    static let largeHappyRows = [
        "................................",
        "................................",
        ".......K................K.......",
        "......KGK..............KGK......",
        "......KGDK............KGDK......",
        ".....KGGDK............KGGDK.....",
        ".....KGGDK............KGGDK.....",
        ".....KGGDK............KGGDK.....",
        ".....KGGDKKKKKKKKKKKKKKGGDK.....",
        "....KRRRRRRRRRRRRRRRRRRRRRRK....",
        "...KRRRRRRRRRRRRRRRRRRRRRRRRK...",
        "..KGGGGGGGGGGGRRRRGGGGGGGRRRDK..",
        "..KGGGGGGGGGGGGRRGGGGGGGGGRRDK..",
        ".KGGGGGGGGGGGGGRGGGGGGGGGGGRGDK.",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGGGGGGWWWWWWGGGGGGGBBGDK.",
        ".KGGBBGGGGGGWWWWWWWWGGGGGGBBGDK.",
        ".KGGGGGGGGGGWNWWWWNWGGGGGGGGGDK.",
        ".KGGGGGGGGGGWNWWWWNWGGGGGGGGGDK.",
        ".KGGGGGGGGGGWWMWWMWWGGGGGGGGGDK.",
        ".KGGGGGGGGGGGWWMMWWGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 상단이 비고 귀가 좌우 바깥으로 늘어짐(안쪽 D 줄무늬)
    // + 갈기 밴드 R 유지 + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H)
    // + 입 ∩ 곡선 + 볼터치 유지
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
        ".KGDKKKKKKKKKKKKKKKKKKKKKKKKDGK.",
        "KGDKKRRRRRRRRRRRRRRRRRRRRRRKKDGK",
        "KDKKRRRRRRRRRRRRRRRRRRRRRRRRKKDK",
        "KKKGGGGGGGGGGGRRRRGGGGGGGRRRDKKK",
        "..KGGGGGGMMGGGGRRGGGGMMGGGRRDK..",
        ".KGGGGGMMGGGGGGRGGGGGGGMMGGRGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGHGGGGWWWWWWGGGGGGGBBGDK.",
        ".KGGBBGGGGGGWWWWWWWWGGGGGGBBGDK.",
        ".KGGGGGGGGGGWNWWWWNWGGGGGGGGGDK.",
        ".KGGGGGGGGGGWNWWWWNWGGGGGGGGGDK.",
        ".KGGGGGGGGGGGWWMMWWGGGGGGGGGGDK.",
        ".KGGGGGGGGGGWWMWWMWWGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 귀 완전 처짐
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 볼터치 제거 (갈기 R은 유지)
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
        ".KWDKKKKKKKKKKKKKKKKKKKKKKKKDWK.",
        "KWDKKRRRRRRRRRRRRRRRRRRRRRRKKDWK",
        "KDKKRRRRRRRRRRRRRRRRRRRRRRRRKKDK",
        "KKKWWWWWWWWWWWRRRRWWWWWWWRRRDKKK",
        "..KWWWWWWWWWWWWRRWWWWWWWWWRRDK..",
        ".KWWWWWWWWWWWWWRWWWWWWWWWWWRWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWGGGGGGWWWWWWWWWWDK.",
        ".KWWWWWWWWWWGNGGGGNGWWWWWWWWWDK.",
        ".KWWWWWWWWWWWGGMMGGWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
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
