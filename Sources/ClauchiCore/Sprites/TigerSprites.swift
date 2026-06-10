import Foundation

// 성체 호랑이 도트 — 스타일 C: 컬러 외곽선 (스펙 §1.2, §8)
// 검은 외곽선 대신 몸색보다 한 톤 진한 다크 오렌지브라운 외곽선 + 주황 몸통.
// 큰 눈(좌상단 1px 흰 하이라이트) + 볼터치 + 머리 비중 큰 치비 비율.
// 실루엣: 둥근 귀 2개 + 이마 가운데 왕(王)자 느낌 줄무늬 + 뺨 양옆 줄무늬(S)
// + 크림 주둥이·가슴 영역이 어떤 상태에서도 호랑이임을 보장한다.
// 줄무늬는 검정이 아닌 웜 다크브라운 S. 음영 D는 광원 좌상단 가정으로 우측/하단에 일관 배치.
enum TigerSprites {
    // 스타일 C — 컬러 외곽선 (스펙 §1.2). 키는 유니코드 이스케이프 표기 관행 유지.
    static let palette: [Character: UInt32] = [
        "\u{4B}": 0xB66A28FF,   // K — 외곽선 (다크 오렌지브라운)
        "\u{4F}": 0xF6A85CFF,   // O — 주황 몸통
        "\u{44}": 0xE08B3DFF,   // D — 음영
        "\u{53}": 0x7A4A1FFF,   // S — 줄무늬 (웜 다크브라운)
        "\u{57}": 0xFBEEDCFF,   // W — 주둥이/배 (크림)
        "\u{42}": 0xF9C0A6FF,   // B — 볼터치
        "\u{4E}": 0xE8836FFF,   // N — 코
        "\u{45}": 0x2E241DFF,   // E — 눈 (다크브라운)
        "\u{48}": 0xFFFFFFFF,   // H — 눈 하이라이트
        "\u{4D}": 0x8A6B57FF,   // M — 입
    ]

    private static func grid(_ rows: [String]) -> PixelGrid {
        PixelGrid(rows: rows, palette: palette)!
    }

    // MARK: - 16x16 소형 프레임

    // 기본 포즈 — 둥근 귀 + 이마 줄무늬(중앙 2px·양옆 1px) + 뺨 줄무늬 + 크림 주둥이·가슴
    static let idle1Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 깜빡임 — 눈 윗줄(하이라이트 포함)을 몸색으로 감춰 반쯤 감은 대비를 만든다
    static let idle2Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSOOOOOOOOOSDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 일하는 중 — 폴짝 1px 점프(전체 1행 위로) + 우상단 땀방울 H
    static let working1Rows = [
        "..KKK......KKK.H",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
        "................",
    ]

