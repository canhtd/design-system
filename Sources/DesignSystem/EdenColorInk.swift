import SwiftUI

/// Ink — every colour a view paints a letter or a glyph with.
///
/// These are roles, not ramp steps: a view asks for the ink of a *hovered
/// control* or of a *disabled label*, and the token decides which value that
/// is under the Appearance it is drawn in. The light half is the ramp step the
/// call site used to spell, named in each doc comment so the measurement is
/// not lost; the dark half is measured where
/// `docs/specs/dark-appearance.md` had a row and derived where it did not.
///
/// Every role except `textTertiary` and `textFaint` clears 4.5:1 on both
/// `canvas` and `card` in both Appearances — those two are the ink of
/// something switched off, and are held to legibility, not to the text floor.
extension EdenColor {
    // MARK: Ink

    /// The loudest ink a control takes: a pill button under the pointer, a
    /// filter chip that is on. Light `#171717` (`n900`); dark is derived as
    /// Eden's own near-white, the same value it puts on a filled button.
    public static let textStrong = dual(light: 0x171717, dark: 0xEFF2EE)

    /// The chosen segment of a segmented track. Half a step quieter than
    /// `textStrong` — which is how Eden draws it, so the two are separate
    /// roles rather than one. Light `#262626` (`n800`); dark lands on the
    /// measured page ink, which is the step below near-white.
    public static let textSelected = dual(light: 0x262626, dark: 0xD9DCD8)

    /// A control's resting label — `+ New`, `Edit hashtags` — and the initial
    /// in a `mono20` monogram. Light `#404040` (`n700`), dark
    /// `--color-icon-dark-secondary`.
    public static let textControl = dual(light: 0x404040, dark: 0xC3C3C3)

    /// The resting label of a control with no fill of its own: the modal's
    /// `Cancel`. Light `#525252` (`n600`); dark derived one step under
    /// `textControl`, keeping the light ladder's spacing.
    public static let textControlQuiet = dual(light: 0x525252, dark: 0xADADAD)

    /// Secondary ink: a resting filter chip, an unchosen segment, a popover's
    /// section header, the letter on a keycap. Light `#737373` (`n500`), dark
    /// `--color-text-dark-secondary`.
    public static let textSecondary = dual(light: 0x737373, dark: 0x919191)

    /// Tertiary ink: a disabled label, an unchosen view-mode glyph. Light
    /// `#A1A1A1` (`n400`); dark derived between `#919191` and `#2F2F2F` as the
    /// spec's table asks. Deliberately under the text floor in both — a
    /// disabled label is meant to read as unavailable.
    public static let textTertiary = dual(light: 0xA1A1A1, dark: 0x6E6E6E)

    /// The faintest ink — the letter on a keycap whose row is not there yet,
    /// so the row reads as waiting rather than as switched off. Light
    /// `#D4D4D4` (`n300`); dark derived at the mirrored distance from its own
    /// ground.
    public static let textFaint = dual(light: 0xD4D4D4, dark: 0x4D4D4D)

    /// The ink on a filled, saturated button: the destructive `Delete` on
    /// `danger`. White in both Appearances — `danger` is a fill that stays
    /// dark enough to carry white ink, rather than a light red that would
    /// force the ink to invert with it. The filled primary button has its own
    /// measured `primary5`.
    public static let textInverse = hex(0xFFFFFF)
}
