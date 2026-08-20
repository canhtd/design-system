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

    // MARK: Status
    /// The live dot on the `Daily pull` chip, as it reads on the page: the
    /// prototype's `#00bc7d` over `white/80` on canvas measures `#00B579`.
    public static let statusActive = hex(0x00B579)
    /// Its 2 pt halo — `rgba(0,188,125,.18)` resolved the same way.
    public static let statusActiveRing = hex(0xC9EAE0)
    /// `✓ Done · HH:MM` after a pull finishes.
    public static let statusDone = hex(0x007A55)
    /// The wash behind that line — `rgba(0,188,125,.09)`.
    public static let statusDoneTint = hex(0x00BC7D).opacity(0.09)

    // MARK: Destructive
    /// `--danger` — the one destructive colour: a `Delete…` row, a confirm
    /// sheet's committing button. Derived, not measured off Eden (round 7).
    public static let danger = hex(0xB42318)

    // MARK: - The Board

    /// Eden's **Card item** border (`eden-components.md` §3): a Note card is
    /// white paper with a 1 pt `#e2e8f0` edge. It replaced the yellow tint
    /// Studio had invented — Note and Document cards are told apart by depth,
    /// not by colour (r7.3).
    public static let cardItemBorder = hex(0xE2E8F0)

    /// The chip that means "no filter". It is not a section, so it keeps a
    /// neutral dot rather than taking one of the hues (`proto SECTIONS[0]`).
    public static let sectionAll = Color(.sRGB, red: 156 / 255, green: 163 / 255,
                                         blue: 175 / 255, opacity: 0.7)

    /// What a section's dot is painted, in the order sections are added
    /// (`proto SECTION_HUES`). It wraps, so a sixth section reuses the first
    /// hue rather than running out.
    public static let sectionHues: [Color] = [
        Color(.sRGB, red: 74 / 255, green: 222 / 255, blue: 128 / 255, opacity: 0.7),
        Color(.sRGB, red: 96 / 255, green: 165 / 255, blue: 250 / 255, opacity: 0.7),
        Color(.sRGB, red: 192 / 255, green: 132 / 255, blue: 252 / 255, opacity: 0.7),
        Color(.sRGB, red: 251 / 255, green: 146 / 255, blue: 60 / 255, opacity: 0.7),
    ]

    /// The hue a section takes from its place in the Board's own list.
    public static func sectionHue(_ index: Int) -> Color {
        guard index >= 0 else { return sectionAll }
        return sectionHues[index % sectionHues.count]
    }

    // MARK: - The Chat turn

    /// The user's own bubble: a soft top-lit gradient, not a flat fill
    /// (`proto --cc-user-bg`).
    public static let chatBubbleTop = hex(0xF6F8FA)
    public static let chatBubbleBottom = hex(0xEBEFF3)
    /// Its edge — `rgba(15,23,42,.10)` (`proto --cc-user-border`).
    public static let chatBubbleBorder = Color(.sRGB, red: 15 / 255, green: 23 / 255,
                                               blue: 42 / 255, opacity: 0.10)
    /// The count pill on the collapsed activity chip — `Opened item ×3`. Its
    /// own warm grey rather than the neutral ramp (`proto .cc-tool__count`).
    public static let chatCountText = hex(0x6B5E52)
    public static let chatCountTint = Color(.sRGB, red: 107 / 255, green: 94 / 255,
                                            blue: 82 / 255, opacity: 0.12)
    /// The follow-up card under a finished answer: a barely-there wash with a
    /// warm edge (`proto .cc-format-pick`).
    public static let followUpSurface = warm(0.019)
    public static let followUpBorder = warm(0.08)
    /// A chip that answers it, at rest and hovered.
    public static let followUpChipBorder = warm(0.10)
    public static let followUpChipHoverBorder = warm(0.20)
    public static let followUpChipHover = warm(0.03)

    /// Eden's warm ink — `rgba(70,60,45,a)`, what the chat's own surfaces are
    /// tinted with instead of plain black.
    public static func warm(_ alpha: Double) -> Color {
        Color(.sRGB, red: 70 / 255, green: 60 / 255, blue: 45 / 255, opacity: alpha)
    }

    // MARK: Rules
    /// The 1 px vertical rail drawn beside a sidebar group's child rows.
    /// `black/9%`, so it reads on `sidebar` without becoming a border.
    public static let guideRail = Color.black.opacity(0.09)
    /// The same rail one level deeper, where it must not compete with the
    /// rail beside it.
    public static let guideRailDeep = Color.black.opacity(0.06)
    /// What a modal is laid over: `rgba(20,18,16,.18)`.
    public static let scrim = Color(.sRGB, red: 20 / 255, green: 18 / 255, blue: 16 / 255,
                                    opacity: 0.18)

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
