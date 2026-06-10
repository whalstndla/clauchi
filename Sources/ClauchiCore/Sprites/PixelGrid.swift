import Foundation

// 문자 그리드 → RGBA 픽셀. '.' = 투명. 도트 데이터는 게임 로직과 분리 (CLAUDE.md)
public struct PixelGrid: Equatable, Sendable {
    public let width: Int
    public let height: Int
    public let pixels: [UInt32]   // 행 우선, 0xRRGGBBAA. 0 = 투명

    public init?(rows: [String], palette: [Character: UInt32]) {
        guard let firstRow = rows.first, !firstRow.isEmpty else { return nil }
        let expectedWidth = firstRow.count
        var parsed: [UInt32] = []
        parsed.reserveCapacity(rows.count * expectedWidth)
        for row in rows {
            guard row.count == expectedWidth else { return nil }
            for character in row {
                if character == "." { parsed.append(0); continue }
                guard let color = palette[character] else { return nil }
                parsed.append(color)
            }
        }
        self.width = expectedWidth
        self.height = rows.count
        self.pixels = parsed
    }

    private init(width: Int, height: Int, pixels: [UInt32]) {
        self.width = width; self.height = height; self.pixels = pixels
    }

    // 정수배 확대 (니어리스트) — 알/아기 32×32 재활용용
    public func scaled(by factor: Int) -> PixelGrid {
        var scaledPixels: [UInt32] = []
        scaledPixels.reserveCapacity(pixels.count * factor * factor)
        for y in 0..<height {
            let row = Array(pixels[(y * width)..<((y + 1) * width)])
            let scaledRow = row.flatMap { Array(repeating: $0, count: factor) }
            for _ in 0..<factor { scaledPixels.append(contentsOf: scaledRow) }
        }
        return PixelGrid(width: width * factor, height: height * factor, pixels: scaledPixels)
    }
}
