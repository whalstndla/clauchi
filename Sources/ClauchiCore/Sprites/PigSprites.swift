import Foundation

// 성체 돼지 도트 (스펙 §8)
// 실루엣: 머리 양옆 작고 둥근 귀 + 동그란 코(콧구멍 2개) + 통통한 직립 치비 몸통, 분홍 계열
enum PigSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, P(0x50)=분홍 몸통, D(0x44)=진분홍 음영,
    // W(0x57)=밝은 배/창백, N(0x4E)=코 포인트 컬러, E(0x45)=눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{50}": 0xFDA4AFFF,   // P — 분홍 몸통
        "\u{44}": 0xFB7185FF,   // D — 진분홍 음영
        "\u{57}": 0xFEF3E2FF,   // W — 밝은 배/창백
        "\u{4E}": 0xF472B6FF,   // N — 코(콧구멍) 포인트
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 작은 귀 + 동그란 코(콧구멍 2개) + 통통한 몸
    static let idle1Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPPPPPPPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 땀방울 (우상단 N 방울)
    static let working1Rows = [
        "...KKK..KKK..N..",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 낙하
    static let working2Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK..N.",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 잠 — 눈 감고 우상단 zzz (W 도트)
    static let sleeping1Rows = [
        ".............W..",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPPPPPPPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        "................",
        "...KKK..KKK..W..",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPPPPPPPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 배고픔 — 벌린 입 (N 픽셀)
    static let hungry1Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPNNPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물 (W 눈물방울)
    static let hungry2Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK.W",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPNNPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 위독 — 창백 (몸통 P↔W 반전, 음영 D→P, 배 W→P)
    static let critical1Rows = [
        "................",
        "...KKK..KKK.....",
        "..KWWWKKWWWK....",
        "..KWPWKKWPWK....",
        "...KWWWWWWWK....",
        "..KWWWWWWWWWK...",
        "..KWWEWWWEWWWK..",
        "..KWWWWWWWWWK...",
        "..KWWKNNKWWPK...",
        "..KWWWWWWWWWK...",
        "..KWPPPPPPPWK...",
        "..KWPPPPPPPWK...",
        "...KWWWWWWWWK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1행 아래로)
    static let critical2Rows = [
        "................",
        "................",
        "...KKK..KKK.....",
        "..KWWWKKWWWK....",
        "..KWPWKKWPWK....",
        "...KWWWWWWWK....",
        "..KWWWWWWWWWK...",
        "..KWWEWWWEWWWK..",
        "..KWWWWWWWWWK...",
        "..KWWKNNKWWPK...",
        "..KWWWWWWWWWK...",
        "..KWPPPPPPPWK...",
        "..KWPPPPPPPWK...",
        "...KWWWWWWWWK...",
        "....KKKKKKKK....",
        "................",
    ]

    // 휴일 놀기 — 풍선 (N 색 2×2, 오른쪽 아래)
    static let playing1Rows = [
        "................",
        "...KKK..KKK.....",
        "..KPPPKKPPPK....",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK.NN",
        "..KPWWWWWWPPK.NN",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // 휴일 놀기 — 풍선이 위로 올라감
    static let playing2Rows = [
        "................",
        "...KKK..KKK..NN.",
        "..KPPPKKPPPK.NN.",
        "..KPDPKKPDPK....",
        "...KPPPPPPPK....",
        "..KPPPPPPPPPK...",
        "..KPPEPPPEPPPK..",
        "..KPPPPPPPPPK...",
        "..KPPKNNKPPDK...",
        "..KPPPPPPPPPK...",
        "..KPWWWWWWPPK...",
        "..KPWWWWWWPPK...",
        "...KPPPPPPPPK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ]

    // MARK: - 32×32 대형 초상화 (수작업 — 음영 D, 표정 차등)

    // 행복 — 쫑긋 선 귀, 뜬 눈, 위로 휘어진 미소, 통통한 몸 오른쪽 D 음영
    static let largeHappyRows = [
        "................................",
        "....KKKK..............KKKK......",
        "...KPPPK..............KPPPK.....",
        "...KPDPK..............KPDPK.....",
        "...KPPPKKKKKKKKKKKKKKKPPPK......",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPK....",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPK...",
        "..KPPEPPPPPPPPPPPPPPPPPPEPPPK...",
        "..KPPEPPPPPPPPPPPPPPPPPPEPPPK...",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDK..",
        "..KPPPPKNNKPPPPPPPPPPKNNKPPPDDK.",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDK..",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPDDK..",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPDDK..",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPDDK..",
        "..KPPPPPPWWWWWWWWWWWWWWPPPPDDK..",
        "..KPPPPPWWWWWWWWWWWWWWWWPPPDDK..",
        "..KPPPPPWWWWWWWWWWWWWWWWPPPDDK..",
        "..KPPPPPWWWWWKKKKWWWWWWWPPPDDK..",
        "..KPPPPPPWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDDK.",
        "...KPPPPPPPPPPPPPPPPPPPPPPPPDDK.",
        "..KPPPPWWWWWWWWWWWWWWWWWPPPDDK..",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "...KPPPPWWWWWWWWWWWWWWPPPPDDKK..",
        "....KKKKKKKKKKKKKKKKKKKKKKKKK...",
        ".....KKKK..........KKKK.........",
        "......KKKK..........KKKK........",
        "................................",
        "................................",
    ]

    // 슬픔 — 처진 귀(바깥으로 늘어짐), 아래로 굽은 입
    static let largeSadRows = [
        "................................",
        "................................",
        "...KKKK..............KKKK.......",
        "..KPPPK..............KPPPK......",
        "..KPDPK..............KPDPK......",
        "...KPPPKKKKKKKKKKKKKKKPPPK......",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPK....",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPK...",
        "..KPPEPPPPPPPPPPPPPPPPPPEPPPK...",
        "..KPPEPPPPPPPPPPPPPPPPPPEPPPK...",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDK..",
        "..KPPPPKNNKPPPPPPPPPPKNNKPPPDDK.",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDK..",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPDDK..",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPDDK..",
        "..KPPPPPPWWWWWWWWWWWWWWPPPPDDK..",
        "..KPPPPPWWWWWWWWWWWWWWWWPPPDDK..",
        "..KPPPPPWWWWKKKKWWWWWWWWPPPDDK..",
        "..KPPPPPWWWKWWWWKWWWWWWWPPPDDK..",
        "..KPPPPPPWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPPPPPPPPPPPPPPPPPPPPPPPDDKK",
        "...KPPPPPPPPPPPPPPPPPPPPPPPPDDKK",
        "..KPPPPWWWWWWWWWWWWWWWWWPPPDDK..",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "..KPPPWWWWWWWWWWWWWWWWWWPPPDDKK.",
        "...KPPPPWWWWWWWWWWWWWWPPPPDDKK..",
        "....KKKKKKKKKKKKKKKKKKKKKKKKK...",
        ".....KKKK..........KKKK.........",
        "......KKKK..........KKKK........",
        "................................",
        "................................",
    ]

    // 위독 — X자 눈 + 창백한 몸 (몸통 P↔W 반전), 힘없는 일자 입
    static let largeCriticalRows = [
        "................................",
        "....KKKK..............KKKK......",
        "...KWWWK..............KWWWK.....",
        "...KNWWK..............KWWNK.....",
        "...KWWWKKKKKKKKKKKKKKKWWWK......",
        "..KWWWWWWWWWWWWWWWWWWWWWWWK.....",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWK....",
        "..KWWEWEWWWWWWWWWWWWWWWWEWEWK...",
        "..KWWWEWWWWWWWWWWWWWWWWWWEWWWK..",
        "..KWWEWEWWWWWWWWWWWWWWWWEWEWWK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWNK..",
        "..KWWWWKNNKWWWWWWWWWWKNNKWWWNK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWNK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWNK..",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWNK..",
        "..KWWWWWWPPPPPPPPPPPPPPWWWWWWPK.",
        "..KWWWWWPPPPPPPPPPPPPPPWWWWWPPK.",
        "..KWWWWWPPPPPPPPPPPPPPPWWWWWPPK.",
        "..KWWWWWPPPPPKKKKPPPPPPPWWWWPPK.",
        "..KWWWWWWPPPPPPPPPPPPPPPWWWWPPK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWPK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWWPK..",
        "..KWWWWPPPPPPPPPPPPPPPPPPWWWPK..",
        "..KWWWPPPPPPPPPPPPPPPPPPPPWWPPK.",
        "..KWWWPPPPPPPPPPPPPPPPPPPPWWPPK.",
        "..KWWWPPPPPPPPPPPPPPPPPPPPWWPPK.",
        "...KWWWWPPPPPPPPPPPPPPPWWWWPPK..",
        "....KKKKKKKKKKKKKKKKKKKKKKKKK...",
        ".....KKKK..........KKKK.........",
        "......KKKK..........KKKK........",
        "................................",
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
