import SwiftUI

/// The Board, the Chat turn, and the rules drawn between things.
///
/// These left `EdenColor.swift` when every token grew a second value; they are
/// the same tokens, under the same names. Where the dark half is not in
/// `docs/specs/dark-appearance.md`'s table it is derived, and says so.
extension EdenColor {
    // MARK: - The Board

    /// Eden's **Card item** border (`eden-components.md` §3): a Note card is
    /// white paper with a 1 pt `#e2e8f0` edge. It replaced the yellow tint
    /// Studio had invented — Note and Document cards are told apart by depth,
    /// not by colour (r7.3). Dark is `--color-divider`, white 10 %.
    public static let cardItemBorder = dual(light: hex(0xE2E8F0), dark: white(10))

    /// The chip that means "no filter". It is not a section, so it keeps a
    /// neutral dot rather than taking one of the hues (`proto SECTIONS[0]`).
    /// One value: a mid grey at 70 % reads on both grounds.
    public static let sectionAll = Color(.sRGB, red: 156 / 255, green: 163 / 255,
                                         blue: 175 / 255, opacity: 0.7)

    /// What a section's dot is painted, in the order sections are added
    /// (`proto SECTION_HUES`). It wraps, so a sixth section reuses the first
    /// hue rather than running out. One value each: all four are already the
    /// light end of their hue and carry on a dark ground unchanged.
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
    /// (`proto --cc-user-bg`). Derived under dark — the same two-step lift,
    /// built up from the card rather than down from white.
    public static let chatBubbleTop = dual(light: 0xF6F8FA, dark: 0x24282C)
    public static let chatBubbleBottom = dual(light: 0xEBEFF3, dark: 0x1E2124)
    /// Its edge — `rgba(15,23,42,.10)` (`proto --cc-user-border`), derived as
    /// white 12 % under dark.
    public static let chatBubbleBorder = dual(
        light: Color(.sRGB, red: 15 / 255, green: 23 / 255, blue: 42 / 255, opacity: 0.10),
        dark: white(12)
    )
    /// The count pill on the collapsed activity chip — `Opened item ×3`. Its
    /// own warm grey rather than the neutral ramp (`proto .cc-tool__count`);
    /// derived under dark as the same warmth read light-on-dark.
    public static let chatCountText = dual(light: 0x6B5E52, dark: 0xB5A899)
    public static let chatCountTint = dual(
        light: Color(.sRGB, red: 107 / 255, green: 94 / 255, blue: 82 / 255, opacity: 0.12),
        dark: Color(.sRGB, red: 181 / 255, green: 168 / 255, blue: 153 / 255, opacity: 0.14)
    )
    /// The follow-up card under a finished answer: a barely-there wash with a
    /// warm edge (`proto .cc-format-pick`). Under dark the warm ink cannot
    /// tint anything, so both are derived from white.
    public static let followUpSurface = dual(light: warm(0.019), dark: white(7))
    public static let followUpBorder = dual(light: warm(0.08), dark: white(10))
    /// A chip that answers it, at rest and hovered.
    public static let followUpChipBorder = dual(light: warm(0.10), dark: white(12))
    public static let followUpChipHoverBorder = dual(light: warm(0.20), dark: white(22))
    public static let followUpChipHover = dual(light: warm(0.03), dark: white(6))

    // MARK: - Rules

    /// A 1 pt rule or divider drawn *inside* a surface: the line under a
    /// command palette's search field, a sheet's footer rule, the line above
    /// the sidebar's foot. Distinct from `paneBorder`, which edges a whole
    /// pane — a full-width hairline at `paneBorder`'s `white(9)` stops reading
    /// as a separation under dark and starts reading as a bar.
    ///
    /// Measured: `--color-neutral-dark-10`, `#FFFFFF14`. Eden splits one light
    /// value into two dark ones — under light this variable and
    /// `--color-divider` are both `#2725231A`, and under dark the divider goes
    /// to white 10 % while this stays at 8 %. That split is exactly the
    /// distinction the role is for, so the value is Eden's own rather than a
    /// step invented under `paneBorder`.
    public static let ruleFaint = dual(light: black(6), dark: white(8))

    /// The 1 px vertical rail drawn beside a sidebar group's child rows.
    /// `black/9%` under light, so it reads on `sidebar` without becoming a
    /// border; white 12 % under dark, where black would vanish.
    public static let guideRail = dual(light: black(9), dark: white(12))
    /// The same rail one level deeper, where it must not compete with the
    /// rail beside it.
    public static let guideRailDeep = dual(light: black(6), dark: white(8))
    /// What a modal is laid over: `rgba(20,18,16,.18)`. Derived deeper under
    /// dark — 18 % over `#111` does not read as "the page is behind this".
    public static let scrim = dual(
        light: Color(.sRGB, red: 20 / 255, green: 18 / 255, blue: 16 / 255, opacity: 0.18),
        dark: black(45)
    )
}
