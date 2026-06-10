import AppKit
import ClauchiCore

// PixelGrid → NSImage. 보간은 뷰 쪽 .interpolation(.none) 으로 끈다 (스펙 §8)
@MainActor
enum SpriteImageFactory {
    private static var cache: [String: NSImage] = [:]

    static func image(for grid: PixelGrid, cacheKey: String) -> NSImage {
        if let cached = cache[cacheKey] { return cached }
        var bytes = Data(capacity: grid.pixels.count * 4)
        for pixel in grid.pixels {
            bytes.append(UInt8((pixel >> 24) & 0xFF))   // R
            bytes.append(UInt8((pixel >> 16) & 0xFF))   // G
            bytes.append(UInt8((pixel >> 8) & 0xFF))    // B
            bytes.append(UInt8(pixel & 0xFF))           // A
        }
        let provider = CGDataProvider(data: bytes as CFData)!
        let cgImage = CGImage(
            width: grid.width, height: grid.height,
            bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: grid.width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue),
            provider: provider, decode: nil, shouldInterpolate: false,
            intent: .defaultIntent)!
        let image = NSImage(cgImage: cgImage,
                            size: NSSize(width: grid.width, height: grid.height))
        cache[cacheKey] = image
        return image
    }
}
