import SwiftUI

/// Eden's measured colour tokens.
///
/// Every value comes from `docs/design/eden-tokens.md` in the VessaStudio repo
/// (computed styles read off app.eden.so at 1440 × 754 CSS px, DPR 2); one CSS
/// px is used as one point. Views never spell a colour themselves: add it here
/// so the next screen reuses the same value.
public enum EdenColor {
    // MARK: Surfaces
    public static let canvas = hex(0xFAFAF8)
    public static let sidebar = hex(0xF4F3EE)
    public static let card = Color.white

    // MARK: Text — Eden's neutral ramp
    public static let textPrimary = hex(0x272523)
    public static let n900 = hex(0x171717)
    public static let n800 = hex(0x262626)
    public static let n700 = hex(0x404040)
    public static let n600 = hex(0x525252)
    public static let n500 = hex(0x737373)
    public static let n400 = hex(0xA1A1A1)
    public static let n300 = hex(0xD4D4D4)
    public static let n200 = hex(0xE5E5E5)

    // MARK: Accent
    /// `--color-primary` / `--workspace-primary`, the deep green.
    public static let primary = hex(0x09321F)
    /// `--color-primary-5`, the text colour on a primary button.
    public static let primary5 = hex(0xEFF2EE)
    /// `--color-button-primary-default-background`.
    public static let primary80 = hex(0x224735)
    public static let olive = hex(0x39624D)
    /// The hover fill of the primary action — `primary80` lifted one step.
    public static let primaryHover = hex(0x375847)
    /// `primary` at 9% — the wash behind a monogram, never a text colour.
    public static let primaryTint = primary.opacity(0.09)
    /// `#E0E0E0` — the border Eden's floating chrome and modals use.
    public static let hairline = hex(0xE0E0E0)

    // MARK: Rules
    /// The 1 px vertical rail drawn beside a sidebar group's child rows.
    /// `black/9%`, so it reads on `sidebar` without becoming a border.
    public static let guideRail = Color.black.opacity(0.09)

    /// Cards, pills and modals are painted with alpha-on-black rather than the
    /// neutral ramp; `black(6)` reads as Tailwind's `black/[0.06]`.
    public static func black(_ percent: Double) -> Color { Color.black.opacity(percent / 100) }
    /// `white/80` — the search pill, `+ New`, floating toolbars.
    public static func white(_ percent: Double) -> Color { Color.white.opacity(percent / 100) }

    public static func hex(_ value: UInt32) -> Color {
        Color(.sRGB,
              red: Double((value >> 16) & 0xFF) / 255,
              green: Double((value >> 8) & 0xFF) / 255,
              blue: Double(value & 0xFF) / 255,
              opacity: 1)
    }
}
