import SwiftUI

// 비활성 패널(canBecomeKey = false)에서는 시스템 버튼/토글이 항상 회색으로
// 렌더링돼 상태 구분이 불가능하다 — 창 상태와 무관하게 직접 그리는 컨트롤 사용

// 켜짐/꺼짐 칩 (휴식 요일용)
struct SettingChip: View {
    let label: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(isOn ? .bold : .regular)
                .foregroundStyle(isOn ? .black : .white)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isOn ? Color.green : Color(white: 0.22)))
        }
        .buttonStyle(.plain)
    }
}

// 커스텀 스위치 행
struct SettingSwitchRow: View {
    let label: String
    let isOn: Bool
    let action: (Bool) -> Void

    var body: some View {
        HStack {
            Text(label).font(.caption).foregroundStyle(.white)
            Spacer()
            Capsule()
                .fill(isOn ? Color.green : Color(white: 0.25))
                .frame(width: 36, height: 20)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 16, height: 16)
                        .offset(x: isOn ? 8 : -8))
                .animation(.easeInOut(duration: 0.15), value: isOn)
        }
        .contentShape(Rectangle())
        .onTapGesture { action(!isOn) }
    }
}
