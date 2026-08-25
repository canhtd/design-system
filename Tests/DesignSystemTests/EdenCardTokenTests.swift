import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// `EdenCard`, ported from v0.2.17 onto 0.3.x.
///
/// Two things are being held at once. Every **colour** gained a second half,
/// so each is read under both Appearances. Everything that is **not** a colour
/// — the radius, the four paddings, the three faces — was measured on a live
/// card and must come across byte-for-byte: the port is a port, and a number
/// that moved here is a number that moved for no reason.
@MainActor
final class EdenCardTokenTests: XCTestCase {
    // MARK: The colours

    /// The edge, the ink and the hint. The warm edge cannot stay warm under
    /// dark — warm ink on a dark ground only darkens it — so it flips to
    /// Eden's measured `--color-divider`.
    func testTheCardsColoursCarryBothHalves() {
        assertPair(EdenCard.borderWarm, 0x463C2D, 0xFFFFFF,
                   lightAlpha: 0.08, darkAlpha: 0.10)
        assertPair(EdenCard.ink, 0x0F172A, 0xD9DCD8)
        assertPair(EdenCard.hint, 0x0F172A, 0xD9DCD8,
                   lightAlpha: 0.5, darkAlpha: 0.5)
    }

    /// The hint is the card's own ink at half strength, not a grey of its own
    /// — in both Appearances, which is the part a pair could quietly lose.
    func testTheHintIsTheCardsOwnInkHalved() {
        for appearance in [EdenTestAppearance.light, .dark] {
            XCTAssertEqual(hex(of: EdenCard.hint, appearance),
                           hex(of: EdenCard.ink, appearance),
                           "the hint took a colour of its own under \(appearance)")
        }
    }

    /// The lift is the one place the package does not flip to white: a shadow
    /// under dark is deeper black. Every layer of both lifts is checked, and
    /// the dark half follows `floatShadow`'s rule — five times the light
    /// opacity, capped at 60 %.
    func testEveryShadowLayerGoesDeeperUnderDarkRatherThanLighter() {
        for (name, lift) in [("rest", EdenCard.shadowRest), ("focused", EdenCard.shadowFocused)] {
            for (index, layer) in lift.layers.enumerated() {
                let colour = EdenCard.shadowLayer(layer.opacity)
                XCTAssertEqual(hex(of: colour, .light), 0x0F172A, "\(name) layer \(index) light")
                XCTAssertEqual(hex(of: colour, .dark), 0x000000,
                               "\(name) layer \(index) went light — a lift became a halo")
                XCTAssertEqual(alpha(of: colour, .light), layer.opacity, accuracy: 0.001,
                               "\(name) layer \(index) light opacity")
                XCTAssertEqual(alpha(of: colour, .dark), min(layer.opacity * 5, 0.60),
                               accuracy: 0.001, "\(name) layer \(index) dark opacity")
                XCTAssertGreaterThan(alpha(of: colour, .dark), alpha(of: colour, .light),
                                     "\(name) layer \(index) must deepen under dark")
            }
        }
        // And the cap is real, not decoration.
        XCTAssertEqual(alpha(of: EdenCard.shadowLayer(0.5), .dark), 0.60, accuracy: 0.001)
    }

    // MARK: What the port must not have moved

    /// `vessa-studio docs/research/eden-card.md`, captured 2026-08-25 on a live
    /// card. Fix the token, never the expectation.
    func testTheBoxKeepsItsMeasuredGeometry() {
        XCTAssertEqual(EdenCard.radius, 14)
        XCTAssertEqual(EdenCard.paddingTop, 16)
        XCTAssertEqual(EdenCard.paddingH, 24)
        XCTAssertEqual(EdenCard.paddingBottom, 22)
        XCTAssertEqual(EdenCard.composerPaddingBottom, 52)
        // One step tighter than a content card, which is the whole reason the
        // card does not simply take `EdenRadius.card`.
        XCTAssertLessThan(EdenCard.radius, EdenRadius.card)
    }

    /// The editor's base is 16/24, but a paragraph in it renders at 17/26 —
    /// and the paragraph is what a reader sees.
    func testTheTextKeepsItsMeasuredFaces() {
        XCTAssertEqual(EdenCard.text.size, 17)
        XCTAssertEqual(EdenCard.text.lineHeight, 26)
        XCTAssertEqual(EdenCard.editorText.size, 16)
        XCTAssertEqual(EdenCard.editorText.lineHeight, 24)
        XCTAssertEqual(EdenCard.hintText.size, 13)
        XCTAssertEqual(EdenCard.hintText.lineHeight, 18)
    }

    /// Three stacked layers each, at the opacities, blurs and offsets measured
    /// off the live card. A single blur reads as a drop shadow, not as paper.
    func testBothLiftsKeepTheirThreeMeasuredLayers() {
        XCTAssertEqual(EdenCard.shadowRest.layers.count, 3)
        XCTAssertEqual(EdenCard.shadowFocused.layers.count, 3)

        assertLayers(EdenCard.shadowRest, [(0.024, 1, 1), (0.04, 9, 7), (0.02, 16, 16)])
        assertLayers(EdenCard.shadowFocused, [(0.03, 2, 2), (0.067, 13, 11), (0.043, 21, 22)])

        // The composer sits above the cards already saved, layer for layer.
        for (focused, rest) in zip(EdenCard.shadowFocused.layers, EdenCard.shadowRest.layers) {
            XCTAssertGreaterThan(focused.opacity, rest.opacity)
            XCTAssertGreaterThan(focused.radius, rest.radius)
        }
    }

    private func assertLayers(_ shadow: EdenCard.Shadow,
                              _ expected: [(Double, CGFloat, CGFloat)],
                              file: StaticString = #filePath, line: UInt = #line) {
        for (index, layer) in shadow.layers.enumerated() {
            XCTAssertEqual(layer.opacity, expected[index].0, accuracy: 0.0001,
                           "layer \(index) opacity", file: file, line: line)
            XCTAssertEqual(layer.radius, expected[index].1, "layer \(index) radius",
                           file: file, line: line)
            XCTAssertEqual(layer.y, expected[index].2, "layer \(index) y",
                           file: file, line: line)
        }
    }

    private func alpha(of colour: Color, _ appearance: EdenTestAppearance) -> Double {
        Double(resolved(colour, appearance).alphaComponent)
    }
}
