import SwiftUI

// 다마고치풍 공용 색상
enum CuteTheme {
    static let panelBackground = Color(red: 0.11, green: 0.09, blue: 0.10)   // 따뜻한 검정
    static let slot = Color(white: 0.16)
    static let border = Color(white: 0.24)
    static let cream = Color(red: 0.996, green: 0.953, blue: 0.886)
    static let green = Color(red: 0.29, green: 0.87, blue: 0.50)
    static let pink = Color(red: 0.96, green: 0.45, blue: 0.71)
    static let yellow = Color(red: 0.98, green: 0.80, blue: 0.08)
    static let screenTop = Color(red: 0.15, green: 0.20, blue: 0.32)
    static let screenBottom = Color(red: 0.07, green: 0.09, blue: 0.16)
}

// 레트로 게임기풍 칸 채우기 게이지 — 매끈한 바 대신 픽셀 블록
struct PixelBar: View {
    let value: Double
    let total: Double
    let color: Color
    var blockCount = 10

    var body: some View {
        let filled = total > 0
            ? Int((value / total * Double(blockCount)).rounded(.toNearestOrAwayFromZero))
            : 0
        HStack(spacing: 2) {
            ForEach(0..<blockCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < filled ? color : CuteTheme.slot)
                    .frame(height: 10)
            }
        }
    }
}

// 알약 호버용 초소형 게이지
struct TinyBar: View {
    let value: Double
    let total: Double
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(white: 0.28))
                Capsule().fill(color)
                    .frame(width: max(3, geometry.size.width * value / max(total, 1)))
            }
        }
        .frame(height: 4)
    }
}

// 쓰다듬기 하트 이펙트 — trigger 값이 바뀔 때마다 하트가 떠오른다
struct HeartBurst: View {
    let trigger: Int
    @State private var particles: [Particle] = []

    struct Particle: Identifiable, Equatable {
        let id = UUID()
        let xOffset: CGFloat
        let delay: Double
    }

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                FloatingHeart(xOffset: particle.xOffset, delay: particle.delay)
            }
        }
        .allowsHitTesting(false)
        .onChange(of: trigger) {
            let burst = (0..<3).map { index in
                Particle(xOffset: .random(in: -34...34), delay: Double(index) * 0.09)
            }
            particles.append(contentsOf: burst)
            Task {
                try? await Task.sleep(for: .seconds(1.4))
                particles.removeAll { burst.contains($0) }
            }
        }
    }
}

private struct FloatingHeart: View {
    let xOffset: CGFloat
    let delay: Double
    @State private var floated = false

    var body: some View {
        Text("💗")
            .font(.system(size: 15))
            .offset(x: xOffset, y: floated ? -64 : -4)
            .opacity(floated ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 1.1).delay(delay)) { floated = true }
            }
    }
}
