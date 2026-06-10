import Foundation

// 성체 양 도트 (스펙 §8) — 양순이 (.goat)
// 실루엣: 머리 위 두 개의 작은 뿔 + 구불구불한 흰 털 몸통 + 양옆으로 처진 귀 + 귀여운 눈
enum GoatSprites {
    // 팔레트 키는 유니코드 이스케이프로 표기 — 도트 행 문자열 검증 스크립트와의 충돌 방지
    // K(0x4B)=외곽선, W(0x57)=흰털 몸통, S(0x53)=회베이지 음영,
    // H(0x48)=회색 뿔, P(0x50)=분홍 코/귀, E(0x45)=눈
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0x1C1917FF,   // K — 외곽선
        "\u{57}": 0xF5F5F4FF,   // W — 흰털 몸통 (아이보리/흰)
        "\u{53}": 0xD6D3D1FF,   // S — 회베이지 음영
        "\u{48}": 0xA8A29EFF,   // H — 회색 뿔
        "\u{50}": 0xFBB6CEFF,   // P — 분홍 코/귀
        "\u{45}": 0x1C1917FF,   // E — 눈
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16×16 소형 프레임

    // 기본 포즈 — 뿔 + 처진 귀 + 구불구불한 털 몸통 + 귀여운 눈 + 분홍 코
    static let idle1Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 깜빡임 — 눈 감음
    static let idle2Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWWSWWSWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 일하는 중 — 1px 폴짝 + 땀방울 (S 하이라이트 + P 방울)
    static let working1Rows = [
        "....HH....HH..P.",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울 위치 이동
    static let working2Rows = [
        "................",
        "....HH....HH....",
        "....KHKKKKHK..P.",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
    ]

    // 잠 — 눈 감고 오른쪽 위에 W 픽셀 (zzz 표시)
    static let sleeping1Rows = [
        "....HH....HH..W.",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWWSWWSWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 잠 — zzz 위로 떠오름
    static let sleeping2Rows = [
        "..............W.",
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWWSWWSWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
    ]

    // 배고픔 — 벌린 입 (P)
    static let hungry1Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWPWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 배고픔 — 벌린 입 + 눈물
    static let hungry2Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK.W.",
        "...KWWWPWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 (흰 몸이라 W↔S 반전: 몸통=S 진회베이지, 음영부=W 창백)
    static let critical1Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KSSSSSSSSK...",
        "K..KSPSSSSPSK..K",
        "...KSSSSSSSSK...",
        "...KSSESWWEWK...",
        "...KSSSKSSSK....",
        "...KWWSSSSSWK...",
        "...KSSSSSSSK....",
        "..KWSSSSSSSSWSK.",
        "..KSWWWSSWWWK...",
        "..KSSSSSSSSWSK..",
        "..KSSSSSSSSSSK..",
        "...KWWWSWWWWKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 위독 — 창백 + 주저앉음 (1px 아래로)
    static let critical2Rows = [
        "................",
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KSSSSSSSSK...",
        "K..KSPSSSSPSK..K",
        "...KSSSSSSSSK...",
        "...KSSESWWEWK...",
        "...KSSSKSSSK....",
        "...KWWSSSSSWK...",
        "...KSSSSSSSK....",
        "..KWSSSSSSSSKW..",
        "..KSWWWSSWWWK...",
        "..KSSSSSSSSWSK..",
        "..KSSSSSSSSSSK..",
        "...KWWWSWWWWKK..",
        "....KKKKKKKK....",
    ]

    // 휴일 놀기 — 옆에 꽃 (P 2×2)
    static let playing1Rows = [
        "....HH....HH....",
        "....KHKKKKHK....",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK.P",
        "..KWSSSWWSSSKK.P",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // 휴일 놀기 — 꽃이 위로 올라감
    static let playing2Rows = [
        "....HH....HH..PP",
        "....KHKKKKHK..PP",
        "...KWWWWWWWWK...",
        "K..KWPWWWWPWK..K",
        "...KWWWWWWWWK...",
        "...KWWESWWEWK...",
        "...KWWWKWWWWK...",
        "...KSSWWWWWSK...",
        "...KWWWWWWWWK...",
        "..KSWWWWWWWWSK..",
        "..KWSSSWWSSSKK..",
        "..KWWWWWWWWWSK..",
        "..KWWWWWWWWWWK..",
        "...KSSSWSSSSKK..",
        "....KKKKKKKK....",
        "................",
    ]

    // MARK: - 32×32 대형 초상화 (수작업 — 음영 S, 분홍 귀/코 P, 뿔 H, 표정 차등)

    // 행복 — 쫑긋 선 귀 양쪽 처짐, 뜬 눈, 위로 휘어진 미소, 구불 털 몸통 오른쪽 음영 S
    static let largeHappyRows = [
        "................................",
        "........HH........HH............",
        ".......KHHK......KHHK...........",
        "......KHHHK......KHHHK..........",
        "K......KHHK......KHHK.........K.",
        "K......KHKKKKKKKKKKHK.........K.",
        ".....KWWWWWWWWWWWWWWWWK.........",
        "....KWWWWWWWWWWWWWWWWWWK........",
        "...KWPPWWWWWWWWWWWWWWPPWK.......",
        "...KWWWWWWWWWWWWWWWWWWWWK.......",
        "...KWWWWWWWWWWWWWWWWWWWSK.......",
        "...KWWWEEEWWWWWWWWEEEWWWSK......",
        "...KWWWWEEWWWWWWWWEEWWWWSK......",
        "...KWWWWWWWWWWWWWWWWWWWSK.......",
        "...KWWWWWWWWPWWWWWWWWWWSK.......",
        "...KWWWWWWKWWWWWWKWWWWWSK.......",
        "...KWWWWWWWKKWWKKWWWWWWSK.......",
        "...KWWWWWWWWWWWWWWWWWWWSK.......",
        "....KWWWWWWWWWWWWWWWWWSK........",
        "...KWWWWSSSSSSSSSSSSSWWWSK......",
        "..KWWWWSSSSSSSSSSSSSSSWWWSK.....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSK.....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSSK....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSSK....",
        "...KWWWWSSSSSSSSSSSSWWWWSSK.....",
        "....KWWWWSSSSSSSSSWWWWWSSK......",
        ".....KWWWWWWWWWWWWWWWSSK........",
        "......KSSSSSSSSSSSSSSSK.........",
        ".......KKSSSSKKKKKSSSSKK........",
        "..........KKKK....KKKK..........",
        "................................",
        "................................",
    ]

    // 슬픔 — 귀가 아래로 더 처짐, 눈물, 아래로 휘어진 입
    static let largeSadRows = [
        "................................",
        "................................",
        "K.......HH........HH...........K",
        "K......KHHK......KHHK..........K",
        ".....KKHHHKK....KKHHKKK.........",
        "....KKHHHHHKK..KKHHHHHHK........",
        "....KKHHHKKKK..KKKHHHKK.........",
        ".....KKKWWWWWWWWWWWWWKK.........",
        "....KWWWWWWWWWWWWWWWWWWK........",
        "...KWPPWWWWWWWWWWWWWWPPWK.......",
        "...KWWWWWWWWWWWWWWWWWWWWK.......",
        "...KWWWWWWWWWWWWWWWWWWWSK.......",
        "...KWWWEEEWWWWWWWWEEEWWWSK......",
        "...KWWWWEEWWWWWWWWEEWWWWSK.W....",
        "...KWWWWWWWWWWWWWWWWWWWSK.......",
        "...KWWWWWWKKWWWWKKWWWWWSK.......",
        "...KWWWWWWWKWWWWKWWWWWWSK.......",
        "...KWWWWWWWWPWWWWWWWWWWSK.......",
        "....KWWWWWWWWWWWWWWWWWSK........",
        "...KWWWWSSSSSSSSSSSSSWWWSK......",
        "..KWWWWSSSSSSSSSSSSSSSWWWSK.....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSK.....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSSK....",
        "..KWWWWSSSSSSSSSSSSSSSWWWSSK....",
        "...KWWWWSSSSSSSSSSSSWWWWSSK.....",
        "....KWWWWSSSSSSSSSWWWWWSSK......",
        ".....KWWWWWWWWWWWWWWWSSK........",
        "......KSSSSSSSSSSSSSSSK.........",
        ".......KKSSSSKKKKKSSSSKK........",
        "..........KKKK....KKKK..........",
        "................................",
        "................................",
    ]

    // 위독 — 창백한 몸 (S↔W 반전), X자 눈, 일자로 다문 입, 음영은 W로 연하게
    static let largeCriticalRows = [
        "................................",
        "........HH........HH............",
        ".......KHHK......KHHK...........",
        "......KHHHK......KHHHK..........",
        "K......KHHK......KHHK.........K.",
        "K......KHKKKKKKKKKKHK.........K.",
        ".....KSSSSSSSSSSSSSSSSK.........",
        "....KSSSSSSSSSSSSSSSSSSSK.......",
        "...KSPPSSSSSSSSSSSSSSSPPSK......",
        "...KSSSSSSSSSSSSSSSSSSSSSK......",
        "...KSSSSSSSSSSSSSSSSSSSSSK......",
        "...KSSSSESESSSSSSSSSESESSK......",
        "...KSSSSSESSSSSSSSSSSESSK.......",
        "...KSSSSSSSSSSSSSSSSSSSSSK......",
        "...KSSSSSSSSSSSSSSSSSSSSSK......",
        "...KSSSSSSSSKSSSSKSSSSSSWK......",
        "...KSSSSSSSSSSSSSSSSSSSWWK......",
        "...KSSSSSSSSSSSSSSSSSSSWWK......",
        "....KSSSSSSSSSSSSSSSSSWWK.......",
        "...KSSSSSWWWWWWWWWWWWSSSSK......",
        "..KSSSSSWWWWWWWWWWWWWWSSSK......",
        "..KSSSSSWWWWWWWWWWWWWWSSSK......",
        "..KSSSSSWWWWWWWWWWWWWWSSSSK.....",
        "..KSSSSSWWWWWWWWWWWWWWSSSSK.....",
        "...KSSSSSWWWWWWWWWWWSSSSSK......",
        "....KSSSSSWWWWWWWWWSSSSSSK......",
        ".....KSSSSSSSSSSSSSSSSSK........",
        "......KWWWWWWWWWWWWWWWK.........",
        ".......KKWWWWKKKKKWWWWK.........",
        "..........KKKK....KKKK..........",
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
