import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// The other half of the token table: the fills, edges, lifts and washes, the
/// Board and the Chat turn, the rules, and the two signal ladders — each read
/// under both Appearances.
///
/// Almost every light half here is alpha-on-black, and almost every dark half
/// is alpha-on-white: that flip is the whole point of the ticket, since black
/// on a dark ground paints nothing. The three shadows deliberately do not
/// flip — they stay black and deepen.
@MainActor
final class EdenAppearanceControlTests: XCTestCase {
    private let black: UInt32 = 0x000000, white: UInt32 = 0xFFFFFF

    func testControlFillsAndEdges() {
        assertPair(EdenColor.controlFill, white, white, lightAlpha: 0.80, darkAlpha: 0.10)
        assertPair(EdenColor.controlFillHover, white, white, lightAlpha: 1, darkAlpha: 0.16)
        assertPair(EdenColor.controlBorder, black, white, lightAlpha: 0.07, darkAlpha: 0.10)
        assertPair(EdenColor.controlBorderHover, black, white, lightAlpha: 0.10, darkAlpha: 0.16)
        assertPair(EdenColor.controlBorderSmall, black, white, lightAlpha: 0.09, darkAlpha: 0.13)
        assertPair(EdenColor.ghostHoverFill, black, white, lightAlpha: 0.04, darkAlpha: 0.07)
    }

    /// The chip that is on takes Eden's measured field fill under dark, not
    /// the card: it has to lift off the canvas.
    func testChipSegmentAndComponentFills() {
        assertPair(EdenColor.chipActiveFill, white, 0x2A2A2A)
        assertPair(EdenColor.chipActiveBorder, black, white, lightAlpha: 0.15, darkAlpha: 0.20)
        assertPair(EdenColor.segmentTrackFill, black, white, lightAlpha: 0.018, darkAlpha: 0.04)
        assertPair(EdenColor.segmentTrackBorder, black, white, lightAlpha: 0.065, darkAlpha: 0.09)
        assertPair(EdenColor.segmentSelectedFill, black, white, lightAlpha: 0.055, darkAlpha: 0.10)
        assertPair(EdenColor.keycapFill, black, white, lightAlpha: 0.05, darkAlpha: 0.08)
        assertPair(EdenColor.monogramFill, black, white, lightAlpha: 0.06, darkAlpha: 0.09)
    }

    /// Depth on a dark ground is still a shadow. These are the only tokens
    /// that stay black in both Appearances.
    func testShadowsDeepenRatherThanFlip() {
        assertPair(EdenColor.raisedShadow, black, black, lightAlpha: 0.08, darkAlpha: 0.60)
        assertPair(EdenColor.panelShadow, black, black, lightAlpha: 0.10, darkAlpha: 0.55)
        assertPair(EdenColor.floatShadow(8), black, black, lightAlpha: 0.08, darkAlpha: 0.40)
        assertPair(EdenColor.floatShadow(30), black, black, lightAlpha: 0.30, darkAlpha: 0.60)
    }

    func testPaneEdgeAndPageWash() {
        assertPair(EdenColor.paneBorder, black, white, lightAlpha: 0.06, darkAlpha: 0.09)
        assertPair(EdenColor.pageWashTop, black, white, lightAlpha: 0.055, darkAlpha: 0.04)
        assertPair(EdenColor.pageWashBottom, black, white, lightAlpha: 0.03, darkAlpha: 0.025)
    }

    func testBoardAndRules() {
        assertPair(EdenColor.cardItemBorder, 0xE2E8F0, white, darkAlpha: 0.10)
        assertPair(EdenColor.guideRail, black, white, lightAlpha: 0.09, darkAlpha: 0.12)
        assertPair(EdenColor.guideRailDeep, black, white, lightAlpha: 0.06, darkAlpha: 0.08)
        assertPair(EdenColor.scrim, 0x141210, black, lightAlpha: 0.18, darkAlpha: 0.45)
        // A section's dot is one value: these hues already carry on both grounds.
        assertPair(EdenColor.sectionAll, 0x9CA3AF, 0x9CA3AF, lightAlpha: 0.7, darkAlpha: 0.7)
        for hue in EdenColor.sectionHues {
            XCTAssertEqual(hex(of: hue, .light), hex(of: hue, .dark))
        }
    }

    func testTheChatTurn() {
        assertPair(EdenColor.chatBubbleTop, 0xF6F8FA, 0x24282C)
        assertPair(EdenColor.chatBubbleBottom, 0xEBEFF3, 0x1E2124)
        assertPair(EdenColor.chatBubbleBorder, 0x0F172A, white, lightAlpha: 0.10, darkAlpha: 0.12)
        assertPair(EdenColor.chatCountText, 0x6B5E52, 0xB5A899)
        assertPair(EdenColor.chatCountTint, 0x6B5E52, 0xB5A899, lightAlpha: 0.12, darkAlpha: 0.14)
        assertPair(EdenColor.followUpSurface, 0x463C2D, white, lightAlpha: 0.019, darkAlpha: 0.07)
        assertPair(EdenColor.followUpBorder, 0x463C2D, white, lightAlpha: 0.08, darkAlpha: 0.10)
        assertPair(EdenColor.followUpChipBorder, 0x463C2D, white, lightAlpha: 0.10, darkAlpha: 0.12)
        assertPair(EdenColor.followUpChipHoverBorder, 0x463C2D, white,
                   lightAlpha: 0.20, darkAlpha: 0.22)
        assertPair(EdenColor.followUpChipHover, 0x463C2D, white, lightAlpha: 0.03, darkAlpha: 0.06)
    }

    /// The neutral rung and the seven hues. A band's fill and border are still
    /// derived from its hue at 8 % and 25 %, in both Appearances.
    func testSignalLadders() {
        assertPair(EdenColor.signalNone, black, white, lightAlpha: 0.55, darkAlpha: 0.45)
        assertPair(EdenColor.signalNoneBorder, black, white, lightAlpha: 0.10, darkAlpha: 0.16)
        assertPair(EdenSignal.outlier(2.5).hue, 0x0069A8, 0x6E96B8)
        assertPair(EdenSignal.outlier(4).hue, 0x007A55, 0x55C79A)
        assertPair(EdenSignal.outlier(9).hue, 0xE17100, 0xD4A83A)
        assertPair(EdenSignal.outlier(20).hue, 0xF54A00, 0xFF8A4C)
        assertPair(EdenSignal.outlier(91).hue, 0xEC003F, 0xFF6B81)
        assertPair(EdenSignal.percentile(93)!.hue, 0x7008E7, 0xA78BFA)
        assertPair(EdenSignal.percentile(97)!.hue, 0xA800B7, 0xD07BDF)
        assertPair(EdenSignal.percentile(100)!.hue, 0xEC003F, 0xFF6B81)
        assertPair(EdenSignal.outlier(1.5).fill, black, white,
                   lightAlpha: 0.55 * 0.08, darkAlpha: 0.45 * 0.08)
    }
}
