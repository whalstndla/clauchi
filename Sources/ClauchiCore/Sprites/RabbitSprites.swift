import Foundation

// 성체 토끼 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 웜 토프 외곽선 + 파스텔 크림 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 위로 길게 솟은 두 귀(안쪽 핑크)가 어떤 상태에서도 토끼임을 보장한다
// (잠·위독은 처진 귀 예외). 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum RabbitSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xB59C8CFF,   // K — 외곽선 (웜 토프)
        "\u{4C}": 0xF5EDE3FF,   // L — 크림 몸통
        "\u{44}": 0xE2D4C6FF,   // D — 음영
        "\u{50}": 0xFBAED6FF,   // P — 귀 안쪽
        "\u{42}": 0xF9C6DAFF,   // B — 볼터치
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{57}": 0xFFFAF0FF,   // W — 배
        "\u{4E}": 0xF2699FFF,   // N — 코
        "\u{4D}": 0x8A6B57FF,   // M — 입
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 쫑긋 선 두 귀(안쪽 P) + 큰 눈(좌상단 H) + 볼터치 + 배 W
    static let idle1Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 깜빡임 — 눈을 몸색 L로 감춰 깜빡이는 대비를 만든다
    static let idle2Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLLLLLLLLDK..",
        "..KLLLLLLLLLDK..",
        "..KBLLLNNLLBDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 땀방울 P
    static let working1Rows = [
        "...KLLK..KLLK.P.",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK.P.",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — 귀 옆으로 축 처짐 + 눈 감음(가로 E 라인) + 우상단 z 표시(W)
    static let sleeping1Rows = [
        "................",
        ".............W..",
        "................",
        ".KK..........KK.",
        ".KLPK......KPLK.",
        "..KKKKKKKKKKKK..",
        "..KLLLLLLLLLLK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLLLLLLLLLDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
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
        ".KLPK......KPLK.",
        "..KKKKKKKKKKKK..",
        "..KLLLLLLLLLLK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLLLLLLLLLDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLLLLMMLLLDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLLLLLLLLLDK..",
        "..KLEELLLLEEDKH.",
        "..KBLLLNNLLBDK..",
        "..KLLLLMMLLLDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 반전(L↔W) + 귀 완전 처짐 + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "................",
        "................",
        ".KK..........KK.",
        ".KWPK......KPWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWNNWWWDK..",
        "..KWLLLLLLLLDK..",
        "..KWLLLLLLLLDK..",
        "..KWLLLLLLLLDK..",
        "...KWLLLLLLDK...",
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
        ".KWPK......KPWK.",
        "..KKKKKKKKKKKK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWNNWWWDK..",
        "..KWLLLLLLLLDK..",
        "..KWLLLLLLLLDK..",
        "..KWLLLLLLLLDK..",
        "...KWLLLLLLDK...",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 발치의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK.NN",
        "....KKKKKKKK..NN",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "...KLLK..KLLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLPK..KPLK...",
        "...KLLKKKKLLK...",
        "..KLLLLLLLLLLK..",
        "..KLHELLLLHEDK..",
        "..KLEELLLLEEDK..",
        "..KBLLLNNLLBDKNN",
        "..KLWWWWWWWWDKNN",
        "..KLWWWWWWWWDK..",
        "..KLWWWWWWWWDK..",
        "...KLWWWWWWDK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 32x32 초상 — 행복: 사용자 승인 시안 (브라우저 비교에서 선택된 스타일 C 원본)
    static let largeHappyRows = [
        "........KLLK........KLLK........",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".......KLPPLK......KLPPLK.......",
        ".....KKKLLLLKKKKKKKKLLLLKKK.....",
        "....KLLLLLLLLLLLLLLLLLLLLLLK....",
        "...KLLLLLLLLLLLLLLLLLLLLLLLLK...",
        "..KLLLLLLLLLLLLLLLLLLLLLLLLLDK..",
        "..KLLLLLLLLLLLLLLLLLLLLLLLLLDK..",
        ".KLLLLLLLLLLLLLLLLLLLLLLLLLLLDK.",
        ".KLLLLLHEELLLLLLLLLLLLHEELLLLDK.",
        ".KLLLLLEEELLLLLLLLLLLLEEELLLLDK.",
        ".KLLLLLEEELLLLLLLLLLLLEEELLLLDK.",
        ".KLLBBLEEELLLLLLLLLLLLEEELBBLDK.",
        ".KLLBBLLLLLLLLLNNLLLLLLLLLBBLDK.",
        ".KLLLLLLLLLLLLMLLMLLLLLLLLLLLDK.",
        ".KLLLLLLLLLLLLLMMLLLLLLLLLLLLDK.",
        ".KLLLLLLLLLLLLLLLLLLLLLLLLLLLDK.",
        "..KLLLLLLLLLLLLLLLLLLLLLLLLLDK..",
        "...KLLLLLLLLLLLLLLLLLLLLLLLDK...",
        "....KKLLLLLLLLLLLLLLLLLLLDKK....",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLLWWWWWWWWWWLLLDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 상단이 비고 귀가 좌우 바깥으로 늘어짐(안쪽 P 줄무늬)
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
        ".KLPKKKKKKKKKKKKKKKKKKKKKKKKPLK.",
        "KLPKKLLLLLLLLLLLLLLLLLLLLLLKKPLK",
        "KPKKLLLLLLLLLLLLLLLLLLLLLLLLKKPK",
        "KKKLLLLLLLLLLLLLLLLLLLLLLLLLDKKK",
        "..KLLLLLLMMLLLLLLLLLLMMLLLLLDK..",
        ".KLLLLLMMLLLLLLLLLLLLLLMMLLLLDK.",
        ".KLLLLLHEELLLLLLLLLLLLHEELLLLDK.",
        ".KLLLLLEEELLLLLLLLLLLLEEELLLLDK.",
        ".KLLLLLEEELLLLLLLLLLLLEEELLLLDK.",
        ".KLLBBLEEELLLLLLLLLLLLEEELBBLDK.",
        ".KLLBBLLHLLLLLLNNLLLLLLLLLBBLDK.",
        ".KLLLLLLLLLLLLLMMLLLLLLLLLLLLDK.",
        ".KLLLLLLLLLLLLMLLMLLLLLLLLLLLDK.",
        ".KLLLLLLLLLLLLLLLLLLLLLLLLLLLDK.",
        "..KLLLLLLLLLLLLLLLLLLLLLLLLLDK..",
        "...KLLLLLLLLLLLLLLLLLLLLLLLDK...",
        "....KKLLLLLLLLLLLLLLLLLLLDKK....",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLWWWWWWWWWWWWLLDK......",
        "......KLLLLWWWWWWWWWWLLLDK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 L↔W 반전(창백) + X자 눈(E 3×3) + 귀 완전 처짐
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 볼터치 제거
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
        ".KWPKKKKKKKKKKKKKKKKKKKKKKKKPWK.",
        "KWPKKWWWWWWWWWWWWWWWWWWWWWWKKPWK",
        "KPKKWWWWWWWWWWWWWWWWWWWWWWWWKKPK",
        "KKKWWWWWWWWWWWWWWWWWWWWWWWWWDKKK",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWWWNNWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWMMWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWMWWMWWWWWWWWWWWDK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWWWLLLLLLLLLLLLWWDK......",
        "......KWWWLLLLLLLLLLLLWWDK......",
        "......KWWWLLLLLLLLLLLLWWDK......",
        "......KWWWWLLLLLLLLLLWWWDK......",
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