    // 일하는 중 — 착지 + 땀방울이 귀 옆으로 이동
    static let working2Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODKH",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 잠 — 눈 감음(가로 E 라인) + 좌상단 z 표시(H)
    static let sleeping1Rows = [
        ".............H..",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSOOOOOOOOOSDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 잠 — 숨쉬기로 몸이 1px 가라앉고 z 표시가 오른쪽 위로 떠오름
    static let sleeping2Rows = [
        "...............H",
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSOOOOOOOOOSDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
    ]

    // 배고픔 — 주둥이 가운데 벌린 입 (M 2px)
    static let hungry1Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWMMWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 배고픔 — 눈을 가늘게 뜨고(윗줄 감춤) 눈가 눈물 1px(H)
    static let hungry2Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSOOOOOOOOOSDK.",
        ".KSEEOOOOOEESDKH",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWMMWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 위독 — 창백 반전(몸 O↔배 W 맞바꿈, 줄무늬 유지) + 볼터치 제거 + 감은 눈
    static let critical1Rows = [
        "................",
        "..KKK......KKK..",
        ".KWWDK....KWWDK.",
        ".KWWWKKKKKKWWDK.",
        ".KWWWWWSSWWWWDK.",
        ".KWWSWWSSWWSWDK.",
        ".KSWWWWWWWWWSDK.",
        ".KSEEWWWWWEESDK.",
        ".KWWWOONNOOWWDK.",
        ".KWWWOOOOOOWWDK.",
        ".KSWOOOOOOOOSDK.",
        ".KWWOOOOOOOOWDK.",
        ".KSWOOOOOOOOSDK.",
        "..KWOOOOOOOODK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // 위독 — 1px 주저앉음
    static let critical2Rows = [
        "................",
        "................",
        "..KKK......KKK..",
        ".KWWDK....KWWDK.",
        ".KWWWKKKKKKWWDK.",
        ".KWWWWWSSWWWWDK.",
        ".KWWSWWSSWWSWDK.",
        ".KSWWWWWWWWWSDK.",
        ".KSEEWWWWWEESDK.",
        ".KWWWOONNOOWWDK.",
        ".KWWWOOOOOOWWDK.",
        ".KSWOOOOOOOOSDK.",
        ".KWWOOOOOOOOWDK.",
        ".KSWOOOOOOOOSDK.",
        "..KWOOOOOOOODK..",
        "...KKKKKKKKKK...",
    ]

    // 휴일 놀기 — 발치 오른쪽의 공 (N 2×2)
    static let playing1Rows = [
        "................",
        "..KKK......KKK..",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDKNN",
        "...KKKKKKKKKK.NN",
        "................",
    ]

    // 휴일 놀기 — 공이 머리 위까지 튀어오름
    static let playing2Rows = [
        "..............NN",
        "..KKK......KKKNN",
        ".KOODK....KOODK.",
        ".KOOOKKKKKKOODK.",
        ".KOOOOOSSOOOODK.",
        ".KOOSOOSSOOSODK.",
        ".KSHEOOOOOHESDK.",
        ".KSEEOOOOOEESDK.",
        ".KBOOWWNNWWOBDK.",
        ".KOOOWWWWWWOODK.",
        ".KSOWWWWWWWWSDK.",
        ".KOOWWWWWWWWODK.",
        ".KSOWWWWWWWWSDK.",
        "..KOWWWWWWWWDK..",
        "...KKKKKKKKKK...",
        "................",
    ]

    // MARK: - 32x32 대형 초상화 (수작업 도트 — 16x16 확대본 아님)

    // 행복 — 둥근 귀(안쪽 음영 D) + 이마 왕(王)자 줄무늬(중앙 3px·양옆 八자 2px)
    // + 큰 눈(HEE/EEE 4행) + 뺨 줄무늬 2단 + 볼터치 2×2 + 크림 주둥이·코 + 활짝 웃는 입
    static let largeHappyRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        ".....KKKK..............KKKK.....",
        "....KOOOOK............KOOOOK....",
        "....KOODDK............KOODDK....",
        "....KOODDK............KOODDK....",
        "....KOOOOK............KOOOOK....",
        "....KOOOOKKKKKKKKKKKKKKOOOOK....",
        "....KOOOOOOOOOOSSOOOOOOOOOOK....",
        "...KOOOOOOOSOOOSSOOOSOOOOOOOK...",
        "..KOOOOOOOSOOOOSSOOOOSOOOOOODK..",
        "..KOOOOOOOOOOOOOOOOOOOOOOOOODK..",
        ".KOOOOOHEEOOOOOOOOOOOOHEEOOOODK.",
        ".KSSOOOEEEOOOOOOOOOOOOEEEOOSSDK.",
        ".KOOOOOEEEOOOOOOOOOOOOEEEOOOODK.",
        ".KSOBBOEEEOOOOOOOOOOOOEEEOBBSDK.",
        ".KOOBBOOOOOWWWWNNWWWWOOOOOBBODK.",
        ".KOOOOOOOOWWWWWWWWWWWWOOOOOOODK.",
        ".KOOOOOOOOWWWWMWWMWWWWOOOOOOODK.",
        ".KOOOOOOOOWWWWWMMWWWWWOOOOOOODK.",
        ".KOOOOOOOOOWWWWWWWWWWOOOOOOOODK.",
        "..KOOOOOOOOOOOOOOOOOOOOOOOOODK..",
        "...KOOOOOOOOOOOOOOOOOOOOOOODK...",
        "....KKOOOOOOOOOOOOOOOOOOODKK....",
        "......KOSOWWWWWWWWWWWWOSDK......",
        "......KOOOWWWWWWWWWWWWOODK......",
        "......KOSOWWWWWWWWWWWWOSDK......",
        "......KOOOOWWWWWWWWWWOOODK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 슬픔 — 귀가 옆으로 처지고(머리는 민머리 돔) + 안쪽이 올라간 눈썹(M)
    // + 왼눈 아래 눈물 1px(H) + 입 ∩ 곡선 + 볼터치·줄무늬 유지
    static let largeSadRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "....KKK..................KKK....",
        "...KOODK................KOODK...",
        "..KOODK..................KOODK..",
        "..KKKK....................KKKK..",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "....KOOOOOOOOOOSSOOOOOOOOOOK....",
        "...KOOOOOOOSOOOSSOOOSOOOOOOOK...",
        "..KOOOOOOOSOOOOSSOOOOSOOOOOODK..",
        "..KOOOOOOMMOOOOOOOOOOMMOOOOODK..",
        ".KOOOOOMMOOOOOOOOOOOOOOMMOOOODK.",
        ".KOOOOOHEEOOOOOOOOOOOOHEEOOOODK.",
        ".KSSOOOEEEOOOOOOOOOOOOEEEOOSSDK.",
        ".KOOOOOEEEOOOOOOOOOOOOEEEOOOODK.",
        ".KSOBBOEEEOOOOOOOOOOOOEEEOBBSDK.",
        ".KOOBBOOHOOWWWWNNWWWWOOOOOBBODK.",
        ".KOOOOOOOOWWWWWWWWWWWWOOOOOOODK.",
        ".KOOOOOOOOWWWWWMMWWWWWOOOOOOODK.",
        ".KOOOOOOOOWWWWMWWMWWWWOOOOOOODK.",
        "..KOOOOOOOOOOOOOOOOOOOOOOOOODK..",
        "...KOOOOOOOOOOOOOOOOOOOOOOODK...",
        "....KKOOOOOOOOOOOOOOOOOOODKK....",
        "......KOSOWWWWWWWWWWWWOSDK......",
        "......KOOOWWWWWWWWWWWWOODK......",
        "......KOSOWWWWWWWWWWWWOSDK......",
        "......KOOOOWWWWWWWWWWOOODK......",
        "......KKKKKKKKKKKKKKKKKKKK......",
        "................................",
    ]

    // 위독 — 몸 O↔W 반전(창백) + X자 눈(3×3) + 귀 완전 처짐 + 볼터치·뺨 줄무늬 제거
    // + 전체 2px 아래로 주저앉음(상단 2행 추가로 비움) + 이마·옆구리 줄무늬는 유지
    static let largeCriticalRows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "....KKK..................KKK....",
        "...KWWDK................KWWDK...",
        "..KWWDK..................KWWDK..",
        "..KKKK....................KKKK..",
        "....KKKKKKKKKKKKKKKKKKKKKKKK....",
        "....KWWWWWWWWWWSSWWWWWWWWWWK....",
        "...KWWWWWWWSWWWSSWWWSWWWWWWWK...",
        "..KWWWWWWWSWWWWSSWWWWSWWWWWWDK..",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWEWWWWWWWWWWWWWWEWWWWWDK.",
        ".KWWWWWEWEWWWWWWWWWWWWEWEWWWWDK.",
        ".KWWWWWWWWWOOOONNOOOOWWWWWWWWDK.",
        ".KWWWWWWWWOOOOOOOOOOOOWWWWWWWDK.",
        ".KWWWWWWWWOOOOOMMOOOOOWWWWWWWDK.",
        ".KWWWWWWWWOOOOMOOMOOOOWWWWWWWDK.",
        ".KWWWWWWWWWOOOOOOOOOOWWWWWWWWDK.",
        "..KWWWWWWWWWWWWWWWWWWWWWWWWWDK..",
        "...KWWWWWWWWWWWWWWWWWWWWWWWDK...",
        "....KKWWWWWWWWWWWWWWWWWWWDKK....",
        "......KWSWOOOOOOOOOOOOWSDK......",
        "......KWWWOOOOOOOOOOOOWWDK......",
        "......KWSWOOOOOOOOOOOOWSDK......",
        "......KWWWWOOOOOOOOOOWWWDK......",
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
