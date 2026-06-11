import Foundation

// 성체 양 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8) — 양순이 (.goat)
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 그레이 외곽선 + 울 화이트 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 머리 둘레의 뭉게뭉게 울 테두리(매끈한 원이 아닌 1px 요철 스캘럽 반복)와
// 울 사이로 보이는 탄 크림 얼굴(F), 옆으로 늘어진 작은 귀(안쪽 P),
// 작게 말린 뿔(C)이 어떤 상태에서도 양임을 보장한다. 포근한 구름 느낌.
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum GoatSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xB3AB9CFF,   // K — 외곽선 (웜 그레이)
        "\u{47}": 0xF4F1EAFF,   // G — 울 화이트 몸통
        "\u{44}": 0xDED8CCFF,   // D — 음영
        "\u{46}": 0xEAD7BCFF,   // F — 탄 크림 얼굴
        "\u{43}": 0xC9A36EFF,   // C — 뿔 (말린 곡선)
        "\u{50}": 0xF6BACBFF,   // P — 귀 안쪽
        "\u{42}": 0xF7CBD4FF,   // B — 볼터치
        "\u{57}": 0xFFFDF7FF,   // W — 배
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 울 스캘럽 머리(요철 외곽) + 말린 뿔 C + 옆으로 늘어진 귀(안쪽 P)
    // + 울 사이 탄 크림 얼굴 F + 큰 눈(좌상단 H) + 볼터치 + 배 W
    static let idle1Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 깜빡임 — 눈을 얼굴색 F로 감춰 깜빡이는 대비를 만든다
    static let idle2Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFFFFFFFFGKPK",
        "..KGFFFFFFFFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 일하는 중 — 공중 자세(기본 높이 유지) + 땀방울 H 우상단
    static let working1Rows = [
        "....KK.KK.KK..H.",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 일하는 중 — 1px 착지(전체 1행 아래) + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "....KK.KK.KK....",
        "..CKGGKGGKGGKCH.",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
    ]

    // 잠 — 눈 감음(가로 E 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKCW.",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFFFFFFFFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "...............W",
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFFFFFFFFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
    ]

    // 배고픔 — 벌린 입 (M 2px)
    static let hungry1Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFMMFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFFFFFFFFGKPK",
        "..KGFEEFFEEFGKH.",
        "..KGBFFMMFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 위독 — 창백 반전(울 G→D 잿빛, 배 W→G) + 감은 눈 + 볼터치 제거
    static let critical1Rows = [
        "....KK.KK.KK....",
        "..CKDDKDDKDDKC..",
        ".CCKDDDDDDDDKCC.",
        ".CKDDDDDDDDDDKC.",
        "KPKDDFFFFFFDDKPK",
        "KPKDFFFFFFFFDKPK",
        "..KDFEEFFEEFDK..",
        "..KDFFFFFFFFDK..",
        "..KDDFFFFFFDDK..",
        "..KDDDDDDDDDGK..",
        ".KDGGGGGGGGDGK..",
        "..KDGGGGGGGGGK..",
        ".KDGGGGGGGGDGK..",
        "..KDGGGGGGGGGK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "....KK.KK.KK....",
        "..CKDDKDDKDDKC..",
        ".CCKDDDDDDDDKCC.",
        ".CKDDDDDDDDDDKC.",
        "KPKDDFFFFFFDDKPK",
        "KPKDFFFFFFFFDKPK",
        "..KDFEEFFEEFDK..",
        "..KDFFFFFFFFDK..",
        "..KDDFFFFFFDDK..",
        "..KDDDDDDDDDGK..",
        ".KDGGGGGGGGDGK..",
        "..KDGGGGGGGGGK..",
        ".KDGGGGGGGGDGK..",
        "..KDGGGGGGGGGK..",
        "...KKKKKKKKKK...",
    ]

    // 휴일 놀기 — 발치의 공 (P 2×2)
    static let playing1Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGK..",
        "..KGGGGGGGGGDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDKPP",
        "...KKKKKKKKKK.PP",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "....KK.KK.KK....",
        "..CKGGKGGKGGKC..",
        ".CCKGGGGGGGGKCC.",
        ".CKGGGGGGGGGGKC.",
        "KPKGGFFFFFFGGKPK",
        "KPKGFHEFFHEFGKPK",
        "..KGFEEFFEEFGK..",
        "..KGBFFFFFFBGK..",
        "..KGGFFFFFFGGKPP",
        "..KGGGGGGGGGDKPP",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        ".KGWWWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 32x32 초상 — 행복: 울 스캘럽 머리(상단 4봉우리 + 좌우 요철 외곽)
    // + 말린 뿔 C(고리 곡선) + 옆으로 뻗은 작은 귀(안쪽 P) + 탄 크림 얼굴 F
    // + 큰 눈(HEE/EEE/EEE) + 볼터치 2×2 + 웃는 입 ∪ + 배 W
    static let largeHappyRows = [
        "................................",
        "................................",
        ".......KKKK.KKKK.KKKK.KKKK......",
        ".....KKGGGGKGGGGKGGGGKGGGGKK....",
        "..CCKGGGGGGGGGGGGGGGGGGGGGDKCC..",
        ".CCKGGGGGGGGGGGGGGGGGGGGGGGDKCC.",
        ".CCKGGGGGGGGGGGGGGGGGGGGGGGDKCC.",
        "..CCKGGGGGGGGGGGGGGGGGGGGGDKCC..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "...KGGGGGGFFFFFFFFFFFFGGGGGDK...",
        "....KGGGGFFFFFFFFFFFFFFGGGDK....",
        "....KGGGFFFFFFFFFFFFFFFFGGDK....",
        ".KKKGGGGFFFFFFFFFFFFFFFFGGGDKKK.",
        "KPPKGGGGFFHEEFFFFFFHEEFFGGGDKPPK",
        ".KKKGGGGFFEEEFFFFFFEEEFFGGGDKKK.",
        "....KGGGFFEEEFFFFFFEEEFFGGDK....",
        "....KGGGBBFFFFFFFFFFFFBBGGDK....",
        "...KGGGGBBFFFMFFFFMFFFBBGGGDK...",
        "...KGGGGFFFFFFMMMMFFFFFFGGGDK...",
        "....KGGGGFFFFFFFFFFFFFFGGGDK....",
        ".....KGGGGGGGGGGGGGGGGGGGGDK....",
        "......KGGGGGGGGGGGGGGGGGGDK.....",
        ".....KGGGGGGGGGGGGGGGGGGGGDK....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        ".....KGGGGGWWWWWWWWWWGGGGDK.....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        ".....KGGGGGWWWWWWWWWWGGGGDK.....",
        "......KGGGGGGGGGGGGGGGGGGDK.....",
        ".......KKKKKKKKKKKKKKKKKKK......",
        "................................",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 귀가 옆이 아니라 아래로 축 늘어짐(안쪽 P 세로 띠)
    // + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        ".......KKKK.KKKK.KKKK.KKKK......",
        ".....KKGGGGKGGGGKGGGGKGGGGKK....",
        "..CCKGGGGGGGGGGGGGGGGGGGGGDKCC..",
        ".CCKGGGGGGGGGGGGGGGGGGGGGGGDKCC.",
        ".CCKGGGGGGGGGGGGGGGGGGGGGGGDKCC.",
        "..CCKGGGGGGGGGGGGGGGGGGGGGDKCC..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "...KGGGGGGFFFFFFFFFFFFGGGGGDK...",
        "....KGGGGFFFFFFFFFFFFFFGGGDK....",
        "....KGGGFFFFMMFFFFMMFFFFGGDK....",
        "...KGGGGFFMMFFFFFFFFMMFFGGGDK...",
        ".KKKGGGGFFHEEFFFFFFHEEFFGGGDKKK.",
        ".KPKGGGGFFEEEFFFFFFEEEFFGGGDKPK.",
        ".KPPKGGGFFEEEFFFFFFEEEFFGGDKPPK.",
        ".KPPKGGGBBHFFFFFFFFFFFBBGGDKPPK.",
        "..KKGGGGBBFFFFFMMFFFFFBBGGGDKK..",
        "...KGGGGFFFFFFMFFMFFFFFFGGGDK...",
        "....KGGGGFFFFFFFFFFFFFFGGGDK....",
        ".....KGGGGGGGGGGGGGGGGGGGGDK....",
        "......KGGGGGGGGGGGGGGGGGGDK.....",
        ".....KGGGGGGGGGGGGGGGGGGGGDK....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        ".....KGGGGGWWWWWWWWWWGGGGDK.....",
        "....KGGGGGGWWWWWWWWWWGGGGGDK....",
        ".....KGGGGGWWWWWWWWWWGGGGDK.....",
        "......KGGGGGGGGGGGGGGGGGGDK.....",
        ".......KKKKKKKKKKKKKKKKKKK......",
        "................................",
        "................................",
    ]

    // 32x32 초상 — 위독: 울 G→D 잿빛 반전(배 W→G) + X자 눈(E 3×3) + 귀 아래로 처짐
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 볼터치 제거 + 입 ∩
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        ".......KKKK.KKKK.KKKK.KKKK......",
        ".....KKDDDDKDDDDKDDDDKDDDDKK....",
        "..CCKDDDDDDDDDDDDDDDDDDDDDDKCC..",
        ".CCKDDDDDDDDDDDDDDDDDDDDDDDDKCC.",
        ".CCKDDDDDDDDDDDDDDDDDDDDDDDDKCC.",
        "..CCKDDDDDDDDDDDDDDDDDDDDDDKCC..",
        "...KDDDDDDDDDDDDDDDDDDDDDDDDK...",
        "...KDDDDDDFFFFFFFFFFFFDDDDDDK...",
        "....KDDDDFFFFFFFFFFFFFFDDDDK....",
        "....KDDDFFFFFFFFFFFFFFFFDDDK....",
        "...KDDDDFFFFFFFFFFFFFFFFDDDDK...",
        ".KKKDDDDFFEFEFFFFFFEFEFFDDDDKKK.",
        ".KPKDDDDFFFEFFFFFFFFEFFFDDDDKPK.",
        ".KPPKDDDFFEFEFFFFFFEFEFFDDDKPPK.",
        ".KPPKDDDFFFFFFFFFFFFFFFFDDDKPPK.",
        "..KKDDDDFFFFFFFMMFFFFFFFDDDDKK..",
        "...KDDDDFFFFFFMFFMFFFFFFDDDDK...",
        "....KDDDDFFFFFFFFFFFFFFDDDDK....",
        ".....KDDDDDDDDDDDDDDDDDDDDDK....",
        "......KDDDDDDDDDDDDDDDDDDDK.....",
        ".....KDDDDDDDDDDDDDDDDDDDDDK....",
        "....KDDDDDDGGGGGGGGGGDDDDDDK....",
        "....KDDDDDDGGGGGGGGGGDDDDDDK....",
        ".....KDDDDDGGGGGGGGGGDDDDDK.....",
        "....KDDDDDDGGGGGGGGGGDDDDDDK....",
        ".....KDDDDDGGGGGGGGGGDDDDDK.....",
        "......KDDDDDDDDDDDDDDDDDDDK.....",
        ".......KKKKKKKKKKKKKKKKKKK......",
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
