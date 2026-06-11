import Foundation

// 성체 소 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 브라운 외곽선 + 웜 탄 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 머리 양옆 위로 솟은 크림 뿔 2개(C)와 얼굴 하단을 넓게 덮는
// 분홍 콧잔등(S 타원 + N 콧구멍 2개)이 어떤 상태에서도 소임을 보장한다.
// 뿔 바깥 아래에는 작은 둥근 귀 — 듬직하고 순한 송아지 인상.
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum OxSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xA87B4FFF,   // K — 외곽선 (웜 브라운)
        "\u{47}": 0xE8C49CFF,   // G — 웜 탄 몸통
        "\u{44}": 0xD3A878FF,   // D — 음영
        "\u{43}": 0xF3E8D8FF,   // C — 뿔 (크림)
        "\u{53}": 0xF4B8C2FF,   // S — 콧잔등 (핑크 타원)
        "\u{4E}": 0xE07A93FF,   // N — 콧구멍·공
        "\u{42}": 0xF6C9BCFF,   // B — 볼터치
        "\u{57}": 0xFAF1E3FF,   // W — 배·z 표시
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 상태별 프레임

    // 기본 포즈 — 크림 뿔 2개 + 귀(뿔 바깥 G) + 큰 눈(좌상단 H) + 넓은 콧잔등(S 8px + 콧구멍 N) + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        "...KCK....KCK.H.",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        "...KCK....KCK...",
        "..KCCK....KCCK.H",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 눈 감음(가로 E 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "..............W.",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        ".............W..",
        "................",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 콧잔등 아래 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KWCCKKKKKKCCWK.",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWSSSSSSSSDK..",
        "..KWSNSSSSNSWK..",
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
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KWCCKKKKKKCCWK.",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWSSSSSSSSDK..",
        "..KWSNSSSSNSWK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBK..",
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
        "...KCK....KCK...",
        "..KCCK....KCCK..",
        ".KGCCKKKKKKCCGK.",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGSSSSSSSSDK..",
        "..KBSNSSSSNSBKNN",
        "..KGWWWWWWWWDKNN",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // MARK: - 32×32 표정 초상화 (수작업 — 16×16 확대본 아님)

    // 32x32 초상 — 행복: 위·바깥으로 뻗은 크림 뿔 + 작은 둥근 귀 + 큰 눈(HEE)
    // + 얼굴 하단 1/3을 덮는 넓은 콧잔등(S 12×6 타원 + 콧구멍 N 2×2) + 웃는 입 ∪
    static let happyLargeRows = [
        "................................",
        "................................",
        "...KKKK..................KKKK...",
        "...KCCK..................KCCK...",
        "...KCCCK................KCCCK...",
        "....KCCCK..............KCCCK....",
        ".....KCCCK............KCCCK.....",
        "......KCCCK..........KCCCK......",
        ".......KCCCK........KCCCK.......",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        ".KGGKGGGGGGGGGGGGGGGGGGGGGGKGGK.",
        ".KGKGGGGGGGGGGGGGGGGGGGGGGGGKGK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGGGGGGGGGGGGGGGGGGGBBGDK.",
        ".KGGBBGGGGGSSSSSSSSSSGGGGGBBGDK.",
        ".KGGGGGGGGSSSSSSSSSSSSGGGGGGGDK.",
        ".KGGGGGGGGSSNNSSSSNNSSGGGGGGGDK.",
        ".KGGGGGGGGSSNNSSSSNNSSGGGGGGGDK.",
        ".KGGGGGGGGSSSSMSSMSSSSGGGGGGGDK.",
        "..KGGGGGGGGSSSSMMSSSSGGGGGGGGDK.",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 뿔 끝이 1단 뭉툭해지고 귀가 좌우 아래로 늘어짐
    // + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지
    static let sadLargeRows = [
        "................................",
        "................................",
        "................................",
        "....KKK.................KKK.....",
        "...KCCCK................KCCCK...",
        "....KCCCK..............KCCCK....",
        ".....KCCCK............KCCCK.....",
        "......KCCCK..........KCCCK......",
        ".......KCCCK........KCCCK.......",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        ".KK.KGGGGGGGGGGGGGGGGGGGGGGK.KK.",
        "KGGKGGGGGGGGGGGGGGGGGGGGGGGGKGGK",
        ".KKGGGGGGGGGGGGGGGGGGGGGGGGGGDKK",
        "..KGGGGGGMMGGGGGGGGGGMMGGGGGDK..",
        ".KGGGGGMMGGGGGGGGGGGGGGMMGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGHGGGGGGGGGGGGGGGGGBBGDK.",
        ".KGGBBGGGGGSSSSSSSSSSGGGGGBBGDK.",
        ".KGGGGGGGGSSSSSSSSSSSSGGGGGGGDK.",
        ".KGGGGGGGGSSNNSSSSNNSSGGGGGGGDK.",
        ".KGGGGGGGGSSNNSSSSNNSSGGGGGGGDK.",
        ".KGGGGGGGGSSSSSMMSSSSSGGGGGGGDK.",
        "..KGGGGGGGGSSSMSSMSSSGGGGGGGGDK.",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 귀 완전 처짐
    // + 전체 2px 아래로 주저앉음(상단 추가로 비움 + 머리 1행 압축) + 볼터치 제거
    static let criticalLargeRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "....KKK.................KKK.....",
        "...KCCCK................KCCCK...",
        "....KCCCK..............KCCCK....",
        ".....KCCCK............KCCCK.....",
        "......KCCCK..........KCCCK......",
        ".......KCCCK........KCCCK.......",
        "..KKKKKKKKKKKKKKKKKKKKKKKKKKKK..",
        ".KK.KWWWWWWWWWWWWWWWWWWWWWWK.KK.",
        "KWWKWWWWWWWWWWWWWWWWWWWWWWWWKWWK",
        ".KKWWWWWWWWWWWWWWWWWWWWWWWWWWDKK",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWSSSSSSSSSSWWWWWWWWDK.",
        ".KWWWWWWWWSSNNSSSSNNSSWWWWWWWDK.",
        ".KWWWWWWWWSSNNSSSSNNSSWWWWWWWDK.",
        ".KWWWWWWWWSSSSSMMSSSSSWWWWWWWDK.",
        "..KWWWWWWWWSSSSSSSSSSWWWWWWWWDK.",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWWGGGGGGGGGGWWWDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
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
