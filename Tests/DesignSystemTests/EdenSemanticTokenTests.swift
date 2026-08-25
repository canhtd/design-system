import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// Every role added so that views could stop spelling colours, pinned to the
/// exact light value the call site spelled before. This is what makes "light
/// is unchanged" a fact rather than a hope: the render goldens prove the
/// picture did not move, and these prove *why* it could not.
///
/// When dark values land, these expectations stay — they are the light half of
/// each token, and a token that drifts under light is a regression.
@MainActor
final class EdenSemanticTokenTests: XCTestCase {
    /// The ink ladder is the neutral ramp, one role per step.
    func testInkRolesCarryTheirRampStep() {
        assertColour(EdenColor.textStrong, 0x171717)
        assertColour(EdenColor.textSelected, 0x262626)
        assertColour(EdenColor.textControl, 0x404040)
        assertColour(EdenColor.textControlQuiet, 0x525252)
        assertColour(EdenColor.textSecondary, 0x737373)
        assertColour(EdenColor.textTertiary, 0xA1A1A1)
        assertColour(EdenColor.textFaint, 0xD4D4D4)
        assertColour(EdenColor.textInverse, 0xFFFFFF)
    }

    /// The pill controls: `white/80` at rest going opaque under the pointer,
    /// over a black edge that firms up by three points.
    func testPillControlFillsAndEdges() {
        assertColour(EdenColor.controlFill, 0xFFFFFF, alpha: 0.80)
        assertColour(EdenColor.controlFillHover, 0xFFFFFF)
        assertColour(EdenColor.controlBorder, 0x000000, alpha: 0.07)
        assertColour(EdenColor.controlBorderHover, 0x000000, alpha: 0.10)
        assertColour(EdenColor.controlBorderSmall, 0x000000, alpha: 0.09)
        assertColour(EdenColor.ghostHoverFill, 0x000000, alpha: 0.04)
    }

    func testChipSegmentAndComponentFills() {
        assertColour(EdenColor.chipActiveFill, 0xFFFFFF)
        assertColour(EdenColor.chipActiveBorder, 0x000000, alpha: 0.15)
        assertColour(EdenColor.segmentTrackFill, 0x000000, alpha: 0.018)
        assertColour(EdenColor.segmentTrackBorder, 0x000000, alpha: 0.065)
        assertColour(EdenColor.segmentSelectedFill, 0x000000, alpha: 0.055)
        assertColour(EdenColor.keycapFill, 0x000000, alpha: 0.05)
        assertColour(EdenColor.monogramFill, 0x000000, alpha: 0.06)
        assertColour(EdenColor.raisedShadow, 0x000000, alpha: 0.08)
    }

    /// The surfaces a modifier paints. `floatShadow` stays a function because
    /// `edenFloatShadow(opacity:)` is one — a modal is deeper than a toolbar.
    func testSurfaceEdgesShadowsAndWashes() {
        assertColour(EdenColor.paneBorder, 0x000000, alpha: 0.06)
        assertColour(EdenColor.panelShadow, 0x000000, alpha: 0.10)
        assertColour(EdenColor.floatShadow(8), 0x000000, alpha: 0.08)
        assertColour(EdenColor.floatShadow(30), 0x000000, alpha: 0.30)
        assertColour(EdenColor.pageWashTop, 0x000000, alpha: 0.055)
        assertColour(EdenColor.pageWashBottom, 0x000000, alpha: 0.03)
    }

    /// `< 2×` is still the neutral rung, and still borders at 10 % rather than
    /// at the ladder's shared 25 %.
    func testSignalLaddersKeepTheirNeutralRung() {
        assertColour(EdenColor.signalNone, 0x000000, alpha: 0.55)
        assertColour(EdenColor.signalNoneBorder, 0x000000, alpha: 0.10)
        assertColour(EdenSignal.outlierBase.hue, 0x000000, alpha: 0.55)
        assertColour(EdenSignal.outlier(1.5).outlierBaseBorder, 0x000000, alpha: 0.10)
    }

    private func assertColour(_ colour: Color, _ expected: UInt32, alpha expectedAlpha: Double = 1,
                              file: StaticString = #filePath, line: UInt = #line) {
        guard let ns = NSColor(colour).usingColorSpace(.sRGB) else {
            return XCTFail("colour is not representable in sRGB", file: file, line: line)
        }
        let packed = UInt32(round(ns.redComponent * 255)) << 16
            | UInt32(round(ns.greenComponent * 255)) << 8
            | UInt32(round(ns.blueComponent * 255))
        XCTAssertEqual(packed, expected,
                       String(format: "expected #%06X, got #%06X", expected, packed),
                       file: file, line: line)
        XCTAssertEqual(Double(ns.alphaComponent), expectedAlpha, accuracy: 0.001,
                       "alpha", file: file, line: line)
    }
}
