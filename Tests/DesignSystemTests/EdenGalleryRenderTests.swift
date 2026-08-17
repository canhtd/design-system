import AppKit
import DesignSystemGallery
import SwiftUI
import XCTest

/// The gallery is the human-facing proof that the tokens are right, so it has
/// to actually draw — compiling is not enough.
@MainActor
final class EdenGalleryRenderTests: XCTestCase {
    func testGalleryRendersRealPixels() throws {
        let renderer = ImageRenderer(content: EdenTokenGallery().content.frame(width: 1100))
        renderer.scale = 2

        let image = try XCTUnwrap(renderer.cgImage, "the gallery produced no image")
        XCTAssertGreaterThan(image.width, 1000)
        XCTAssertGreaterThan(image.height, 1000)

        let bitmap = NSBitmapImageRep(cgImage: image)
        let background = try XCTUnwrap(bitmap.colorAt(x: 4, y: 4)?.usingColorSpace(.sRGB))
        XCTAssertEqual(Double(background.redComponent), 0xFA / 255, accuracy: 0.01,
                       "the page should be painted with EdenColor.canvas")

        // A blank canvas would be one flat colour; drawn content is not.
        var distinct = Set<UInt32>()
        for x in stride(from: 0, to: bitmap.pixelsWide, by: 37) {
            for y in stride(from: 0, to: bitmap.pixelsHigh, by: 37) {
                guard let pixel = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.sRGB) else { continue }
                distinct.insert((UInt32(pixel.redComponent * 255) << 16)
                    | (UInt32(pixel.greenComponent * 255) << 8)
                    | UInt32(pixel.blueComponent * 255))
            }
        }
        XCTAssertGreaterThan(distinct.count, 20, "the gallery rendered a flat image")
    }
}
