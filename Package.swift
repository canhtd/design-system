// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    targets: [
        .target(name: "DesignSystem"),
        .executableTarget(name: "TokenGallery", dependencies: ["DesignSystem"]),
        .testTarget(name: "DesignSystemTests", dependencies: ["DesignSystem"])
    ]
)
