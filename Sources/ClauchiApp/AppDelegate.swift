import AppKit
import SwiftUI
import ClauchiCore

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private(set) var model: AppModel!
    private var pillPanel: NotchPanel!
    private var expandedPanel: NotchPanel?   // Task 20

    func applicationDidFinishLaunching(_ notification: Notification) {
        model = AppModel()
        setupPillPanel()
        NotificationCenter.default.addObserver(
            forName: .clauchiHoverChanged, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.updatePillFrame() }
        }
        NotificationCenter.default.addObserver(
            forName: .clauchiPanelToggled, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.toggleExpandedPanel() }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        model.saveNow()
    }

    private func setupPillPanel() {
        let metrics = Self.pillMetrics(hovering: false)
        pillPanel = NotchPanel(contentRect: metrics.frame)
        pillPanel.contentView = NSHostingView(rootView: PillView(model: model))
        pillPanel.orderFrontRegardless()
    }

    private func updatePillFrame() {
        let metrics = Self.pillMetrics(hovering: model.isHovering)
        pillPanel.setFrame(metrics.frame, display: true, animate: true)
    }

    private func toggleExpandedPanel() {
        if model.isPanelOpen {
            let screen = Self.targetScreen()
            let barHeight = screen.safeAreaInsets.top > 0 ? screen.safeAreaInsets.top : 32
            let width: CGFloat = 340, height: CGFloat = 420
            let frame = NSRect(x: screen.frame.midX - width / 2,
                               y: screen.frame.maxY - barHeight - height,
                               width: width, height: height)
            let panel = NotchPanel(contentRect: frame)
            panel.contentView = NSHostingView(rootView: ExpandedPanelView(model: model))
            panel.orderFrontRegardless()
            expandedPanel = panel
        } else {
            expandedPanel?.orderOut(nil)
            expandedPanel = nil
        }
    }

    // 내장 노치 디스플레이 우선, 없으면 메인 화면 (스펙 §7)
    static func targetScreen() -> NSScreen {
        NSScreen.screens.first { $0.safeAreaInsets.top > 0 }
            ?? NSScreen.main ?? NSScreen.screens[0]
    }

    static func pillMetrics(hovering: Bool) -> NotchLayout.PillMetrics {
        let screen = targetScreen()
        let safeTop = screen.safeAreaInsets.top
        var notchWidth: CGFloat = 0
        if safeTop > 0 {
            let leftArea = screen.auxiliaryTopLeftArea
            let rightArea = screen.auxiliaryTopRightArea
            if let leftArea, let rightArea {
                notchWidth = screen.frame.width - leftArea.width - rightArea.width
            }
        }
        return NotchLayout.pillMetrics(
            screenFrame: screen.frame, notchWidth: notchWidth,
            barHeight: safeTop > 0 ? safeTop : 32, wingWidth: 56,
            hoverExpansion: hovering ? 44 : 0)
    }
}
