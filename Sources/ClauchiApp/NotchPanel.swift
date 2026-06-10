import AppKit

// 노치 주변에 떠 있는 비활성 패널 — 클릭해도 앱 포커스를 뺏지 않는다 (스펙 §7)
final class NotchPanel: NSPanel {
    init(contentRect: NSRect) {
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered, defer: false)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        isMovable = false
        hidesOnDeactivate = false
    }
    override var canBecomeKey: Bool { false }
}
