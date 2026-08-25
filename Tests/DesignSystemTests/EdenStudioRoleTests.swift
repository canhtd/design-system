import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// The roles v0.3.1 adds, both halves.
///
/// These exist because VessaStudio's sweep for its own dark Appearance found
/// 46 call sites whose literal was a point or two away from the nearest role
/// in the package (`vessa-studio docs/design/refs/dark-appearance-deltas.md`,
/// issue #4). Studio may not carry a colour of its own, so the exact value
/// belongs here — which makes each **light** half below a contract, not a
/// preference: it is the literal the view had on `main`, and a drift of one
/// point is the delta the role was added to remove.
///
/// The dark halves are measured where Eden has a variable for the same role on
/// a comparable ground, and derived where it does not; each token's doc comment
/// says which, and `swift test` pins the number either way.
@MainActor
final class EdenStudioRoleTests: XCTestCase {
    private let black: UInt32 = 0x000000, white: UInt32 = 0xFFFFFF

    /// The rule inside a surface. Its dark half is Eden's own
    /// `--color-neutral-dark-10`, and the point of the role is that it lands
    /// *under* `paneBorder` — a full-width hairline at 9 reads as a bar.
    func testTheFaintRuleIsQuieterThanAPaneEdge() {
        assertPair(EdenColor.ruleFaint, black, white, lightAlpha: 0.06, darkAlpha: 0.08)
        XCTAssertLessThan(alpha(of: EdenColor.ruleFaint, .dark),
                          alpha(of: EdenColor.paneBorder, .dark),
                          "a rule inside a surface must stay under the edge of a pane")
    }

    /// The composer: a plate over the page wash, with a well cut into it. The
    /// pair only works if the well stays recessed under the plate in both
    /// Appearances — under light by being ink where the plate is white, under
    /// dark by being the smaller of two whites.
    func testTheComposerPlateAndItsWell() {
        assertPair(EdenColor.composerFill, white, white, lightAlpha: 0.60, darkAlpha: 0.08)
        assertPair(EdenColor.inputFieldFill, black, white, lightAlpha: 0.03, darkAlpha: 0.05)
        assertPair(EdenColor.inputFieldBorder, black, white, lightAlpha: 0.08, darkAlpha: 0.11)

        XCTAssertLessThan(alpha(of: EdenColor.inputFieldFill, .dark),
                          alpha(of: EdenColor.composerFill, .dark),
                          "the well has to read as cut into the plate, not laid on it")
        XCTAssertGreaterThan(alpha(of: EdenColor.inputFieldFill, .dark),
                             alpha(of: EdenColor.segmentTrackFill, .dark),
                             "a field a person types into is deeper than a segmented track")
        XCTAssertGreaterThan(alpha(of: EdenColor.inputFieldBorder, .dark),
                             alpha(of: EdenColor.controlBorder, .dark),
                             "a field's edge is one step firmer than a control's")
    }

    /// The two hover edges. Each one exists because the role under it is too
    /// quiet for what it is drawn on, so each one has to stay above it.
    func testHoverEdgesStayAboveTheRoleTheyWereSplitFrom() {
        assertPair(EdenColor.cardHoverBorder, black, white, lightAlpha: 0.12, darkAlpha: 0.18)
        assertPair(EdenColor.chipHoverBorder, black, white, lightAlpha: 0.17, darkAlpha: 0.24)

        for appearance in [EdenTestAppearance.light, .dark] {
            XCTAssertGreaterThan(alpha(of: EdenColor.cardHoverBorder, appearance),
                                 alpha(of: EdenColor.controlBorderHover, appearance),
                                 "a card's hovered edge is louder than a control's")
            XCTAssertGreaterThan(alpha(of: EdenColor.chipHoverBorder, appearance),
                                 alpha(of: EdenColor.chipActiveBorder, appearance),
                                 "a hovered chip is louder than a chip at rest")
        }
    }

    /// The two washes. `plateFill` sits a point over the avatar's own fill;
    /// `sheetFooterFill` is the quietest wash in the package.
    func testThePlateAndTheFooterWash() {
        assertPair(EdenColor.plateFill, black, white, lightAlpha: 0.07, darkAlpha: 0.11)
        assertPair(EdenColor.sheetFooterFill, black, white, lightAlpha: 0.012, darkAlpha: 0.03)

        for appearance in [EdenTestAppearance.light, .dark] {
            XCTAssertGreaterThan(alpha(of: EdenColor.plateFill, appearance),
                                 alpha(of: EdenColor.monogramFill, appearance),
                                 "a sidebar plate carries a point more than an avatar")
            XCTAssertLessThan(alpha(of: EdenColor.sheetFooterFill, appearance),
                              alpha(of: EdenColor.segmentTrackFill, appearance),
                              "a footer wash is quieter than the quietest track")
        }
    }

    /// Ink on a `primary` fill: white under both Appearances, and a pair so
    /// that the decision is written down rather than implied.
    func testTheInkOnAPrimaryFillIsWhiteInBothAppearances() {
        assertPair(EdenColor.onPrimaryInk, white, white)
        XCTAssertNotEqual(hex(of: EdenColor.onPrimaryInk, .light),
                          hex(of: EdenColor.primary5, .light),
                          "primary5 is a surface tint, not the ink on a fill")
    }

    private func alpha(of colour: Color, _ appearance: EdenTestAppearance) -> Double {
        Double(resolved(colour, appearance).alphaComponent)
    }
}
