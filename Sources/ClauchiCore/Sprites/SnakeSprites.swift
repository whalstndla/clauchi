import Foundation

// 성체 뱀 도트 — 스르륵, 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 올리브 외곽선 + 파스텔 연두 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 바닥에 또아리 튼 코일 2겹(가로로 낮은 형태) + 그 위로 올라온 둥근 머리,
// 낼름 내민 갈라진 혀(P)와 등의 S 무늬 점, 코일 우측의 꼬리 팁이
// 어떤 상태에서도 뱀임을 보장한다. idle은 깜빡임 대신 혀 넣었다 뺐다로 연출.
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum SnakeSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x74933BFF,   // K — 외곽선 (올리브)
        "\u{47}": 0xBCD96CFF,   // G — 연두 몸통
        "\u{44}": 0x9DBE4FFF,   // D — 음영
        "\u{57}": 0xEFF7D8FF,   // W — 배 (연크림)
        "\u{53}": 0x86A647FF,   // S — 등 무늬 점
        "\u{50}": 0xF25F9CFF,   // P — 혀 (핑크)
        "\u{42}": 0xF7BFCBFF,   // B — 볼터치
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 또아리 코일 2겹 위 둥근 머리 + 갈라진 혀 낼름(P) + 볼터치 + 등 무늬 S
    static let idle1Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGPGBDK....",
        "...KKKKPKKK.....",
        "...KKKPKPKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 혀 수납 — 깜빡임 대신 혀를 넣고 작은 입 M으로 표정 유지
    static let idle2Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGMGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 혀 낼름 + 땀방울 H
    static let working1Rows = [
        "....KKKKKK....H.",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGPGBDK....",
        "...KKKKPKKK.....",
        "...KKKPKPKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 혀 수납 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK...H.",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGMGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 잠 — 눈 감음(가로 E 라인) + 혀 수납 + 우상단 z 표시(W)
    static let sleeping1Rows = [
        ".............W..",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGGGGGGGDK....",
        "..KGEEGGEEDK....",
        "..KBGGGGGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGGGGGGGDK....",
        "..KGEEGGEEDK....",
        "..KBGGGGGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
    ]

    // 배고픔 — 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGMMGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGGGGGGGDK....",
        "..KGEEGGEEDKH...",
        "..KBGGMMGBDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 감은 눈(흐릿한 EE, H 없음) + 볼터치 제거 + 혀 수납
    static let critical1Rows = [
        "................",
        "....KKKKKK......",
        "...KWWWWWWK.....",
        "..KWWWWWWWDK....",
        "..KWEEWWEEDK....",
        "..KWEEWWEEDK....",
        "..KWWWWWWWDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KWSWWSWWSWDK..",
        "..KGGGGGGGGGDKKK",
        ".KKKKKKKKKKKKKWK",
        ".KWSWWSWWSWWSDKK",
        ".KGGGGGGGGGGGDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "....KKKKKK......",
        "...KWWWWWWK.....",
        "..KWWWWWWWDK....",
        "..KWEEWWEEDK....",
        "..KWEEWWEEDK....",
        "..KWWWWWWWDK....",
        "...KKKKKKKK.....",
        "...KKKKKKKKKK...",
        "..KWSWWSWWSWDK..",
        "..KGGGGGGGGGDKKK",
        ".KKKKKKKKKKKKKWK",
        ".KWSWWSWWSWWSDKK",
        ".KGGGGGGGGGGGDK.",
        "..KKKKKKKKKKKK..",
    ]

    // 휴일 놀기 — 코일 발치의 공 (P 2×2) + 혀 낼름
    static let playing1Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGPGBDK....",
        "...KKKKPKKK.....",
        "...KKKPKPKKKK...",
        "..KGSGGSGGSGDK..",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKKPP",
        "..............PP",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "....KKKKKK......",
        "...KGGGGGGK.....",
        "..KGGGGGGGDK....",
        "..KGHEGGHEDK....",
        "..KGEEGGEEDK....",
        "..KBGGGPGBDK....",
        "...KKKKPKKK.....",
        "...KKKPKPKKKK.PP",
        "..KGSGGSGGSGDKPP",
        "..KWWWWWWWWWDKKK",
        ".KKKKKKKKKKKKKGK",
        ".KGSGGSGGSGGSDKK",
        ".KWWWWWWWWWWWDK.",
        "..KKKKKKKKKKKK..",
        "................",
    ]

    // 32x32 초상 — 행복: 큰 둥근 머리 + 웃는 입 아래로 혀 블렙(P, 턱 아래에서 갈라짐)
    // + 코일 2겹(등 무늬 S 점 + 배 W) + 우측 꼬리 팁
    static let largeHappyRows = [
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKGGGGGGGGGGGGKK........",
        ".......KGGGGGGGGGGGGGGGGK.......",
        "......KGGGGGGGGGGGGGGGGGGK......",
        ".....KGGGGGGGGGGGGGGGGGGGGK.....",
        "....KGGGGGGGGGGGGGGGGGGGGGDK....",
        "....KGGGGGGGGGGGGGGGGGGGGGDK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "...KGGGGHEEGGGGGGGGGGHEEGGGDK...",
        "...KGGGGEEEGGGGGGGGGGEEEGGGDK...",
        "...KGGGGEEEGGGGGGGGGGEEEGGGDK...",
        "...KGBBGGGGGGGGGGGGGGGGGGBBDK...",
        "...KGBBGGGGGGGMGGMGGGGGGGBBDK...",
        "...KGGGGGGGGGGGMMGGGGGGGGGGDK...",
        "...KGGGGGGGGGGGPPGGGGGGGGGGDK...",
        "....KGGGGGGGGGGPPGGGGGGGGGDK....",
        ".....KKKKKKKKKKPPKKKKKKKKKK.....",
        "....KKKKKKKKKKPKKPKKKKKKKKKK....",
        "...KGSSGGGSSGGGSSGGGSSGGGDDKKK..",
        "...KGGGGGGGGGGGGGGGGGGGGGDDKKGK.",
        "...KWWWWWWWWWWWWWWWWWWWWWDDKKGK.",
        ".KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK.",
        ".KGSSGGGSSGGGSSGGGSSGGGSSGDDK...",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGDDK...",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWDDK...",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWDDK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWDDK....",
        "...KKKKKKKKKKKKKKKKKKKKKKKKK....",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H)
    // + 입 ∩ 곡선 + 혀 수납 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKGGGGGGGGGGGGKK........",
        ".......KGGGGGGGGGGGGGGGGK.......",
        "......KGGGGGGGGGGGGGGGGGGK......",
        ".....KGGGGGGGGGGGGGGGGGGGGK.....",
        "....KGGGGGGGGGGGGGGGGGGGGGDK....",
        "....KGGGGGGGGGGGGGGGGGGGGGDK....",
        "...KGGGGGGGMMGGGGGGGMMGGGGGDK...",
        "...KGGGGGMMGGGGGGGGGGGGMMGGDK...",
        "...KGGGGHEEGGGGGGGGGGHEEGGGDK...",
        "...KGGGGEEEGGGGGGGGGGEEEGGGDK...",
        "...KGGGGEEEGGGGGGGGGGEEEGGGDK...",
        "...KGBBGGHGGGGGGGGGGGGGGGBBDK...",
        "...KGBBGGGGGGGGMMGGGGGGGGBBDK...",
        "...KGGGGGGGGGGMGGMGGGGGGGGGDK...",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KGGGGGGGGGGGGGGGGGGGGGDK....",
        ".....KKKKKKKKKKKKKKKKKKKKKK.....",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "...KGSSGGGSSGGGSSGGGSSGGGDDKKK..",
        "...KGGGGGGGGGGGGGGGGGGGGGDDKKGK.",
        "...KWWWWWWWWWWWWWWWWWWWWWDDKKGK.",
        ".KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK.",
        ".KGSSGGGSSGGGSSGGGSSGGGSSGDDK...",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGDDK...",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWDDK...",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWDDK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWDDK....",
        "...KKKKKKKKKKKKKKKKKKKKKKKKK....",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 볼터치 제거
    // + 머리 2px 주저앉음(상단 2행 추가로 비우고 머리 높이 축소) + 혀 수납
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "..........KKKKKKKKKKKK..........",
        "........KKWWWWWWWWWWWWKK........",
        ".......KWWWWWWWWWWWWWWWWK.......",
        "......KWWWWWWWWWWWWWWWWWWK......",
        ".....KWWWWWWWWWWWWWWWWWWWWK.....",
        "....KWWWWWWWWWWWWWWWWWWWWWDK....",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "...KWWWWEWEWWWWWWWWWWEWEWWWDK...",
        "...KWWWWWEWWWWWWWWWWWWEWWWWDK...",
        "...KWWWWEWEWWWWWWWWWWEWEWWWDK...",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "...KWWWWWWWWWWWMMWWWWWWWWWWDK...",
        "...KWWWWWWWWWWMWWMWWWWWWWWWDK...",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KWWWWWWWWWWWWWWWWWWWWWDK....",
        ".....KKKKKKKKKKKKKKKKKKKKKK.....",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "...KWSSWWWSSWWWSSWWWSSWWWDDKKK..",
        "...KWWWWWWWWWWWWWWWWWWWWWDDKKWK.",
        "...KGGGGGGGGGGGGGGGGGGGGGDDKKWK.",
        ".KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK.",
        ".KWSSWWWSSWWWSSWWWSSWWWSSWDDK...",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWDDK...",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGDDK...",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGDDK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGDDK....",
        "...KKKKKKKKKKKKKKKKKKKKKKKKK....",
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
