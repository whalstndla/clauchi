import CoreGraphics

// 알약 프레임 계산 — 순수 함수. 앱은 NSScreen 측정값만 넘긴다 (스펙 §7)
public enum NotchLayout {
    public struct PillMetrics: Equatable, Sendable {
        public let frame: CGRect       // AppKit 좌표 (origin 좌하단)
        public let notchWidth: CGFloat
        public let wingWidth: CGFloat
    }

    public static func pillMetrics(screenFrame: CGRect, notchWidth: CGFloat,
                                   barHeight: CGFloat, wingWidth: CGFloat,
                                   hoverExpansion: CGFloat = 0) -> PillMetrics {
        let effectiveNotch = notchWidth > 0 ? notchWidth : 180   // 노치 없는 화면: 가상 알약
        let effectiveWing = wingWidth + hoverExpansion
        let width = effectiveNotch + effectiveWing * 2
        return PillMetrics(
            frame: CGRect(x: screenFrame.midX - width / 2,
                          y: screenFrame.maxY - barHeight,
                          width: width, height: barHeight),
            notchWidth: effectiveNotch, wingWidth: effectiveWing)
    }
}
