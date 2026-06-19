import AppKit
import SwiftUI
import ClauchiCore

// C형 토스트 — 노치 아래로 등장, 5초 후 자동 닫힘 (스펙 §7).
// 표시 순서는 ToastScheduler(순수)가 결정한다:
//  - 말걸기 응답은 큐에 쌓아 순서대로 전부 보여주고(무시 안 함),
//  - 자동 발화는 최신 하나만 합쳐 쌓이지 않게 한다. 말걸기가 자동보다 우선.
@MainActor
final class ToastPresenter {
    struct Toast: Equatable {
        let text: String
        let expression: ClauchiCore.Expression
        let species: Species
        let stage: Stage
    }

    private var scheduler = ToastScheduler<Toast>()
    private var panel: NotchPanel?
    private var dismissTask: Task<Void, Never>?

    // isUserTalk: 사용자가 직접 건 말걸기의 응답이면 true(큐에 쌓아 모두 표시).
    func enqueue(_ toast: Toast, isUserTalk: Bool = false) {
        if scheduler.enqueue(toast, isTalk: isUserTalk) { showCurrent() }
    }

    // 현재 표시 종료 → 다음(말걸기 큐/대기 자동)으로. 없으면 패널을 닫는다.
    func dismiss() {
        if scheduler.advance() { showCurrent() } else { hide() }
    }

    private func showCurrent() {
        guard let toast = scheduler.current else { hide(); return }
        render(toast)
        scheduleDismiss()
    }

    private func render(_ toast: Toast) {
        if let panel {
            // 이미 떠 있으면 같은 패널의 내용만 교체(패널이 쌓이지 않게)
            if let host = panel.contentView as? NSHostingView<ToastView> {
                host.rootView = makeView(toast)
            } else {
                panel.contentView = NSHostingView(rootView: makeView(toast))
            }
        } else {
            present(toast)
        }
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

    private func hide() {
        dismissTask?.cancel()
        dismissTask = nil
        panel?.orderOut(nil)
        panel = nil
    }
}
