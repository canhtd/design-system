import SwiftUI

/// Eden's measured colour tokens.
///
/// Light values come from `docs/design/eden-tokens.md` in the VessaStudio repo
/// (computed styles read off app.eden.so at 1440 × 754 CSS px, DPR 2); one CSS
/// px is used as one point. Dark values come from the same app under
/// `prefers-color-scheme: dark`, measured 2026-08-25 and recorded in
/// `docs/specs/dark-appearance.md`; where that table had no row, the value is
/// derived and its doc comment says so.
///
/// Every semantic token is a `dual` pair and resolves from the window's
/// Appearance — see `EdenAppearance.swift`. Views never spell a colour
/// themselves: add it here so the next screen reuses the same value.
public enum EdenColor {
    // MARK: Surfaces
    /// The page itself — `--surface-canvas`.
    public static let canvas = dual(light: 0xFAFAF8, dark: 0x111111)
    /// The sidebar panel — `--surface-sidebar`.
    public static let sidebar = dual(light: 0xF4F3EE, dark: 0x171717)
    /// A card, a modal, a raised sheet — `--surface-card`.
    public static let card = dual(light: 0xFFFFFF, dark: 0x1C1C1C)
    /// What a floating menu is drawn on — `--color-background-menu`. The same
    /// white as `card` under light; under dark Eden lifts a popover a step
    /// clear of a card so the two do not merge.
    public static let menuSurface = dual(light: 0xFFFFFF, dark: 0x222222)

    // MARK: Text
    /// The page's own ink — `--color-text-dark-primary` under dark.
    public static let textPrimary = dual(light: 0x272523, dark: 0xD9DCD8)

    // MARK: Eden's neutral ramp
    /// The ramp is a **palette**, not a set of roles: it is light-only, it is
    /// the raw material the ink tokens in `EdenColorInk.swift` are cut from,
    /// and the Token Gallery displays it. Views never call it (ADR 0001).
    public static let n900 = hex(0x171717)
    public static let n800 = hex(0x262626)
    public static let n700 = hex(0x404040)
    public static let n600 = hex(0x525252)
    public static let n500 = hex(0x737373)
    public static let n400 = hex(0xA1A1A1)
    public static let n300 = hex(0xD4D4D4)
    public static let n200 = hex(0xE5E5E5)

    // MARK: Accent
    /// `--color-primary` / `--workspace-primary`: the deep green under light,
    /// the one that survives on a dark ground under dark.
    public static let primary = dual(light: 0x09321F, dark: 0x73B490)
    /// `--color-button-primary-default-text`, the ink on a primary button.
    /// Measured the same under both Appearances.
    public static let primary5 = hex(0xEFF2EE)
    /// `--color-button-primary-default-background`.
    public static let primary80 = dual(light: 0x224735, dark: 0x395A4B)
    /// `--color-accent-olive`.
    public static let olive = dual(light: 0x39624D, dark: 0x73B490)
    /// The hover fill of the primary action — `primary80` lifted one step.
    /// Derived: the dark half lifts `#395A4B` by the same distance the light
    /// half lifts `#224735`.
    public static let primaryHover = dual(light: 0x375847, dark: 0x4E6B5D)
    /// The wash behind a monogram, never a text colour — `primary` at 9 %
    /// under light, `--color-background-primary-selected` (the accent at 15 %)
    /// under dark.
    public static let primaryTint = dual(light: hex(0x09321F).opacity(0.09),
                                         dark: hex(0x73B490).opacity(0.15))
    /// The border Eden's floating chrome and modals use —
    /// `--color-border-subtle`.
    public static let hairline = dual(light: 0xE0E0E0, dark: 0x2F2F2F)

    // MARK: Status
    /// The live dot on the `Daily pull` chip. Light is the prototype's
    /// `#00bc7d` over `white/80` on canvas, measured `#00B579`; dark is
    /// derived — the same green lifted so it still reads as lit on `#111`.
    public static let statusActive = dual(light: 0x00B579, dark: 0x00C98A)
    /// Its 2 pt halo. Both halves are the dot at 18 % composited on their own
    /// canvas, which is how the light value was derived in the first place.
    public static let statusActiveRing = dual(light: 0xC9EAE0, dark: 0x0E3227)
    /// `✓ Done · HH:MM` after a pull finishes. The dark half is derived: the
    /// light green is 2.1:1 on `#111` and had to come up to carry text.
    public static let statusDone = dual(light: 0x007A55, dark: 0x34C88F)
    /// The wash behind that line — `rgba(0,188,125,.09)`, derived a little
    /// stronger under dark where a 9 % wash disappears.
    public static let statusDoneTint = dual(light: hex(0x00BC7D).opacity(0.09),
                                            dark: hex(0x00C98A).opacity(0.14))

    // MARK: Destructive
    /// `--danger` — the one destructive colour: a `Delete…` row, a confirm
    /// sheet's committing button. Light is derived (round 7); dark is
    /// `--color-text-dark-error`, which is a *light* red, so what sits on it
    /// is `textInverse` rather than white.
    public static let danger = dual(light: 0xB42318, dark: 0xE5737A)

    // MARK: Palette helpers
    /// Eden's warm ink — `rgba(70,60,45,a)`, what the chat's own surfaces are
    /// tinted with instead of plain black.
    public static func warm(_ alpha: Double) -> Color {
        Color(.sRGB, red: 70 / 255, green: 60 / 255, blue: 45 / 255, opacity: alpha)
    }

    /// Cards, pills and modals are painted with alpha-on-black rather than the
    /// neutral ramp; `black(6)` reads as Tailwind's `black/[0.06]`. A palette
    /// helper: it is one half of a pair, never a token on its own.
    public static func black(_ percent: Double) -> Color { Color.black.opacity(percent / 100) }
    /// `white/80` — the search pill, `+ New`, floating toolbars. The other
    /// half of most pairs, since black-on-black paints nothing.
    public static func white(_ percent: Double) -> Color { Color.white.opacity(percent / 100) }

    public static func hex(_ value: UInt32) -> Color {
        Color(.sRGB,
              red: Double((value >> 16) & 0xFF) / 255,
              green: Double((value >> 8) & 0xFF) / 255,
              blue: Double(value & 0xFF) / 255,
              opacity: 1)
    }
}
