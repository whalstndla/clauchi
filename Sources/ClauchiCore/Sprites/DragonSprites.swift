import Foundation

// 성체 용 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 딥 그린 외곽선 + 파스텔 민트 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 머리 위 크림 뿔 2개(C)와 정수리에서 등으로 이어지는 크림 등돌기
// 삼각형들(C — 32×32에서 3개, 16×16에서 1개), 둥근 연민트 주둥이(W) +
// 작은 콧구멍 2개(N), 연민트 배 패널(W)이 어떤 상태에서도 아기 용임을 보장한다
// (잠·위독은 처진 뿔 예외, 날개 없음). 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum DragonSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x4A9468FF,   // K — 외곽선 (딥 그린)
        "\u{47}": 0x8FD9A8FF,   // G — 민트 몸통
        "\u{44}": 0x6CBE8BFF,   // D — 음영
        "\u{43}": 0xF3E8D8FF,   // C — 뿔·등돌기 (크림)
        "\u{57}": 0xDFF5E7FF,   // W — 배·주둥이 (연민트)
        "\u{42}": 0xF9B8C4FF,   // B — 볼터치
        "\u{4E}": 0x3F7D58FF,   // N — 콧구멍
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 크림 뿔 2개 + 정수리 등돌기 1개(C) + 큰 눈(좌상단 H) + 콧구멍 N 2개 + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
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
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
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
        "....K..KK..K..H.",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
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
        "....K..KK..K....",
        "...KCCKCCKCCK.H.",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
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
        ".............W..",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
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
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 콧구멍 아래 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDK..",
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
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KBGGNGGNGBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 1px 주저앉음 + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWNWWNWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 1px 더 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWNWWNWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (B 2×2)
    static let playing1Rows = [
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK.BB",
        "....KKKKKKKK..BB",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "....K..KK..K....",
        "...KCCKCCKCCK...",
        "...KKKKKKKKKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGNGGNGBDK..",
        "..KGGWWWWWWGDKBB",
        "..KGWWWWWWWWDKBB",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 32x32 초상 — 행복: 크림 뿔 2개 + 정수리 등돌기 3개(중앙 크게, 좌우 작게 크레스트)
    // + 둥근 연민트 주둥이(W) 위 콧구멍 N 1×2 두 개 + 웃는 입 + 볼터치 + 배 W 패널
    static let largeHappyRows = [
        "................................",
        "......KK................KK......",
        ".....KCCK..............KCCK.....",
        ".....KCCK......KK......KCCK.....",
        ".....KCCCK....KCCK....KCCCK.....",
        ".....KCCCK....KCCK....KCCCK.....",
        ".....KCCCK.KKKCCCCKKK.KCCCK.....",
        ".....KCCCKKCCKCCCCKCCKKCCCK.....",
        ".....KCCCKKCCKCCCCKCCKKCCCK.....",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGGGGGGWWWWWWGGGGGGGBBGDK.",
        ".KGGBBGGGGGGWWNWWNWWGGGGGGBBGDK.",
        ".KGGGGGGGGGGWWNWWNWWGGGGGGGGGDK.",
        ".KGGGGGGGGGGWWWWWWWWGGGGGGGGGDK.",
        ".KGGGGGGGGGGGWWWWWWGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGMGGMGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGMMGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 뿔이 바깥쪽으로 처지고(끝이 3px 낮아짐) 등돌기도 낮게 움츠림
    // + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "..KK........................KK..",
        "..KCCK....................KCCK..",
        "...KCCK........KK........KCCK...",
        "....KCCK..KK..KCCK..KK..KCCK....",
        ".....KCCKKCCK.KCCK.KCCKKCCK.....",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGMMGGGGGGGGGGMMGGGGGDK..",
        ".KGGGGGMMGGGGGGGGGGGGGGMMGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGHGGGGWWWWWWGGGGGGGBBGDK.",
        ".KGGBBGGGGGGWWNWWNWWGGGGGGBBGDK.",
        ".KGGGGGGGGGGWWNWWNWWGGGGGGGGGDK.",
        ".KGGGGGGGGGGWWWWWWWWGGGGGGGGGDK.",
        ".KGGGGGGGGGGGWWWWWWGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGMMGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGMGGMGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 뿔·등돌기 처짐
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 볼터치 제거
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "..KK........................KK..",
        "..KCCK....................KCCK..",
        "...KCCK........KK........KCCK...",
        "....KCCK..KK..KCCK..KK..KCCK....",
        ".....KCCKKCCK.KCCK.KCCKKCCK.....",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "....KWWWWWWWWWWWWWWWWWWWWWWK....",
        "...KWWWWWWWWWWWWWWWWWWWWWWWWK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWGGGGGGWWWWWWWWWWDK.",
        ".KWWWWWWWWWWGGNGGNGGWWWWWWWWWDK.",
        ".KWWWWWWWWWWGGGGGGGGWWWWWWWWWDK.",
        ".KWWWWWWWWWWWGGGGGGWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWMMWWWWWWWWWWWWDK.",
        "..KWWWWWWWWWWWMWWMWWWWWWWWWWDK..",
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
