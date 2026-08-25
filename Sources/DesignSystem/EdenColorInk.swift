import SwiftUI

/// Ink — every colour a view paints a letter or a glyph with.
///
/// These are roles, not ramp steps: a view asks for the ink of a *hovered
/// control* or of a *disabled label*, and the token decides which value that
/// is. Today each one resolves to the light value the call site used to spell
/// (its ramp step is named in the doc comment so the measurement is not lost);
/// the Appearance work replaces the value, never the name.
extension EdenColor {
    // MARK: Ink

    /// The loudest ink a control takes: a pill button under the pointer, a
    /// filter chip that is on. Light `#171717` (`n900`).
    public static let textStrong = n900

    /// The chosen segment of a segmented track. Half a step quieter than
    /// `textStrong` — which is how Eden draws it, so the two are separate
    /// roles rather than one. Light `#262626` (`n800`).
    public static let textSelected = n800

    /// A control's resting label — `+ New`, `Edit hashtags` — and the initial
    /// in a `mono20` monogram. Light `#404040` (`n700`).
    public static let textControl = n700

    /// The resting label of a control with no fill of its own: the modal's
    /// `Cancel`. Light `#525252` (`n600`).
    public static let textControlQuiet = n600

    /// Secondary ink: a resting filter chip, an unchosen segment, a popover's
    /// section header, the letter on a keycap. Light `#737373` (`n500`).
    public static let textSecondary = n500

    /// Tertiary ink: a disabled label, an unchosen view-mode glyph. Light
    /// `#A1A1A1` (`n400`).
    public static let textTertiary = n400

    /// The faintest ink — the letter on a keycap whose row is not there yet,
    /// so the row reads as waiting rather than as switched off. Light
    /// `#D4D4D4` (`n300`).
    public static let textFaint = n300

    /// The ink on a filled, saturated button: the destructive `Delete` on
    /// `danger`. The filled primary button has its own `primary5`, measured
    /// off Eden, and does not use this.
    public static let textInverse = Color.white
}
