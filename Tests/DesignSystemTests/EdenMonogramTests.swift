import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// `.mono18` is a spec, not a size: 18 pt square, `EdenRadius.mono`, 9.5/600
/// `primary` on `primaryTint`, and the initial always in lower case. The test
/// renders the control and a hand-built reference of that spec, so a drift in
/// any one of those numbers shows up as different pixels.
@MainActor
final class EdenMonogramTests: XCTestCase {
    func testMono18RendersTheLowercasedInitialToSpec() throws {
        let subject = try render(EdenMonogram(text: "Vessa", size: .mono18))

        XCTAssertEqual(subject, try render(reference("v")),
                       "mono18 should draw the initial lower-cased, to the mono18 spec")
        XCTAssertNotEqual(subject, try render(reference("V")),
                          "mono18 drew a capital — the initial is not being lower-cased")
    }

    /// The input's own casing must not matter: both spellings land on `v`.
    func testMono18IgnoresTheCasingItIsGiven() throws {
        XCTAssertEqual(try render(EdenMonogram(text: "vessa", size: .mono18)),
                       try render(EdenMonogram(text: "Vessa", size: .mono18)))
    }

    /// The switcher square is unchanged: 20 pt, and still capitalised.
    func testSwitcher20StillDrawsACapital() throws {
        let subject = try render(EdenMonogram(text: "principle"))
        XCTAssertEqual(subject, try render(EdenMonogram(text: "Principle")))
        XCTAssertNotEqual(subject, try render(EdenMonogram(text: "Principle", size: .mono18)))
    }

    // MARK: Helpers

    private func reference(_ initial: String) -> some View {
        Text(initial)
            .font(EdenFont.ui(9.5, .semibold))
            .foregroundStyle(EdenColor.primary)
            .frame(width: EdenMetric.mono18, height: EdenMetric.mono18)
            .background(EdenColor.primaryTint, in: .rect(cornerRadius: EdenRadius.mono))
    }

    private func render(_ view: some View, file: StaticString = #filePath, line: UInt = #line) throws -> Data {
        let renderer = ImageRenderer(content: view.background(EdenColor.canvas))
        renderer.scale = 2
        let image = try XCTUnwrap(renderer.cgImage, "the monogram produced no image",
                                  file: file, line: line)
        let bitmap = NSBitmapImageRep(cgImage: image)
        return try XCTUnwrap(bitmap.representation(using: .png, properties: [:]),
                             file: file, line: line)
    }
}
