import Foundation

// 성체 멍멍이(개) 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 브라운 외곽선 + 밝은 골든 몸통(골든리트리버 강아지).
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 머리 양옆에서 아래로 늘어진 진한 브라운 귀(R)가 어떤 상태에서도 개임을 보장하고,
// happy/playing의 분홍 혀(P)와 또렷한 다크 코(N)가 시그니처.
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum DogSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xA97B3FFF,   // K — 외곽선 (웜 브라운)
        "\u{47}": 0xEFC07EFF,   // G — 골든 몸통
        "\u{44}": 0xD9A35CFF,   // D — 음영
        "\u{52}": 0xB07C46FF,   // R — 늘어진 귀 (진한 브라운)
        "\u{50}": 0xF58FABFF,   // P — 혀 (핑크)
        "\u{42}": 0xF7C4B0FF,   // B — 볼터치
        "\u{57}": 0xFFF6E6FF,   // W — 배·주둥이
        "\u{4E}": 0x6B4A2FFF,   // N — 코 (다크브라운)
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 양옆으로 늘어진 귀(R) + 큰 눈(좌상단 H) + 볼터치 + 다크 코 + 배 W
    static let idle1Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
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
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGGGGGGGGKRRK",
        "KRRKGGGGGGGDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
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
        "....KKKKKKKK..H.",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울이 한 칸 아래로 떨어짐
    static let working2Rows = [
        "................",
        "....KKKKKKKK..H.",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 늘어진 귀 그대로 + 눈 감음(가로 EE 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "................",
        "....KKKKKKKK..W.",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGGGGGGGGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
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
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGGGGGGGGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWWWWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 주둥이에 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWMMWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 오른눈 아래 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGGGGGGGGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGHDKRRK",
        ".KKKGWWMMWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 볼터치 제거 + 흐릿한 눈(H 없는 EE 블록)
    static let critical1Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKWWWWWWWWKKK.",
        "KRRKWWWWWWWWKRRK",
        "KRRKWEEWWEEWKRRK",
        "KRRKWEEWWEEDKRRK",
        "KRRKWWWNNWWDKRRK",
        ".KKKWGGGGGGDKKK.",
        "..KWWWWWWWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
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
        "....KKKKKKKK....",
        ".KKKWWWWWWWWKKK.",
        "KRRKWWWWWWWWKRRK",
        "KRRKWEEWWEEWKRRK",
        "KRRKWEEWWEEDKRRK",
        "KRRKWWWNNWWDKRRK",
        ".KKKWGGGGGGDKKK.",
        "..KWWWWWWWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 내민 혀(P 2px) + 발치의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWPPWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK.NN",
        "....KKKKKKKK..NN",
        "................",
    ]

    // 휴일 놀기 — 혀는 그대로, 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "....KKKKKKKK....",
        ".KKKGGGGGGGGKKK.",
        "KRRKGGGGGGGGKRRK",
        "KRRKGHEGGHEGKRRK",
        "KRRKGEEGGEEDKRRK",
        "KRRKBGGNNGBDKRRK",
        ".KKKGWWPPWWDKKK.",
        "..KGGGGGGGGGDK..",
        "..KGWWWWWWWWDKNN",
        "..KGWWWWWWWWDKNN",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 32x32 초상 — 행복: 둥근 머리 + 양옆 늘어진 귀(R) + HEE/EEE/EEE 눈 + 볼터치 2×2
    // + 다크 코 2×2 + ∪ 미소 아래로 내민 분홍 혀(P 2×2)
    static let largeHappyRows = [
        "................................",
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKGGGGGGGGGGGGKK........",
        ".......KGGGGGGGGGGGGGGGGK.......",
        "......KGGGGGGGGGGGGGGGGGGK......",
        "..KKKKKGGGGGGGGGGGGGGGGGGKKKKK..",
        "..KRRRKGGGGGGGGGGGGGGGGGGKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGHEEGGGGGGGGHEEGDKRRRK..",
        "..KRRRKGGEEEGGGGGGGGEEEGDKRRRK..",
        "..KRRRKGGEEEGGGGGGGGEEEGDKRRRK..",
        "..KRRRKGGGGGGGGNNGGGGGGGDKRRRK..",
        "..KRRRKGBBGGGGGNNGGGGGBBDKRRRK..",
        "..KRRRKGBBGGGGGGGGGGGGBBDKRRRK..",
        "...KRRKGGGGGGMGGGGMGGGGGDKRRK...",
        "....KKKGGGGGGGMMMMGGGGGGDKKK....",
        "......KGGGGGGGGPPGGGGGGGDK......",
        "......KGGGGGGGGPPGGGGGGGDK......",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 귀가 2행 더 길게 처짐 + 안쪽으로 올라간 눈썹(M)
    // + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지, 혀 없음
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKGGGGGGGGGGGGKK........",
        ".......KGGGGGGGGGGGGGGGGK.......",
        "......KGGGGGGGGGGGGGGGGGGK......",
        "..KKKKKGGGGGGGGGGGGGGGGGGKKKKK..",
        "..KRRRKGGGGGGGGGGGGGGGGGGKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGGGGGGGGGGGGGGGGDKRRRK..",
        "..KRRRKGGGGMMGGGGGGMMGGGDKRRRK..",
        "..KRRRKGGMMGGGGGGGGGGMMGDKRRRK..",
        "..KRRRKGGHEEGGGGGGGGHEEGDKRRRK..",
        "..KRRRKGGEEEGGGGGGGGEEEGDKRRRK..",
        "..KRRRKGGEEEGGGGGGGGEEEGDKRRRK..",
        "..KRRRKGGHGGGGGNNGGGGGGGDKRRRK..",
        "..KRRRKGBBGGGGGNNGGGGGBBDKRRRK..",
        "..KRRRKGBBGGGGGGGGGGGGBBDKRRRK..",
        "..KRRRKGGGGGGGGMMGGGGGGGDKRRRK..",
        "..KRRRKGGGGGGGMGGMGGGGGGDKRRRK..",
        "...KRRKGGGGGGGGGGGGGGGGGDKRRK...",
        "....KKKGGGGGGGGGGGGGGGGGDKKK....",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGGGGGGGGGGGGGGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 볼터치 제거
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 입 ∩ 곡선
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKWWWWWWWWWWWWKK........",
        ".......KWWWWWWWWWWWWWWWWK.......",
        "......KWWWWWWWWWWWWWWWWWWK......",
        "..KKKKKWWWWWWWWWWWWWWWWWWKKKKK..",
        "..KRRRKWWWWWWWWWWWWWWWWWWKRRRK..",
        "..KRRRKWWWWWWWWWWWWWWWWWDKRRRK..",
        "..KRRRKWWWWWWWWWWWWWWWWWDKRRRK..",
        "..KRRRKWWWWWWWWWWWWWWWWWDKRRRK..",
        "..KRRRKWWWWWWWWWWWWWWWWWDKRRRK..",
        "..KRRRKWWEWEWWWWWWWWEWEWDKRRRK..",
        "..KRRRKWWWEWWWWWWWWWEWWWDKRRRK..",
        "..KRRRKWWEWEWWWWWWWWEWEWDKRRRK..",
        "..KRRRKWWWWWWWWNNWWWWWWWDKRRRK..",
        "..KRRRKWWWWWWWWNNWWWWWWWDKRRRK..",
        "...KRRKWWWWWWWWWWWWWWWWWDKRRK...",
        "....KKKWWWWWWWWMMWWWWWWWDKKK....",
        "......KWWWWWWWMWWMWWWWWWDK......",
        "......KWWWWWWWWWWWWWWWWWDK......",
        "......KWWWWWWWWWWWWWWWWWDK......",
        "......KWWWWWWWWWWWWWWWWWDK......",
        "......KWWWGGGGGGGGGGGGWWDK......",
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
