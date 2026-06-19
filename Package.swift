// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "clauchi",
    platforms: [.macOS("26.0")],
    targets: [
        .target(name: "ClauchiCore"),
        .executableTarget(name: "ClauchiApp", dependencies: ["ClauchiCore"]),
        .executableTarget(name: "ClauchiHook", dependencies: ["ClauchiCore"]),
        .executableTarget(name: "SpritePreviewGen", dependencies: ["ClauchiCore"]),
        .executableTarget(name: "AppIconGen", dependencies: ["ClauchiCore"]),
        .testTarget(name: "ClauchiCoreTests", dependencies: ["ClauchiCore"]),
    ]
)
