import AppKit
import SwiftUI
import ClauchiCore

// C형 토스트 — 노치 아래로 등장, 5초 후 자동 닫힘.
// 응답이 한꺼번에 쌓여도 전부 순차 노출하지 않고 '최신 한마디' 하나만 보여준다(스펙 §7).
@MainActor
final class ToastPresenter {
    struct Toast: Equatable {
        let text: String
        let expression: ClauchiCore.Expression
        let species: Species
        let stage: Stage
    }

    private var panel: NotchPanel?
    private var current: Toast?
    private var dismissTask: Task<Void, Never>?

    // 항상 최신 토스트로 갱신한다. 이미 떠 있으면 쌓인 이전 응답은 버리고
    // 내용만 교체해(깜빡임 없이) 표시 시간을 리셋한다.
    func enqueue(_ toast: Toast) {
        // 같은 내용이 또 오면 표시 시간만 연장
        guard toast != current else { scheduleDismiss(); return }
        current = toast
        if let panel {
            // 이미 떠 있으면 같은 패널의 내용만 교체(패널이 쌓이지 않게).
            // rootView 갱신이 가능하면 깜빡임 없이, 아니면 contentView를 교체.
            if let host = panel.contentView as? NSHostingView<ToastView> {
                host.rootView = makeView(toast)
            } else {
                panel.contentView = NSHostingView(rootView: makeView(toast))
            }
        } else {
            present(toast)
        }
        scheduleDismiss()
    }

    private func makeView(_ toast: Toast) -> ToastView {
        ToastView(toast: toast) { [weak self] in self?.dismiss() }
    }

    private func present(_ toast: Toast) {
        let screen = AppDelegate.targetScreen()
        let barHeight = screen.safeAreaInsets.top > 0 ? screen.safeAreaInsets.top : 32
        let width: CGFloat = 320, height: CGFloat = 88
        let frame = NSRect(x: screen.frame.midX - width / 2,
                           y: screen.frame.maxY - barHeight - height,
                           width: width, height: height)
        let toastPanel = NotchPanel(contentRect: frame)
        toastPanel.contentView = NSHostingView(rootView: makeView(toast))
        toastPanel.orderFrontRegardless()
        panel = toastPanel
    }

    private func scheduleDismiss() {
        dismissTask?.cancel()
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
    }
}
