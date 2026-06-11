import Foundation

// 성체 꼬꼬(닭) 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 베이지브라운 외곽선 + 크림화이트 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율(통통한 병아리상).
// 실루엣: 머리 위 빨간 볏 3봉(R)과 노란 부리(Y 삼각)+부리 아래 빨간 턱볏(R)이
// 어떤 상태에서도 닭임을 보장한다 (잠·위독은 볏 처짐 예외). 32×32에는
// 뒤로 휘는 그린 꼬리깃(T) 2가닥을 좌측에 추가. 음영 D는 광원 좌상단 가정으로
// 우측/하단에 일관 배치.
enum RoosterSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xB49A6EFF,   // K — 외곽선 (웜 베이지브라운)
        "\u{47}": 0xF5ECD7FF,   // G — 크림화이트 몸통
        "\u{44}": 0xE2D2B2FF,   // D — 음영
        "\u{52}": 0xEF6A6AFF,   // R — 볏·턱볏 (레드)
        "\u{59}": 0xF3B340FF,   // Y — 부리 (옐로)
        "\u{54}": 0x7FA98FFF,   // T — 꼬리깃 (그린)
        "\u{42}": 0xF6C4B4FF,   // B — 볼터치
        "\u{57}": 0xFCF7EAFF,   // W — 배
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입 (웜브라운)
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16x16 소형 프레임

    // 기본 포즈 — 빨간 볏 3봉 + 큰 눈(좌상단 H) + 부리(Y)·턱볏(R) + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
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
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
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
        ".....R.RR.R...H.",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
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
        ".....R.RR.R.....",
        ".....RRRRRR...H.",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 눈 감음(가로 E 라인, 머리 1px 가라앉음) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "................",
        ".............W..",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 더 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 부리를 크게 벌림 (Y 테두리 + 입 안 M 2px)
    static let hungry1Rows = [
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGYYYYGGDK..",
        "..KBGGYMMYGBDK..",
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
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KGGGYYYYGGDK..",
        "..KBGGYMMYGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 감은 눈 + 1px 주저앉음 + 볼터치 제거 (볏·턱볏은 유지)
    static let critical1Rows = [
        "................",
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKWWWWWWKK...",
        "..KWWWWWWWWWDK..",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWYYWWWDK..",
        "..KWWWWRRWWWDK..",
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
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKWWWWWWKK...",
        "..KWWWWWWWWWDK..",
        "..KWWWWWWWWWDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWYYWWWDK..",
        "..KWWWWRRWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDK..",
        "...KWGGGGGGDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (T 2×2, 꼬리깃과 같은 그린)
    static let playing1Rows = [
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK.TT",
        "....KKKKKKKK..TT",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        ".....R.RR.R.....",
        ".....RRRRRR.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGDK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KGGGGYYGGGDK..",
        "..KBGGGRRGGBDKTT",
        "..KGWWWWWWWWDKTT",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDK..",
        "...KGWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // MARK: - 32x32 대형 초상화

    // 32x32 초상 — 행복: 볏 3봉(가운데 봉이 가장 높음) + 웃으며 벌린 부리(Y 테두리+M)
    // + 턱볏 R 2×2 + 좌측 뒤로 휘는 꼬리깃 T 2가닥 + 볼터치 + 배 W
    static let largeHappyRows = [
        "................................",
        "................................",
        "...............RR...............",
        "...........RR.RRRR.RR...........",
        "..T........RRRRRRRRRR...........",
        ".TT........RRRRRRRRRR...........",
        ".TT..T......RRRRRRRR............",
        ".TT..TT...KKKKKKKKKKKK..........",
        "..TT.TTKKKGGGGGGGGGGGGKKK.......",
        "..TTTKKGGGGGGGGGGGGGGGGGGKK.....",
        "...TKGGGGGGGGGGGGGGGGGGGGGGK....",
        "..TKGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGGGGGGYYYYYYGGGGGGGBBGDK.",
        ".KGGBBGGGGGGGYMMMMYGGGGGGGBBGDK.",
        ".KGGGGGGGGGGGGYYYYGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGRRGGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGRRGGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 볏이 오른쪽으로 축 처져 납작해짐 + 안쪽으로 올라간 눈썹(M)
    // + 왼눈 아래 눈물 1px(H) + 부리 아래 입 ∩ 곡선 + 꼬리깃도 아래로 처짐 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "..............RRRR..............",
        "...............RRRRR............",
        "..........KKKKKKKKKKKK..........",
        "...T...KKKGGGGGGGGGGGGKKK.......",
        "..T.TKKGGGGGGGGGGGGGGGGGGKK.....",
        ".T.TKGGGGGGGGGGGGGGGGGGGGGGK....",
        "T.TKGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "T.KGGGGGGMMGGGGGGGGGGMMGGGGGDK..",
        ".KGGGGGMMGGGGGGGGGGGGGGMMGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGGHGGGGYYYYYYGGGGGGGBBGDK.",
        ".KGGBBGGGGGGGGYYYYGGGGGGGGBBGDK.",
        ".KGGGGGGGGGGGGGMMGGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGMGGMGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGRRGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK...",
        "....KKGGGGGGGGGGGGGGGGGGGDKK....",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGWWWWWWWWWWWWGGDK......",
        "......KGGGGWWWWWWWWWWGGGDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 볏이 납작하게 주저앉음
    // + 전체 아래로 주저앉음(상단 10행 비움) + 볼터치·꼬리깃 제거 (부리·턱볏은 유지)
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
        ".............RRRRR..............",
        "..........KKKKKKKKKKKK..........",
        ".......KKKWWWWWWWWWWWWKKK.......",
        ".....KKWWWWWWWWWWWWWWWWWWKK.....",
        "....KWWWWWWWWWWWWWWWWWWWWWWK....",
        "...KWWWWWWWWWWWWWWWWWWWWWWWWK...",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWYYYYYYWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWYYYYWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWRRWWWWWWWWWWWWDK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWWGGGGGGGGGGWWWDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
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
