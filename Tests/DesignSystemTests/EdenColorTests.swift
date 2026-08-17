import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// Spot-checks against `docs/design/eden-tokens.md` in the VessaStudio repo,
/// falling back to VessaStudio's EdenTokens.swift at beb0f21 for the two
/// neutrals the docs' tables don't spell out (n300, n200). If one of these
/// fails, either a token drifted or the docs moved — fix the token, never the
/// test's expectation.
@MainActor
final class EdenColorTests: XCTestCase {
    func testSurfaceTokensMatchDocs() {
        assertHex(EdenColor.canvas, 0xFAFAF8)
        assertHex(EdenColor.sidebar, 0xF4F3EE)
        assertHex(EdenColor.card, 0xFFFFFF)
    }

    func testAccentTokensMatchDocs() {
        assertHex(EdenColor.primary, 0x09321F)
        assertHex(EdenColor.primary5, 0xEFF2EE)
        assertHex(EdenColor.primary80, 0x224735)
        assertHex(EdenColor.primaryHover, 0x375847)
        assertHex(EdenColor.olive, 0x39624D)
        assertHex(EdenColor.hairline, 0xE0E0E0)
    }

    /// The two translucent tokens: the hue is the token they are drawn from,
    /// the alpha is the whole point of them.
    func testTranslucentTokensCarryTheirAlpha() {
        assertHex(EdenColor.primaryTint, 0x09321F)
        XCTAssertEqual(alpha(of: EdenColor.primaryTint), 0.09, accuracy: 0.001)
        assertHex(EdenColor.guideRail, 0x000000)
        XCTAssertEqual(alpha(of: EdenColor.guideRail), 0.09, accuracy: 0.001)
    }

    func testNeutralRampMatchesDocs() {
        assertHex(EdenColor.textPrimary, 0x272523)
        assertHex(EdenColor.n900, 0x171717)
        assertHex(EdenColor.n800, 0x262626)
        assertHex(EdenColor.n700, 0x404040)
        assertHex(EdenColor.n600, 0x525252)
        assertHex(EdenColor.n500, 0x737373)
        assertHex(EdenColor.n400, 0xA1A1A1)
        assertHex(EdenColor.n300, 0xD4D4D4)
        assertHex(EdenColor.n200, 0xE5E5E5)
    }

    /// `black(6)` must read as Tailwind's `black/[0.06]`, not 6.0.
    func testAlphaHelpersUsePercent() {
        XCTAssertEqual(alpha(of: EdenColor.black(6)), 0.06, accuracy: 0.001)
        XCTAssertEqual(alpha(of: EdenColor.black(1.8)), 0.018, accuracy: 0.001)
        XCTAssertEqual(alpha(of: EdenColor.white(80)), 0.80, accuracy: 0.001)
        assertHex(EdenColor.black(100), 0x000000)
        assertHex(EdenColor.white(100), 0xFFFFFF)
    }

    func testHexHelperRoundTrips() {
        assertHex(EdenColor.hex(0x123456), 0x123456)
    }

    // MARK: Helpers

    private func srgb(_ colour: Color, file: StaticString = #filePath, line: UInt = #line) -> NSColor? {
        guard let converted = NSColor(colour).usingColorSpace(.sRGB) else {
            XCTFail("Colour is not representable in sRGB", file: file, line: line)
            return nil
        }
        return converted
    }

    private func assertHex(_ colour: Color, _ expected: UInt32,
                           file: StaticString = #filePath, line: UInt = #line) {
        guard let converted = srgb(colour, file: file, line: line) else { return }
        let actual = (UInt32(round(converted.redComponent * 255)) << 16)
            | (UInt32(round(converted.greenComponent * 255)) << 8)
            | UInt32(round(converted.blueComponent * 255))
        XCTAssertEqual(actual, expected,
                       "expected #\(String(expected, radix: 16)), got #\(String(actual, radix: 16))",
                       file: file, line: line)
    }

    private func alpha(of colour: Color) -> Double {
        Double(NSColor(colour).alphaComponent)
    }
}
