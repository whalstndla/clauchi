import Foundation

// 성체 수탉 도트 (꼬꼬 — 스펙 §8)
// 실루엣: 직립 치비 닭, 머리 위 빨간 볏, 주황 부리, 흰/황갈색 깃털 몸통, 꼬리깃 위로 솟음
enum RoosterSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기한다.
    // 검증 스크립트가 따옴표 안 대문자 문자열을 프레임 행으로 집계하므로 충돌을 피하기 위함.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{59}": 0xFBBF24FF,   // Y — 황갈색 몸통
        "\u{44}": 0xF59E0BFF,   // D — 주황 음영
        "\u{57}": 0xFEF3E2FF,   // W — 밝은 배/창백
        "\u{43}": 0xEF4444FF,   // C — 빨간 볏/육수
        "\u{42}": 0xF97316FF,   // B — 주황 부리
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16x16 소형 프레임

    // 기본 포즈 — 볏 위로 솟음, 부리 오른쪽, 꼬리깃 왼쪽 위로 솟음
    static let idle1Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYYYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 점프 + 우상단 땀방울
    static let working1Rows = [
        "....CC........W.",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 자세 + 땀방울이 아래로 이동
    static let working2Rows = [
        "................",
        "....CC........W.",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
    ]

    // 잠 — 눈 감음 + 우상단 z 표시
    static let sleeping1Rows = [
        "....CC.....W....",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYYYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 잠 — z 표시가 위로 이동
    static let sleeping2Rows = [
        "....CC..W.......",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYYYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 배고픔 — 부리를 크게 벌림
    static let hungry1Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK......",
        "..KYYYYYBK......",
        "..KYYYWKYK......",
        "..KYYYBBBK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 배고픔 — 벌린 부리 + 눈물
    static let hungry2Rows = [
        "................",
        "....CC..........",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK....W.",
        "..KYYYYYBK......",
        "..KYYYWKYK......",
        "..KYYYBBBK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
    ]

    // 위독 — 창백(황갈색 Y와 배 W 반전), 볏은 유지
    static let critical1Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KWWWK.......",
        "...KWEWWWK......",
        "..KWWWWWBK......",
        "..KWWWYYYK......",
        "..KWWYYYYK......",
        "..KWWWWYYK......",
        "...KWWWWK.......",
        "..KWWWWWK.......",
        ".KWWYYYYWK......",
        ".KWWYYYYWK......",
        "..KWWWWWK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 위독 — 창백 + 1px 주저앉음
    static let critical2Rows = [
        "................",
        "....CC..........",
        "...CCKCC........",
        "....KWWWK.......",
        "...KWEWWWK......",
        "..KWWWWWBK......",
        "..KWWWYYYK......",
        "..KWWYYYYK......",
        "..KWWWWYYK......",
        "...KWWWWK.......",
        "..KWWWWWK.......",
        ".KWWYYYYWK......",
        ".KWWYYYYWK......",
        "..KWWWWWK.......",
        "..KKK.KKK.......",
        "...K...K........",
    ]

    // 휴일 놀기 — 오른쪽 아래 공
    static let playing1Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KYYYK.......",
        "...KYEYYYK......",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK....CC.",
        ".KYYWWWYYK...CC.",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "....CC..........",
        "...CCKCC........",
        "....KYYYK....CC.",
        "...KYEYYYK...CC.",
        "..KYYYYYBK......",
        "..KYYYWWYK......",
        "..KYYWWWYK......",
        "..KYYYYWYK......",
        "...KYYYYK.......",
        "..KYYYYYK.......",
        ".KYYWWWYYK......",
        ".KYYWWWWYK......",
        "..KYYYYYK.......",
        "..KKK.KKK.......",
        "...K...K........",
        "................",
    ]

    // MARK: - 32x32 대형 초상화 (수작업 — 음영 D, 볏/육수 C 빨강, 부리 B 주황)

    // 행복 — 쫑긋 선 볏, 뜬 눈, 위로 휘어진 입, 꼬리깃 왼쪽에 솟음
    static let largeHappyRows = [
        "................CCCC............",
        "...............CCCCCC...........",
        "..............CCCKCCCC..........",
        "...............KYYYYK...........",
        "..............KYYYYYYK..........",
        ".............KYYYYYYYK..........",
        "...KKKK......KYYEYYEYK..........",
        "..KCCCCK.....KYYYYBBBK..........",
        ".KCCCCCK....KYYYWWWWYK..........",
        ".KCCCCCK....KYYYYYWYYK..........",
        "..KCCCK.....KYYYYYYYK...........",
        "...KCKK......KYYYYYK............",
        "....KKYYYYYYYYYYYYYYK...........",
        "....KYYYYYYYYYYYYYYYDK..........",
        "...KYYYYYYYYYYYYYYYYDDK.........",
        "..KYYYYYYYYYYYYYYYYYDDK.........",
        "..KYYEYYYYYYYYYYYYEYYDK.........",
        "..KYYEYYYYYYYYYYYYEYYDK.........",
        "..KYYYYYYWWYYYYYYWWYYYDK........",
        "..KYYYYYWWKWYYYYWKWYYYYDK.......",
        "..KYYYYYWWWKKKKKWWYYYYYDK.......",
        "..KYYYYYYYYYYYYYYYYYYYYDK.......",
        "...KYYYYYYYYYYYYYYYYYYYDK.......",
        "....KYYYYYYYYYYYYYYYYYDDK.......",
        "....KYYWWWWWWWWWWWWWYYYDK.......",
        "...KYYWWWWWWWWWWWWWWWYYDK.......",
        "...KYYWWWWWWWWWWWWWWWYYDK.......",
        "....KYYYYYYYYYYYYYYYYYDDK.......",
        "....KYYYYYYYYYYYYYYYYDDDK.......",
        ".....KYYYYYYYYYYYYYDDDK.........",
        "......KKKKKKKKKKKKKKKK..........",
        ".......KKK......KKK.............",
    ]

    // 슬픔 — 볏 축 처짐, 눈물, 아래로 굽은 입, 꼬리깃 내려짐
    static let largeSadRows = [
        "................................",
        "...KKKK.........................",
        "..KCCCCK........................",
        ".KCCCCCK........................",
        ".KCCCCCK...CCCC.................",
        "..KCCCK...CCCCCC................",
        "...KCK...CCCKCCCC...............",
        "....KK....KYYYYK................",
        "..........KYYYYYYK..............",
        ".........KYYYYYYYK..............",
        ".........KYYEYYEYK..............",
        ".........KYYYYBBBK..............",
        "........KYYYWWWWYK..............",
        ".......KYYYYYWYYYDK.............",
        "......KYYYYYYYYYYYYDDK..........",
        ".....KYYYYYYYYYYYYYYDDK.........",
        "....KYYEYYYYYYYYYYYYEYYDK.......",
        "....KYYEYYYYYYYYYYYYEYYDK.......",
        "...KYYYYYWWYYYYYYYWWYYYYDK......",
        "...KYYYYYYWKWYYYYWKWYYYYDK......",
        "...KYYYYYYYYKKKKKKYYYYYYDDK.....",
        "...KYYYYYYYYYYYYYYYYYYYYYYDK....",
        "....KYYYYYYYYYYYYYYYYYYYYDDK....",
        "....KYYWWWWWWWWWWWWWWYYYDK......",
        ".....KYYWWWWWWWWWWWWWYYDK.......",
        ".....KYYWWWWWWWWWWWWYYYDK.......",
        ".....KYYYYYYYYYYYYYYYYDDK.......",
        "......KYYYYYYYYYYYYYDDK.........",
        "......KYYYYYYYYYYYYDDDK.........",
        ".......KKKKKKKKKKKKKKK..........",
        ".......KKK......KKK.............",
        "................................",
    ]

    // 위독 — 창백한 몸(Y↔W 반전), X 자 눈, 일자로 다문 입, 볏은 어두워짐
    static let largeCriticalRows = [
        "................................",
        "................CCCC............",
        "...............CCCCCC...........",
        ".......KKKK...CCCKCCCC..........",
        "......KCCCCK...KWWWWK...........",
        ".....KCCCCCK..KWWWWWWK..........",
        ".....KCCCCCK..KWWWWWWK..........",
        "......KCCCCK..KWWEWEWK..........",
        ".......KCKK...KWWWWBBK..........",
        "........KK....KWWWYYYYK.........",
        "..............KWWWWYYWK.........",
        "..............KWWWWWWK..........",
        "..............KWWWWWK...........",
        "....KWWWWWWWWWWWWWWWWK..........",
        "...KWWWWWWWWWWWWWWWWWYK.........",
        "..KWWWWWWWWWWWWWWWWWWYYK........",
        "..KWWEWEWWWWWWWWWWWEWEWYK.......",
        "..KWWWEWWWWWWWWWWWWWWEWYK.......",
        "..KWWEWEWWWWWWWWWWWEWEWYK.......",
        "..KWWWWWWYYYWWWWWYYYWWWYYK......",
        "..KWWWWWWYYKWWWWWYYKWWWYYK......",
        "..KWWWWWWWWYYYYYYWWWWWWWYYK.....",
        "..KWWWWWWWWWWWWWWWWWWWWWYYK.....",
        "...KWWWWWWWWWWWWWWWWWWWWYYK.....",
        "....KWWYYYYYYYYYYYYYYYWWYK......",
        "....KWWYYYYYYYYYYYYYYYWWYK......",
        ".....KWWYYYYYYYYYYYYYYYWYK......",
        ".....KWWWWWWWWWWWWWWWWYYK.......",
        "......KWWWWWWWWWWWWWWWYYK.......",
        "......KWWWWWWWWWWWWWWYYYDK......",
        ".......KKKKKKKKKKKKKKKKK........",
        ".......KKK......KKK.............",
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
