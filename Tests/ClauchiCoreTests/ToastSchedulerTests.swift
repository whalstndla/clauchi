import Foundation
import Testing
@testable import ClauchiCore

// 토스트 표시 순서 — 말걸기는 전부 순서대로, 자동은 최신 하나만, 말걸기 우선
// (mutating 메서드는 #expect 매크로 밖에서 호출하고 결과만 검증한다)

@Test func talkMessagesAllShownInOrder() {
    var scheduler = ToastScheduler<String>()
    let shown = scheduler.enqueue("안녕", isTalk: true)      // 첫 말걸기 즉시 표시
    #expect(shown)
    #expect(scheduler.current == "안녕")
    // 표시 중 추가 말걸기는 큐에 쌓임(즉시 표시 변화 없음)
    let q1 = scheduler.enqueue("뭐해", isTalk: true)
    let q2 = scheduler.enqueue("배고파?", isTalk: true)
    #expect(q1 == false)
    #expect(q2 == false)
    #expect(scheduler.current == "안녕")
    // 종료할 때마다 다음 말걸기로 — 무시 없이 순서대로
    let a1 = scheduler.advance(); #expect(a1); #expect(scheduler.current == "뭐해")
    let a2 = scheduler.advance(); #expect(a2); #expect(scheduler.current == "배고파?")
    let a3 = scheduler.advance(); #expect(a3 == false); #expect(scheduler.current == nil)
}

@Test func autoMessagesCoalesceToLatest() {
    var scheduler = ToastScheduler<String>()
    let s1 = scheduler.enqueue("자동1", isTalk: false); #expect(s1)
    #expect(scheduler.current == "자동1")
    // 자동 표시 중 새 자동 → 최신으로 교체(쌓이지 않음)
    let s2 = scheduler.enqueue("자동2", isTalk: false); #expect(s2)
    #expect(scheduler.current == "자동2")
    let s3 = scheduler.enqueue("자동3", isTalk: false); #expect(s3)
    #expect(scheduler.current == "자동3")
    let done = scheduler.advance(); #expect(done == false)   // 중간 자동은 버려졌으므로 더 없음
}

@Test func talkInterruptsAuto() {
    var scheduler = ToastScheduler<String>()
    _ = scheduler.enqueue("잡담", isTalk: false)
    #expect(scheduler.current == "잡담")
    // 자동 표시 중 말걸기가 오면 즉시 말걸기로 교체
    let shown = scheduler.enqueue("질문", isTalk: true)
    #expect(shown)
    #expect(scheduler.current == "질문")
    #expect(scheduler.currentIsTalk)
}

@Test func autoWaitsBehindTalk() {
    var scheduler = ToastScheduler<String>()
    _ = scheduler.enqueue("질문", isTalk: true)
    #expect(scheduler.current == "질문")
    // 말걸기 표시 중 자동은 대기(즉시 표시 변화 없음)
    let held = scheduler.enqueue("잡담", isTalk: false)
    #expect(held == false)
    #expect(scheduler.current == "질문")
    // 말걸기 끝나면 대기하던 자동이 나옴
    let next = scheduler.advance()
    #expect(next)
    #expect(scheduler.current == "잡담")
    #expect(scheduler.currentIsTalk == false)
}

@Test func talkDrainsBeforePendingAuto() {
    var scheduler = ToastScheduler<String>()
    _ = scheduler.enqueue("말1", isTalk: true)
    _ = scheduler.enqueue("말2", isTalk: true)
    _ = scheduler.enqueue("자동", isTalk: false)   // 말걸기 뒤에서 대기
    #expect(scheduler.current == "말1")
    let a1 = scheduler.advance(); #expect(a1); #expect(scheduler.current == "말2")
    let a2 = scheduler.advance(); #expect(a2); #expect(scheduler.current == "자동")
    let a3 = scheduler.advance(); #expect(a3 == false)
}
