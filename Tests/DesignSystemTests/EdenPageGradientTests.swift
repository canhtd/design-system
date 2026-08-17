import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// The page wash is the one token that cannot be read off a number: it either
/// darkens the two corners it is supposed to darken, or it is not doing its
/// job. 5.5% top-left, 3% bottom-right, nothing in the middle.
@MainActor
final class EdenPageGradientTests: XCTestCase {
    func testTheWashDarkensBothCornersAndLeavesTheMiddleAlone() throws {
        let renderer = ImageRenderer(content:
            ZStack {
                EdenColor.canvas
                EdenPageGradient()
            }
            .frame(width: 400, height: 300)
        )
        let image = try XCTUnwrap(renderer.cgImage, "the gradient produced no image")
        let bitmap = NSBitmapImageRep(cgImage: image)

        let middle = try level(bitmap, x: bitmap.pixelsWide / 2, y: bitmap.pixelsHigh / 2)
        let topLeft = try level(bitmap, x: 2, y: 2)
        let bottomRight = try level(bitmap, x: bitmap.pixelsWide - 3, y: bitmap.pixelsHigh - 3)

        XCTAssertEqual(middle, 0xFA / 255, accuracy: 0.005,
                       "the middle of the page should still be EdenColor.canvas")
        XCTAssertLessThan(topLeft, middle - 0.02, "the 5.5% wash is missing top-left")
        XCTAssertLessThan(bottomRight, middle - 0.01, "the 3% wash is missing bottom-right")
        XCTAssertLessThan(topLeft, bottomRight, "top-left is the stronger of the two washes")
    }

    private func level(_ bitmap: NSBitmapImageRep, x: Int, y: Int,
                       file: StaticString = #filePath, line: UInt = #line) throws -> Double {
        let pixel = try XCTUnwrap(bitmap.colorAt(x: x, y: y)?.usingColorSpace(.sRGB),
                                  file: file, line: line)
        return Double(pixel.redComponent)
    }
}
