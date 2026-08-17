// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.macOS(.v14)],
    products: [
        // Only the tokens ship. The gallery is a development target: apps that
        // depend on this package must not link the demo views.
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    targets: [
        .target(name: "DesignSystem"),
        .target(name: "DesignSystemGallery", dependencies: ["DesignSystem"]),
        .executableTarget(name: "TokenGallery", dependencies: ["DesignSystemGallery"]),
        .testTarget(name: "DesignSystemTests",
                    dependencies: ["DesignSystem", "DesignSystemGallery"])
    ]
)
