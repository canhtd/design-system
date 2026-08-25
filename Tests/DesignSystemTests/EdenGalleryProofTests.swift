import AppKit
import DesignSystemGallery
import SwiftUI
import XCTest

/// Writes the gallery out under both Appearances so a human can look at it
/// without opening a window.
///
/// `swift run TokenGallery` is the interactive way, but it needs a screen and
/// takes the machine over. This renders offscreen exactly as
/// `EdenLightRenderTests` does and drops two PNGs on disk, which is what a
/// review of a token change actually needs: the same page, twice, side by side.
///
/// The files land in `.build/gallery-proof/` unless `EDEN_GALLERY_PROOF_DIR`
/// says otherwise. They are build output, not goldens — nothing is compared
/// against them, and `EdenLightRenderTests` remains the test that fails when
/// light moves.
@MainActor
final class EdenGalleryProofTests: XCTestCase {
    func testTheGalleryIsWrittenOutUnderBothAppearances() throws {
        let directory = Self.outputDirectory
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        for (name, scheme) in [("gallery-light", ColorScheme.light), ("gallery-dark", .dark)] {
            let renderer = ImageRenderer(content: EdenTokenGallery().content
                .frame(width: 1100)
                .environment(\.colorScheme, scheme))
            renderer.scale = 2

            let image = try XCTUnwrap(renderer.cgImage, "\(name) produced no image")
            let png = try XCTUnwrap(NSBitmapImageRep(cgImage: image)
                .representation(using: .png, properties: [:]), "\(name) would not encode")
            let url = directory.appendingPathComponent("\(name).png")
            try png.write(to: url)

            // A page that rendered as one flat colour is not proof of anything.
            XCTAssertGreaterThan(png.count, 20_000, "\(name) is too small to be the gallery")
            print("gallery proof · \(name): \(url.path) (\(png.count / 1024) KB, "
                  + "\(image.width)×\(image.height))")
        }
    }

    private static var outputDirectory: URL {
        if let override = ProcessInfo.processInfo.environment["EDEN_GALLERY_PROOF_DIR"] {
            return URL(fileURLWithPath: override)
        }
        return URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // DesignSystemTests
            .deletingLastPathComponent()   // Tests
            .deletingLastPathComponent()   // the package
            .appendingPathComponent(".build/gallery-proof")
    }
}
