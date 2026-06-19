import Foundation

// 토스트 표시 순서 정책(순수 상태머신) — UI(패널)와 분리해 테스트 가능하게 둔다.
//
// - 말걸기 응답(isTalk: true): 큐에 쌓아 순서대로 "전부" 보여준다 → 무시당하지 않음.
// - 자동 발화(isTalk: false): 최신 하나만 유지(pendingAuto) → 백로그·잡담이 쌓이지 않음.
// - 우선순위: 말걸기 > 자동. 자동 표시 중 말걸기가 오면 즉시 교체하고,
//   말걸기 표시 중 자동이 오면 말걸기 큐가 빌 때까지 대기한다.
//
// enqueue/advance는 "표시를 바꿔야 하는가"를 Bool로 돌려준다(true면 호출부가 current를 렌더).
public struct ToastScheduler<Item> {
    private var talkQueue: [Item] = []
    private var pendingAuto: Item?
    public private(set) var current: Item?
    public private(set) var currentIsTalk = false

    public init() {}

    // 새 토스트 추가. 표시 변화가 필요하면 true(호출부가 current를 렌더).
    public mutating func enqueue(_ item: Item, isTalk: Bool) -> Bool {
        if isTalk {
            talkQueue.append(item)
            // 비어있거나 자동 발화를 보여주는 중이면 말걸기로 즉시 전환
            if current == nil || !currentIsTalk { return advance() }
            return false
        }
        pendingAuto = item
        // 말걸기 표시 중이면 대기, 그 외(빈 화면/자동)면 최신 자동으로 갱신
        if current == nil || !currentIsTalk { return advance() }
        return false
    }

    // 현재 토스트 종료 → 다음으로 진행. 표시할 게 있으면 true(current 갱신), 없으면 false(숨김).
    @discardableResult
    public mutating func advance() -> Bool {
        if !talkQueue.isEmpty {
            current = talkQueue.removeFirst()
            currentIsTalk = true
            return true
        }
        if let auto = pendingAuto {
            pendingAuto = nil
            current = auto
            currentIsTalk = false
            return true
        }
        current = nil
        currentIsTalk = false
        return false
    }
}
