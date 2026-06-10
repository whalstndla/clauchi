import CoreGraphics
import Testing
@testable import ClauchiCore

@Test func pillIsCenteredAtTopOfScreen() {
    let metrics = NotchLayout.pillMetrics(
        screenFrame: CGRect(x: 0, y: 0, width: 1512, height: 982),
        notchWidth: 200, barHeight: 37, wingWidth: 56)
    #expect(metrics.frame.width == CGFloat(200 + 56 * 2))
    #expect(metrics.frame.midX == CGFloat(756))
    #expect(metrics.frame.maxY == CGFloat(982))
    #expect(metrics.frame.height == CGFloat(37))
}

@Test func hoverExpansionWidensWings() {
    let base = NotchLayout.pillMetrics(
        screenFrame: CGRect(x: 0, y: 0, width: 1512, height: 982),
        notchWidth: 200, barHeight: 37, wingWidth: 56)
    let hovered = NotchLayout.pillMetrics(
        screenFrame: CGRect(x: 0, y: 0, width: 1512, height: 982),
        notchWidth: 200, barHeight: 37, wingWidth: 56, hoverExpansion: 44)
    #expect(hovered.frame.width == base.frame.width + CGFloat(88))
    #expect(hovered.frame.midX == base.frame.midX)
}

@Test func noNotchScreenGetsVirtualPill() {
    let metrics = NotchLayout.pillMetrics(
        screenFrame: CGRect(x: 0, y: 0, width: 2560, height: 1440),
        notchWidth: 0, barHeight: 32, wingWidth: 56)
    #expect(metrics.notchWidth == CGFloat(180))   // 가상 노치 폭
    #expect(metrics.frame.midX == CGFloat(1280))
}

@Test func engineEventLogOffsetIsSettable() {
    let engine = TestSupport.makeEngine()
    engine.setEventLogOffset(4096)
    #expect(engine.state.eventLogOffset == 4096)
}
