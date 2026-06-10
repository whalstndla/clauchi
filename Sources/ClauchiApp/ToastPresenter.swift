import AppKit
import SwiftUI
import ClauchiCore

// C형 토스트 — 노치 아래로 등장, 5초 후 자동 닫힘, 한 번에 하나 (스펙 §7)
@MainActor
final class ToastPresenter {
    struct Toast: Equatable {
        let text: String
        let expression: ClauchiCore.Expression
        let species: Species
        let stage: Stage
    }

    private var queue: [Toast] = []
    private var panel: NotchPanel?
    private var current: Toast?
    private var dismissTask: Task<Void, Never>?

    func enqueue(_ toast: Toast) {
        queue.append(toast)
        showNextIfIdle()
    }

    private func showNextIfIdle() {
        guard current == nil, let toast = queue.first else { return }
        queue.removeFirst()
        current = toast

        let screen = AppDelegate.targetScreen()
        let barHeight = screen.safeAreaInsets.top > 0 ? screen.safeAreaInsets.top : 32
        let width: CGFloat = 320, height: CGFloat = 88
        let frame = NSRect(x: screen.frame.midX - width / 2,
                           y: screen.frame.maxY - barHeight - height,
                           width: width, height: height)
        let toastPanel = NotchPanel(contentRect: frame)
        toastPanel.contentView = NSHostingView(
            rootView: ToastView(toast: toast) { [weak self] in self?.dismiss() })
        toastPanel.orderFrontRegardless()
        panel = toastPanel

        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(5))
            if !Task.isCancelled { self?.dismiss() }
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil
        panel?.orderOut(nil)
        panel = nil
        current = nil
        showNextIfIdle()
    }
}
