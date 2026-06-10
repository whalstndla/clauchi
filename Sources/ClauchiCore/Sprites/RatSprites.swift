import Foundation

// 성체 쥐 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 블루그레이 외곽선 + 파스텔 연회색 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 머리 위 큰 둥근 귀 2개(안쪽 핑크)와 오른쪽 아래로 길게 굽은 분홍 꼬리가
// 어떤 상태에서도 쥐임을 보장한다 (위독은 꼬리가 바닥에 축 늘어지는 예외).
// 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum RatSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x8E94A3FF,   // K — 외곽선 (블루그레이)
        "\u{47}": 0xD9DCE3FF,   // G — 연회색 몸통
        "\u{44}": 0xB9BEC9FF,   // D — 음영
        "\u{50}": 0xF9A8D4FF,   // P — 귀 안쪽·꼬리
        "\u{42}": 0xF7BFD0FF,   // B — 볼터치
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{57}": 0xFBF6EEFF,   // W — 배
        "\u{4E}": 0xF2699FFF,   // N — 코
        "\u{4D}": 0x8A6B57FF,   // M — 입
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // 기본 포즈 — 둥근 귀(안쪽 P) + 큰 눈(좌상단 H) + 볼터치 + 배 W + 오른쪽 꼬리 P
    static let idle1Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 깜빡임 — 눈을 몸색 G로 감춰 깜빡이는 대비를 만든다
    static let idle2Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGGGGGGGGGDK..",
        "..KGGGGGGGGGDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 땀방울 P
    static let working1Rows = [
        "..KGGK....KGGK.P",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동(얼굴 옆으로 떨어짐)
    static let working2Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK.P",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 잠 — 눈 감음(가로 E 라인) + 우상단 z 표시(W), 몸은 1px 내려앉음
    static let sleeping1Rows = [
        "................",
        ".............W..",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 더 가라앉고 z 표시가 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "................",
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
    ]

    // 배고픔 — 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGGGGGGGGGDK..",
        "..KGEEGGGGEEDKH.",
        "..KBGGGNNGGBDK..",
        "..KGGGGMMGGGDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 위독 — 창백 반전(G↔W) + 볼터치 제거 + 흐릿한 눈(H 없음)
    static let critical1Rows = [
        "................",
        "..KWWK....KWWK..",
        ".KWPPWK..KWPPWK.",
        ".KWPPWK..KWPPWK.",
        "..KWWKKKKKKWWK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWNNWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDKP.",
        "..KWGGGGGGGGDK.P",
        "...KWGGGGGGDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "..KWWK....KWWK..",
        ".KWPPWK..KWPPWK.",
        ".KWPPWK..KWPPWK.",
        "..KWWKKKKKKWWK..",
        "..KWWWWWWWWWWK..",
        "..KWEEWWWWEEDK..",
        "..KWEEWWWWEEDK..",
        "..KWWWWNNWWWDK..",
        "..KWGGGGGGGGDK..",
        "..KWGGGGGGGGDKP.",
        "..KWGGGGGGGGDK.P",
        "...KWGGGGGGDK..P",
        "....KKKKKKKK..PP",
        "................",
    ]

    // 휴일 놀기 — 발치의 공 (N 2×2, 꼬리와 겹치지 않게 왼쪽에 배치)
    static let playing1Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "..KBGGGNNGGBDK..",
        "..KGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "NN.KGWWWWWWDK..P",
        "NN..KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 휴일 놀기 — 공이 위로 튀어오름
    static let playing2Rows = [
        "................",
        "..KGGK....KGGK..",
        ".KGPPGK..KGPPGK.",
        ".KGPPGK..KGPPGK.",
        "..KGGKKKKKKGGK..",
        "..KGGGGGGGGGGK..",
        "..KGHEGGGGHEDK..",
        "..KGEEGGGGEEDK..",
        "NNKBGGGNNGGBDK..",
        "NNKGWWWWWWWWDK..",
        "..KGWWWWWWWWDKP.",
        "..KGWWWWWWWWDK.P",
        "...KGWWWWWWDK..P",
        "....KKKKKKKK..PP",
        "................",
        "................",
    ]

    // 32x32 초상 — 행복: 머리 위 큰 둥근 귀(안쪽 P, 우측 D 음영) + 웃는 입
    // + 오른쪽 아래로 길게 굽어 바닥에서 말리는 분홍 꼬리
    static let largeHappyRows = [
        ".....KKKKK............KKKKK.....",
        "....KGGGGGK..........KGGGGGK....",
        "...KGGPPPGGK........KGGPPPGGK...",
        "...KGPPPPPDK........KGPPPPPDK...",
        "...KGPPPPPDK........KGPPPPPDK...",
        "...KGPPPPPDK........KGPPPPPDK...",
        "...KGGPPPGDK........KGGPPPGDK...",
        "....KGGGGGK..........KGGGGGK....",
        "....KGGGGGKKKKKKKKKKKKGGGGGK....",
        "....KGGGGGGGGGGGGGGGGGGGGGGK....",
        "...KGGGGGGGGGGGGGGGGGGGGGGGGK...",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDK..",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGEEEGGGGGGGGGGGGEEEGBBGDK.",
        ".KGGBBGGGGGGGGGNNGGGGGGGGGBBGDK.",
        ".KGGGGGGGGGGGGMGGMGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGMMGGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDKP.",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK..P",
        "....KKGGGGGGGGGGGGGGGGGGGDKK...P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGGWWWWWWWWWWGGGDK....PP",
        "......KKKKKKKKKKKKKKKKKKKK...PP.",
        "...........................PPP..",
        "................................",
    ]

    // 32x32 초상 — 슬픔: 둥근 귀가 머리 양옆으로 미끄러져 처짐(안쪽 P 축소)
    // + 안쪽으로 올라간 눈썹(M) + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "..KKKK....................KKKK..",
        ".KGGGGK..................KGGGGK.",
        "KGGPPGGKKKKKKKKKKKKKKKKKKGGPPGGK",
        "KGPPPPGKGGGGGGGGGGGGGGGGKGPPPPGK",
        "KGPPPPGKGGGGGGGGGGGGGGGGKGPPPPGK",
        ".KGGGGKGGGGGGGGGGGGGGGGGGKGGGGK.",
        "..KKKKGGGMMGGGGGGGGGGMMGGGKKKK..",
        ".KGGGGGMMGGGGGGGGGGGGGGMMGGGGDK.",
        ".KGGGGGHEEGGGGGGGGGGGGHEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGGGGEEEGGGGGGGGGGGGEEEGGGGDK.",
        ".KGGBBGEEEGGGGGGGGGGGGEEEGBBGDK.",
        ".KGGBBGGHGGGGGGNNGGGGGGGGGBBGDK.",
        ".KGGGGGGGGGGGGGMMGGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGMGGMGGGGGGGGGGGDK.",
        ".KGGGGGGGGGGGGGGGGGGGGGGGGGGGDK.",
        "..KGGGGGGGGGGGGGGGGGGGGGGGGGDKP.",
        "...KGGGGGGGGGGGGGGGGGGGGGGGDK..P",
        "....KKGGGGGGGGGGGGGGGGGGGDKK...P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGWWWWWWWWWWWWGGDK.....P",
        "......KGGGGWWWWWWWWWWGGGDK....PP",
        "......KKKKKKKKKKKKKKKKKKKK...PP.",
        "...........................PPP..",
        "................................",
    ]

    // 32x32 초상 — 위독: 몸 G↔W 반전(창백) + X자 눈(E 3×3) + 처진 귀
    // + 전체 2px 아래로 주저앉음 + 볼터치 제거 + 꼬리는 바닥에 축 늘어짐
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "..KKKK....................KKKK..",
        ".KWWWWK..................KWWWWK.",
        "KWWPPWWKKKKKKKKKKKKKKKKKKWWPPWWK",
        "KWPPPPWKWWWWWWWWWWWWWWWWKWPPPPWK",
        "KWPPPPWKWWWWWWWWWWWWWWWWKWPPPPWK",
        ".KWWWWKWWWWWWWWWWWWWWWWWWKWWWWK.",
        "..KKKKWWWWWWWWWWWWWWWWWWWWKKKK..",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWNNWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWMMWWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWMWWMWWWWWWWWWWWDK.",
        ".KWWWWWWWWWWWWWWWWWWWWWWWWWWWDK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWGGGGGGGGGGGGWWDK......",
        "......KWWWGGGGGGGGGGGGWWDKP.....",
        "......KWWWWGGGGGGGGGGWWWDK.PPP..",
        "......KKKKKKKKKKKKKKKKKKKK..PP..",
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
