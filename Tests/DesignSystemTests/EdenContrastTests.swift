import AppKit
import DesignSystem
import DesignSystemGallery
import SwiftUI
import XCTest

/// The floor: text has to be readable on the ground it is drawn on, in both
/// Appearances. WCAG 2.1 contrast, computed from the token as AppKit resolves
/// it — not from the hex in the spec, so a token that drifts is caught here
/// too.
///
/// `textTertiary` and `textFaint` are deliberately absent: they are the ink of
/// a disabled label and of a row that is not there yet. Under light they have
/// always sat at 2.5:1 and 1.3:1, and holding them to the text floor would
/// mean drawing "unavailable" as loudly as "available".
@MainActor
final class EdenContrastTests: XCTestCase {
    private static let floor = 4.5

    func testInkClearsTheFloorOnCanvasAndCard() {
        let ink: [(String, Color)] = [
            ("textPrimary", EdenColor.textPrimary), ("textStrong", EdenColor.textStrong),
            ("textSelected", EdenColor.textSelected), ("textControl", EdenColor.textControl),
            ("textControlQuiet", EdenColor.textControlQuiet),
            ("textSecondary", EdenColor.textSecondary)
        ]
        let grounds: [(String, Color)] = [
            ("canvas", EdenColor.canvas), ("card", EdenColor.card),
            ("menuSurface", EdenColor.menuSurface)
        ]
        for appearance in [EdenTestAppearance.light, .dark] {
            for (inkName, colour) in ink {
                for (groundName, ground) in grounds {
                    assertReadable(colour, on: ground, appearance,
                                   "\(inkName) on \(groundName)")
                }
            }
        }
    }

    /// A filled button carries its own ink, and `danger` is a *light* red
    /// under dark — which is why `textInverse` inverts rather than staying
    /// white.
    func testFilledButtonsCarryTheirOwnInk() {
        for appearance in [EdenTestAppearance.light, .dark] {
            assertReadable(EdenColor.primary5, on: EdenColor.primary80, appearance,
                           "primary5 on primary80")
            assertReadable(EdenColor.textInverse, on: EdenColor.danger, appearance,
                           "textInverse on danger")
            assertReadable(EdenColor.danger, on: EdenColor.canvas, appearance,
                           "danger as text on canvas")
        }
    }

    /// Every rung of both ladders has to carry its own label on a dark card.
    ///
    /// The floor is asserted for the dark halves only, on purpose: two of the
    /// measured light hues (`#E17100` at 3.20:1 and `#F54A00` at 3.58:1) have
    /// never met 4.5:1 on white. That is a property of Eden's measured
    /// palette, and light does not move in this package — so the test holds
    /// the line it can hold, and says which line that is. Dark comes out
    /// between 5.4:1 and 8.1:1, which is the point of lifting the hues.
    func testSignalRungsCarryTheirLabelUnderDark() {
        let rungs = [EdenSignal.outlier(2.5), EdenSignal.outlier(4), EdenSignal.outlier(9),
                     EdenSignal.outlier(20), EdenSignal.outlier(91),
                     EdenSignal.percentile(93)!, EdenSignal.percentile(97)!]
        for (index, rung) in rungs.enumerated() {
            assertReadable(rung.hue, on: EdenColor.card, .dark, "signal rung \(index)")
        }
    }

    /// The Gallery under dark is not the light Gallery: the ground is Eden's
    /// `#111`, and the page still has drawn content on it.
    func testTheGalleryDrawsDark() throws {
        let renderer = ImageRenderer(content: EdenTokenGallery().content
            .frame(width: 1100)
            .environment(\.colorScheme, .dark))
        let bitmap = NSBitmapImageRep(cgImage: try XCTUnwrap(renderer.cgImage))
        let ground = try XCTUnwrap(bitmap.colorAt(x: 4, y: 4)?.usingColorSpace(.sRGB))
        XCTAssertLessThan(Double(ground.redComponent), 0.15,
                          "the dark page should be painted with EdenColor.canvas' dark half")

        var distinct = Set<UInt32>()
        for x in stride(from: 0, to: bitmap.pixelsWide, by: 37) {
            for y in stride(from: 0, to: bitmap.pixelsHigh, by: 37) {
                guard let pixel = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.sRGB) else { continue }
                distinct.insert((UInt32(pixel.redComponent * 255) << 16)
                    | (UInt32(pixel.greenComponent * 255) << 8)
                    | UInt32(pixel.blueComponent * 255))
            }
        }
        XCTAssertGreaterThan(distinct.count, 20, "the dark gallery rendered a flat image")
    }

    // MARK: WCAG

    private func assertReadable(_ ink: Color, on ground: Color, _ appearance: EdenTestAppearance,
                                _ what: String,
                                file: StaticString = #filePath, line: UInt = #line) {
        let ratio = contrast(ink, on: ground, appearance)
        XCTAssertGreaterThanOrEqual(ratio, Self.floor,
                                    String(format: "%@ under %@ is %.2f:1", what,
                                           appearance == .dark ? "dark" : "light", ratio),
                                    file: file, line: line)
    }

    /// Ink is composited onto its ground first: several roles are translucent,
    /// and a 55 % grey is not read against nothing.
    private func contrast(_ ink: Color, on ground: Color,
                          _ appearance: EdenTestAppearance) -> Double {
        let inkColour = resolved(ink, appearance), groundColour = resolved(ground, appearance)
        let alpha = Double(inkColour.alphaComponent)
        let composited = (0..<3).map { channel -> Double in
            let over = Double(component(inkColour, channel))
            let under = Double(component(groundColour, channel))
            return over * alpha + under * (1 - alpha)
        }
        let inkLuminance = luminance(composited)
        let groundLuminance = luminance((0..<3).map { Double(component(groundColour, $0)) })
        let high = max(inkLuminance, groundLuminance), low = min(inkLuminance, groundLuminance)
        return (high + 0.05) / (low + 0.05)
    }

    private func component(_ colour: NSColor, _ index: Int) -> CGFloat {
        [colour.redComponent, colour.greenComponent, colour.blueComponent][index]
    }

    private func luminance(_ channels: [Double]) -> Double {
        let linear = channels.map { $0 <= 0.04045 ? $0 / 12.92 : pow(($0 + 0.055) / 1.055, 2.4) }
        return 0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]
    }
}
