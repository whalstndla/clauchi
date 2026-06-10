import Foundation

// 디버그 시간 빨리감기용 시계 — 엔진엔 항상 now() 결과만 넘긴다
final class AppClock {
    private(set) var debugOffset: TimeInterval = 0
    func now() -> Date { Date().addingTimeInterval(debugOffset) }
    func fastForward(_ seconds: TimeInterval) { debugOffset += seconds }
}
