import AppKit
import ClauchiCore

// Clauchi 앱 아이콘 생성기.
// 다마고치 기기(파스텔 핑크 셸 + LCD 액정 + 버튼)를 1024×1024 PNG로 굽는다.
// 셸·버튼·그림자는 매끈한 CoreGraphics 벡터, 화면 속 '금 간 알'만 크런치 픽셀.
// 사용: swift run AppIconGen <출력경로.png>   (기본 build/AppIcon-1024.png)

// MARK: - 금 간 알 도트 (16×16) — 부화 직전. EggSprites 알 + 지그재그 균열 + 균열 틈의 빛.
enum CrackedEgg {
    static let palette: [Character: UInt32] = [
        "K": 0x1C1917FF,   // 외곽선 / 균열선
        "W": 0xFEF3E2FF,   // 껍데기
        "S": 0xFACC15FF,   // 무늬
        "L": 0xFFFBE0FF,   // 균열 틈에서 새는 빛
    ]
    // 가운데를 가로지르는 지그재그 균열(K) + 균열 위 두 곳 빛(L)
    static let rows = [
        "................",
        "......KKKK......",
        ".....KWWWWK.....",
        "....KWWWWWWK....",
        "...KWWWSSWWWK...",
        "...KWWWSSWWWK...",
        "..KWWWWWWWWWWK..",
        "..KWKWWWKWWWWK..",
        "..KKLKWKLKSKKK..",
        "..KWSSKWWWKSWK..",
        "..KWWWWWWWWWWK..",
        "...KWWWWWWWWK...",
        "...KWWWWWWWWK...",
        "....KWWWWWWK....",
        ".....KKKKKK.....",
        "................",
    ]
    static var grid: PixelGrid { PixelGrid(rows: rows, palette: palette)! }
}

// MARK: - 색/그라데이션 헬퍼

// 0xRRGGBBAA → CGColor
func cgColor(_ rgba: UInt32) -> CGColor {
    CGColor(srgbRed: CGFloat((rgba >> 24) & 0xFF) / 255,
            green: CGFloat((rgba >> 16) & 0xFF) / 255,
            blue: CGFloat((rgba >> 8) & 0xFF) / 255,
            alpha: CGFloat(rgba & 0xFF) / 255)
}

// 0xRRGGBB + 알파
func cgRGB(_ rgb: UInt32, _ alpha: CGFloat = 1) -> CGColor {
    CGColor(srgbRed: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: alpha)
}

func gradient(_ colors: [CGColor]) -> CGGradient {
    CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB),
               colors: colors as CFArray, locations: nil)!
}

// 경로를 세로 그라데이션(위=topColor, 아래=bottomColor)으로 채운다
func fillVertical(_ ctx: CGContext, path: CGPath, top: UInt32, bottom: UInt32) {
    ctx.saveGState()
    ctx.addPath(path)
    ctx.clip()
    let box = path.boundingBoxOfPath
    ctx.drawLinearGradient(gradient([cgRGB(bottom), cgRGB(top)]),
                           start: CGPoint(x: box.midX, y: box.minY),
                           end: CGPoint(x: box.midX, y: box.maxY),
                           options: [])
    ctx.restoreGState()
}

// MARK: - 달걀형 경로 (위가 살짝 좁고 아래가 통통한 egg)
func eggPath(center: CGPoint, halfWidth a: CGFloat, halfHeight b: CGFloat) -> CGPath {
    let cx = center.x, cy = center.y
    let top = CGPoint(x: cx, y: cy + b)
    let bottom = CGPoint(x: cx, y: cy - b)
    let path = CGMutablePath()
    path.move(to: top)
    path.addCurve(to: CGPoint(x: cx + a, y: cy),
                  control1: CGPoint(x: cx + a * 0.80, y: cy + b),
                  control2: CGPoint(x: cx + a, y: cy + b * 0.46))
    path.addCurve(to: bottom,
                  control1: CGPoint(x: cx + a, y: cy - b * 0.62),
                  control2: CGPoint(x: cx + a * 0.58, y: cy - b))
    path.addCurve(to: CGPoint(x: cx - a, y: cy),
                  control1: CGPoint(x: cx - a * 0.58, y: cy - b),
                  control2: CGPoint(x: cx - a, y: cy - b * 0.62))
    path.addCurve(to: top,
                  control1: CGPoint(x: cx - a, y: cy + b * 0.46),
                  control2: CGPoint(x: cx - a * 0.80, y: cy + b))
    path.closeSubpath()
    return path
}

