import Foundation
import ClauchiCore

// 12지신 스프라이트 전체를 한 장의 HTML로 렌더하는 개발 도구.
// 사용: swift run SpritePreviewGen > build/sprite-preview.html && open build/sprite-preview.html

func hexColor(_ color: UInt32) -> String {
    String(format: "#%02X%02X%02X",
           (color >> 24) & 0xFF, (color >> 16) & 0xFF, (color >> 8) & 0xFF)
}

// Swift 6 strict concurrency — 단순 CLI 도구이므로 unsafe로 선언
nonisolated(unsafe) var canvasCount = 0
nonisolated(unsafe) var body = ""
nonisolated(unsafe) var script = ""

func emit(grid: PixelGrid, label: String, scale: Int) {
    canvasCount += 1
    let id = "c\(canvasCount)"
    let size = grid.width * scale
    body += """
    <figure><canvas id="\(id)" width="\(size)" height="\(size)"></canvas>
    <figcaption>\(label)</figcaption></figure>\n
    """
    var fills = ""
    for y in 0..<grid.height {
        for x in 0..<grid.width {
            let pixel = grid.pixels[y * grid.width + x]
            if pixel == 0 { continue }
            fills += "f('\(hexColor(pixel))',\(x),\(y));"
        }
    }
    script += """
    (function(){var c=document.getElementById('\(id)').getContext('2d');var s=\(scale);
    function f(k,x,y){c.fillStyle=k;c.fillRect(x*s,y*s,s,s);}\(fills)})();\n
    """
}

for species in SpriteLibrary.implementedSpecies {
    body += "<h2>\(species.koreanName) (\(species.rawValue))</h2><div class=\"row\">\n"
    let set = SpriteLibrary.spriteSet(for: species, stage: .adult)
    for state in SpriteLibrary.requiredSmallStates {
        for (index, frame) in set.frames(for: state).enumerated() {
            emit(grid: frame, label: "\(state.rawValue) \(index + 1)", scale: 4)
        }
    }
    for expression in Expression.allCases {
        if let large = set.large[expression] {
            emit(grid: large, label: "32 \(expression.rawValue)", scale: 4)
        }
    }
    body += "</div>\n"
}

print("""
<!DOCTYPE html><html><head><meta charset="utf-8"><style>
body{background:#101418;color:#eee;font-family:sans-serif;padding:24px}
.row{display:flex;flex-wrap:wrap;gap:12px;margin-bottom:28px}
figure{margin:0;text-align:center}figcaption{font-size:10px;opacity:.6;margin-top:4px}
canvas{image-rendering:pixelated;background:#1a2027;border-radius:6px}
</style></head><body><h1>Clauchi 스프라이트 미리보기</h1>
\(body)<script>\(script)</script></body></html>
""")
