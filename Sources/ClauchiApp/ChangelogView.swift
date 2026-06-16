import SwiftUI
import ClauchiCore

// 변경 로그 모달 — 노치 패널 내 오버레이(시스템 sheet 대신).
// 스크롤은 패널 외부 ScrollView가 담당하므로 내부 ScrollView를 두지 않는다.
struct ChangelogView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 헤더 + 닫기
            HStack {
                Text("📋 변경 로그")
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

            ForEach(Changelog.entries, id: \.version) { entry in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("v\(entry.version)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(CuteTheme.yellow)
                        Text(entry.date)
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    ForEach(entry.changes, id: \.self) { change in
                        Text("· \(change)")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundStyle(.white.opacity(0.75))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10).fill(CuteTheme.slot.opacity(0.5)))
            }
        }
    }
}