// MARK: - 픽셀 그리드 → 캔버스 (보간 없이 사각형으로 채움). row 0 = 위.
func drawPixelGrid(_ ctx: CGContext, _ grid: PixelGrid, in frame: CGRect) {
    let scale = min(frame.width / CGFloat(grid.width), frame.height / CGFloat(grid.height))
    let drawWidth = scale * CGFloat(grid.width)
    let drawHeight = scale * CGFloat(grid.height)
    let originX = frame.midX - drawWidth / 2
    let originY = frame.midY - drawHeight / 2
    for y in 0..<grid.height {
        for x in 0..<grid.width {
            let pixel = grid.pixels[y * grid.width + x]
            if pixel == 0 { continue }
            ctx.setFillColor(cgColor(pixel))
            // CG는 y가 위로 증가 → row 0이 위로 가도록 y 뒤집기
            let rectX = originX + CGFloat(x) * scale
            let rectY = originY + CGFloat(grid.height - 1 - y) * scale
            ctx.fill(CGRect(x: rectX, y: rectY, width: scale, height: scale))
        }
    }
}

// MARK: - 렌더

func renderIcon() -> CGImage {
    let size = 1024
    let ctx = CGContext(data: nil, width: size, height: size,
                        bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpace(name: CGColorSpace.sRGB)!,
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

    let center = CGPoint(x: 512, y: 512)

    // 1) 배경 squircle + 은은한 핑크 라디얼 글로우 (macOS 아이콘 그리드: 824 둥근 사각)
    let background = CGPath(roundedRect: CGRect(x: 100, y: 100, width: 824, height: 824),
                            cornerWidth: 185, cornerHeight: 185, transform: nil)
    ctx.saveGState()
    ctx.addPath(background)
    ctx.clip()
    // 본체(캔디 핑크)가 또렷이 떠 보이도록 중앙은 밝은 그레이, 가장자리는 한 톤 진한 그레이
    ctx.drawRadialGradient(gradient([cgRGB(0xF4F5F7), cgRGB(0xD5D8DD)]),
                           startCenter: CGPoint(x: 512, y: 560), startRadius: 0,
                           endCenter: CGPoint(x: 512, y: 540), endRadius: 600,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()

    // 2) 열쇠고리 탭 (셸 뒤에 깔아 윗부분만 보이게)
    let tab = CGPath(roundedRect: CGRect(x: 512 - 36, y: 818, width: 72, height: 62),
                     cornerWidth: 26, cornerHeight: 26, transform: nil)
    fillVertical(ctx, path: tab, top: 0xFBBBD0, bottom: 0xEF9BBC)
    ctx.setFillColor(cgRGB(0xC65E86))
    ctx.fillEllipse(in: CGRect(x: 512 - 12, y: 846, width: 24, height: 24))

    // 3) 달걀형 몸체 — 드롭 섀도(솔리드 채움) → 그라데이션
    let egg = eggPath(center: center, halfWidth: 276, halfHeight: 316)
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -16), blur: 40, color: cgRGB(0x7A3050, 0.30))
    ctx.addPath(egg)
    ctx.setFillColor(cgRGB(0xEC7BA6))
    ctx.fillPath()
    ctx.restoreGState()
    fillVertical(ctx, path: egg, top: 0xFAB9CF, bottom: 0xEB7AA5)

    // 3-1) 실루엣 정의용 은은한 림 (배경과 톤이 비슷해도 본체 윤곽이 또렷하게)
    ctx.addPath(egg)
    ctx.setStrokeColor(cgRGB(0xD9628C, 0.45))
    ctx.setLineWidth(3)
    ctx.strokePath()

    // 4) 셸 상단 광택 (egg로 클립한 흰 라디얼)
    ctx.saveGState()
    ctx.addPath(egg)
    ctx.clip()
    ctx.drawRadialGradient(gradient([cgRGB(0xFFFFFF, 0.50), cgRGB(0xFFFFFF, 0.0)]),
                           startCenter: CGPoint(x: 512, y: 716), startRadius: 0,
                           endCenter: CGPoint(x: 512, y: 716), endRadius: 232,
                           options: [])
    ctx.restoreGState()

    // 5) LCD 베젤 + 액정
    let bezel = CGPath(roundedRect: CGRect(x: 512 - 162, y: 468, width: 324, height: 252),
                       cornerWidth: 42, cornerHeight: 42, transform: nil)
    ctx.addPath(bezel)
    ctx.setFillColor(cgRGB(0x2A2330))
    ctx.fillPath()

    let screenRect = CGRect(x: 512 - 134, y: 496, width: 268, height: 198)
    let screen = CGPath(roundedRect: screenRect, cornerWidth: 26, cornerHeight: 26, transform: nil)
    fillVertical(ctx, path: screen, top: 0x26334F, bottom: 0x12172A)

    // 6) 화면 속 금 간 알 (픽셀)
    drawPixelGrid(ctx, CrackedEgg.grid, in: screenRect.insetBy(dx: 48, dy: 20))

    // 7) 액정 글래스 글레어 (좌상단, 은은하게)
    ctx.saveGState()
    ctx.addPath(screen)
    ctx.clip()
    ctx.drawLinearGradient(gradient([cgRGB(0xFFFFFF, 0.14), cgRGB(0xFFFFFF, 0.0)]),
                           start: CGPoint(x: screenRect.minX, y: screenRect.maxY),
                           end: CGPoint(x: screenRect.midX, y: screenRect.midY),
                           options: [])
    ctx.restoreGState()

    // 8) 버튼 3개
    let buttonY: CGFloat = 404
    for dx in [-80.0, 0.0, 80.0] as [CGFloat] {
        let buttonCenter = CGPoint(x: 512 + dx, y: buttonY)
        let radius: CGFloat = 27
        let rect = CGRect(x: buttonCenter.x - radius, y: buttonCenter.y - radius,
                          width: radius * 2, height: radius * 2)
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: -3), blur: 6, color: cgRGB(0x7A3050, 0.35))
        ctx.setFillColor(cgRGB(0xDE6E98))
        ctx.fillEllipse(in: rect)
        ctx.restoreGState()
        ctx.setFillColor(cgRGB(0xFFFFFF, 0.28))
        ctx.fillEllipse(in: CGRect(x: buttonCenter.x - radius * 0.5, y: buttonCenter.y + radius * 0.08,
                                   width: radius, height: radius * 0.62))
    }

    return ctx.makeImage()!
}

// MARK: - 진입

let outputPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "build/AppIcon-1024.png"

let image = renderIcon()
let rep = NSBitmapImageRep(cgImage: image)
guard let pngData = rep.representation(using: .png, properties: [:]) else {
    FileHandle.standardError.write(Data("PNG 인코딩 실패\n".utf8))
    exit(1)
}
let outputURL = URL(fileURLWithPath: outputPath)
try? FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(),
                                         withIntermediateDirectories: true)
do {
    try pngData.write(to: outputURL)
    print("OK: \(outputPath)")
} catch {
    FileHandle.standardError.write(Data("쓰기 실패: \(error)\n".utf8))
    exit(1)
}
