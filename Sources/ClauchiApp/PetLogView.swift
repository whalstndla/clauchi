import SwiftUI
import ClauchiCore

// 펫 일지 모달 — 노치 패널 내 오버레이. 스크롤은 패널 외부 ScrollView가 담당.
struct PetLogView: View {
    @Bindable var model: AppModel
    let onClose: () -> Void

    var body: some View {
        // 최신 기록이 위로 오게 역순
        let entries = Array(model.engine.state.petLog.reversed())
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("📖 펫 일지")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                Button(action: onClose) {
                    Text("✕ 닫기")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(CuteTheme.yellow)
                }
                .buttonStyle(.plain)
            }

            if entries.isEmpty {
                Text("아직 기록이 없어요. 부화·성장·졸업 같은 순간이 여기 쌓여요!")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
            } else {
                ForEach(entries.indices, id: \.self) { index in
                    let entry = entries[index]
                    HStack(alignment: .top, spacing: 8) {
                        Text(Self.dateFormatter.string(from: entry.date))
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.4))
                            .frame(width: 64, alignment: .leading)
                        Text(entry.text)
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 8).fill(CuteTheme.slot.opacity(0.5)))
                }
            }
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d HH:mm"
        return formatter
    }()
}
