import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// The tokens v0.2.0 added, pinned to the numbers the M1 design rules cite
/// (`docs/design/refs/design-rules.md` in the VessaStudio repo, "Package gaps").
/// Fix the token, never the expectation.
@MainActor
final class EdenTokenGapTests: XCTestCase {
    func testChipAndPopoverMetrics() {
        XCTAssertEqual(EdenMetric.chipHeight, 26)
        XCTAssertEqual(EdenMetric.smallPillHeight, 28)
        XCTAssertEqual(EdenMetric.popoverRowHeight, 32)
        XCTAssertEqual(EdenMetric.popoverPadding, 4)
    }

    func testSidebarIndentAndAffordanceMetrics() {
        XCTAssertEqual(EdenMetric.childIndent, 15)
        XCTAssertEqual(EdenMetric.childIndentDeep, 9)
        XCTAssertEqual(EdenMetric.childRailPadding, 11)
        XCTAssertEqual(EdenMetric.childIconSlot, 16)
        XCTAssertEqual(EdenMetric.rowActionSize, 28)
        XCTAssertEqual(EdenMetric.disclosureSize, 20)
        XCTAssertEqual(EdenMetric.sidebarTopInset, 30)
    }

    func testPaneAndWindowMetrics() {
        XCTAssertEqual(EdenMetric.paneHeaderHeight, 34)
        XCTAssertEqual(EdenMetric.paneInset, 9)
        XCTAssertEqual(EdenMetric.paneGap, 9)
        XCTAssertEqual(EdenMetric.windowMinWidth, 900)
        XCTAssertEqual(EdenMetric.windowMinHeight, 600)
        XCTAssertEqual(EdenMetric.scrimBlur, 3)
    }

    func testStatusAndRuleColours() {
        assertHex(EdenColor.statusActive, 0x00B579)
        assertHex(EdenColor.statusActiveRing, 0xC9EAE0)
        assertHex(EdenColor.statusDone, 0x007A55)
        assertHex(EdenColor.guideRailDeep, 0x000000)
        XCTAssertEqual(alpha(of: EdenColor.guideRailDeep), 0.06, accuracy: 0.001)
        XCTAssertEqual(alpha(of: EdenColor.scrim), 0.18, accuracy: 0.001)
    }

    /// A hue band fills at 8 % and borders at 25 % of the same colour, so the
    /// ladder never needs a second constant per rung.
    func testOutlierAndPercentileLadders() {
        assertHex(EdenSignal.outlier(2.5).hue, 0x0069A8)
        assertHex(EdenSignal.outlier(4).hue, 0x007A55)
        assertHex(EdenSignal.outlier(9).hue, 0xE17100)
        assertHex(EdenSignal.outlier(20).hue, 0xF54A00)
        assertHex(EdenSignal.outlier(91).hue, 0xEC003F)
        XCTAssertEqual(alpha(of: EdenSignal.outlier(4).fill), 0.08, accuracy: 0.001)
        XCTAssertEqual(alpha(of: EdenSignal.outlier(4).border), 0.25, accuracy: 0.001)
        XCTAssertNil(EdenSignal.percentile(90))
        assertHex(EdenSignal.percentile(97)!.hue, 0xA800B7)
    }

    func testNamedFacesCarrySizeWeightAndTracking() {
        XCTAssertEqual(EdenType.pageTitle.size, 27)
        XCTAssertEqual(EdenType.pageTitle.tracking, -0.945, accuracy: 0.001)
        XCTAssertEqual(EdenType.sheetTitle.size, 26)
        XCTAssertEqual(EdenType.sheetTitle.tracking, -1.04, accuracy: 0.001)
        XCTAssertEqual(EdenType.sectionTitle.size, 21)
        XCTAssertEqual(EdenType.sectionTitle.tracking, -0.42, accuracy: 0.001)
    }

    private func assertHex(_ colour: Color, _ expected: UInt32,
                           file: StaticString = #filePath, line: UInt = #line) {
        let ns = NSColor(colour).usingColorSpace(.sRGB)!
        let packed = UInt32(round(ns.redComponent * 255)) << 16
            | UInt32(round(ns.greenComponent * 255)) << 8
            | UInt32(round(ns.blueComponent * 255))
        XCTAssertEqual(packed, expected,
                       String(format: "expected #%06X, got #%06X", expected, packed),
                       file: file, line: line)
    }

    private func alpha(of colour: Color) -> Double {
        Double(NSColor(colour).usingColorSpace(.sRGB)!.alphaComponent)
    }
}
