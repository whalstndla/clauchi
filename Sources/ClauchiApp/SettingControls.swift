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

// 접이식(아코디언) 섹션 — 설정 항목이 많아 정신없는 걸 카테고리로 묶어 한 번에 하나만 펼친다.
// 시스템 DisclosureGroup은 비활성 패널에서 회색으로 뭉개지므로 헤더를 직접 그린다.
struct AccordionSection<Content: View>: View {
    let title: String
    let isOpen: Bool
    let onToggle: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onToggle) {
                HStack {
                    Text(title)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.gray)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if isOpen {
                VStack(alignment: .leading, spacing: 10) { content() }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.13)))
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
