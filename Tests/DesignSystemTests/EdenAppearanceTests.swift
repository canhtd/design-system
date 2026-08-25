import AppKit
import DesignSystem
import SwiftUI
import XCTest

/// Every semantic token, read under both Appearances.
///
/// A token is a pair now, so a test that reads it once tests half of it. Each
/// case below resolves the token inside a real `NSAppearance` — the same thing
/// AppKit does when it draws — and asserts both halves against
/// `docs/specs/dark-appearance.md`. The light half is also the pixel contract
/// from issue #2: if one of these moves, the goldens move with it.
@MainActor
final class EdenAppearanceTests: XCTestCase {
    func testTheMechanismResolvesFromTheDrawingAppearance() {
        let token = EdenColor.dual(light: 0xFFFFFF, dark: 0x000000)
        XCTAssertEqual(hex(of: token, .light), 0xFFFFFF)
        XCTAssertEqual(hex(of: token, .dark), 0x000000)
        // And the package never decides for itself which one is current.
        XCTAssertTrue(NSAppearance(named: .darkAqua)!.isDark)
        XCTAssertFalse(NSAppearance(named: .aqua)!.isDark)
        XCTAssertTrue(NSAppearance(named: .accessibilityHighContrastDarkAqua)!.isDark)
    }

    func testSurfaces() {
        assertPair(EdenColor.canvas, 0xFAFAF8, 0x111111)
        assertPair(EdenColor.sidebar, 0xF4F3EE, 0x171717)
        assertPair(EdenColor.card, 0xFFFFFF, 0x1C1C1C)
        assertPair(EdenColor.menuSurface, 0xFFFFFF, 0x222222)
        assertPair(EdenColor.textPrimary, 0x272523, 0xD9DCD8)
    }

    func testAccent() {
        assertPair(EdenColor.primary, 0x09321F, 0x73B490)
        assertPair(EdenColor.primary80, 0x224735, 0x395A4B)
        assertPair(EdenColor.olive, 0x39624D, 0x73B490)
        assertPair(EdenColor.primaryHover, 0x375847, 0x4E6B5D)
        assertPair(EdenColor.hairline, 0xE0E0E0, 0x2F2F2F)
        // Measured the same in both, so it is not a pair.
        assertPair(EdenColor.primary5, 0xEFF2EE, 0xEFF2EE)
        assertPair(EdenColor.primaryTint, 0x09321F, 0x73B490,
                   lightAlpha: 0.09, darkAlpha: 0.15)
    }

    func testStatusAndDanger() {
        assertPair(EdenColor.statusActive, 0x00B579, 0x00C98A)
        assertPair(EdenColor.statusActiveRing, 0xC9EAE0, 0x0E3227)
        assertPair(EdenColor.statusDone, 0x007A55, 0x34C88F)
        assertPair(EdenColor.statusDoneTint, 0x00BC7D, 0x00C98A,
                   lightAlpha: 0.09, darkAlpha: 0.14)
        assertPair(EdenColor.danger, 0xB42318, 0xCC3B2C)
    }

    func testInk() {
        assertPair(EdenColor.textStrong, 0x171717, 0xEFF2EE)
        assertPair(EdenColor.textSelected, 0x262626, 0xD9DCD8)
        assertPair(EdenColor.textControl, 0x404040, 0xC3C3C3)
        assertPair(EdenColor.textControlQuiet, 0x525252, 0xADADAD)
        assertPair(EdenColor.textSecondary, 0x737373, 0x919191)
        assertPair(EdenColor.textTertiary, 0xA1A1A1, 0x6E6E6E)
        assertPair(EdenColor.textFaint, 0xD4D4D4, 0x4D4D4D)
        assertPair(EdenColor.textInverse, 0xFFFFFF, 0xFFFFFF)
    }

    /// The ramp stays a light-only palette: it is what the ink roles are cut
    /// from, and the Gallery displays it. It must NOT follow the Appearance
    /// (ADR 0001 rejected inverting the ramp).
    func testTheRampIsNotAPair() {
        let ramp = [EdenColor.n900, EdenColor.n800, EdenColor.n700, EdenColor.n600,
                    EdenColor.n500, EdenColor.n400, EdenColor.n300, EdenColor.n200]
        for step in ramp {
            XCTAssertEqual(hex(of: step, .light), hex(of: step, .dark),
                           "a ramp step followed the Appearance")
        }
    }
}
