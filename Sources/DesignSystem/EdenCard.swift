import SwiftUI

/// A **card** on a Board — Eden's `sticky-note-editor`: white paper holding
/// text and nothing else, which is how a card and a document tell themselves
/// apart (a document row has an icon tile, a title and an excerpt; a card row
/// is just its text).
///
/// Every value here was measured on a live card rather than read off Eden's
/// CSS for a card in Grid — `vessa-studio docs/research/eden-card.md`, captured
/// 2026-08-25 on app.eden.so at 1440×1000. The older description in
/// `eden-components.md` was a guess at the Grid view, and drawing a Board's
/// list with it is what made the first card drift.
///
/// A namespace of its own rather than members on `EdenColor` and friends: an
/// app may carry a local copy of those enums that shadows the package's, and a
/// token nobody can reach is worse than no token.
///
/// Ported from v0.2.17, which was cut off v0.2.16 and carried one value per
/// colour. Every colour is a pair here; nothing that is not a colour moved.
/// The lift is the exception to the flip the rest of the package makes: a
/// shadow under dark is deeper black, never lighter, because depth on a dark
/// ground is still depth (`EdenColor.raisedShadow`, `panelShadow`).
public enum EdenCard {
    // MARK: The box

    /// `1px rgba(70,60,45,.08)`. Warm, where a card's edge used to be the cool
    /// `#e2e8f0` — against white paper the warmth is what keeps the edge from
    /// reading as a table rule.
    ///
    /// Measured under dark: `--color-divider`, white 10 %. Warm ink cannot
    /// tint a dark ground — it only darkens it — so the edge flips to white,
    /// the same move `followUpBorder` and `cardItemBorder` make, and lands on
    /// the value Eden draws a card's own edge with.
    public static let borderWarm = EdenColor.dual(light: tinted(0x463C2D, 0.08),
                                                  dark: EdenColor.white(10))
    /// `14` — one step tighter than `EdenRadius.card`.
    public static let radius: CGFloat = 14
    /// 16 top, 24 sides, 22 bottom.
    public static let paddingTop: CGFloat = 16
    public static let paddingH: CGFloat = 24
    public static let paddingBottom: CGFloat = 22
    /// A composer keeps 52 at the bottom instead — the room the `New card ⌘↵`
    /// hint needs under the last line.
    public static let composerPaddingBottom: CGFloat = 52

    // MARK: The text

    /// What a reader sees: the editor's base is 16/24, but a paragraph in it
    /// renders at 17/26, and the paragraph is the card.
    public static let text = EdenTextStyle(size: 17, lineHeight: 26)
    public static let editorText = EdenTextStyle(size: 16, lineHeight: 24)
    /// `New card ⌘↵`, bottom-right of a composer.
    public static let hintText = EdenTextStyle(size: 13, lineHeight: 18)
    /// The hint's colour: `rgba(15,23,42,.5)` — the card's own ink at half
    /// strength rather than a grey of its own. Both halves are `ink` at 50 %,
    /// so the relationship survives the Appearance.
    public static let hint = EdenColor.dual(light: tinted(inkLight, 0.5),
                                            dark: tinted(inkDark, 0.5))

    /// `#0F172A`, the ink a card is set in. Measured under dark:
    /// `--color-text-dark-primary`, `#D9DCD8` — the page ink Eden sets a dark
    /// card in. The two differ under light, where a card's slate is its own
    /// colour, and meet under dark, where Eden has one ink for everything it
    /// draws on a dark surface.
    ///
    /// Public because a card's text is drawn with it; the lift is cast in
    /// `shadowLayer(_:)` instead, which does not follow the ink.
    public static let ink = EdenColor.dual(light: inkLight, dark: inkDark)

    // MARK: The lift

    /// Three stacked shadows, not one: a contact edge, a body and an ambient
    /// pool are what make paper look lifted off a page. A single blur reads as
    /// a drop shadow instead.
    public struct Shadow: Sendable {
        public let layers: [Layer]

        public struct Layer: Sendable {
            public let opacity: Double
            /// CSS blur is twice SwiftUI's radius, so an `18px` blur is `9`.
            public let radius: CGFloat
            public let y: CGFloat
        }
    }

    /// A saved card, at rest.
    public static let shadowRest = Shadow(layers: [
        .init(opacity: 0.024, radius: 1, y: 1),
        .init(opacity: 0.04, radius: 9, y: 7),
        .init(opacity: 0.02, radius: 16, y: 16),
    ])
    /// The composer: the same three, stronger and thrown further, so the card
    /// being typed into sits above the ones already saved.
    public static let shadowFocused = Shadow(layers: [
        .init(opacity: 0.03, radius: 2, y: 2),
        .init(opacity: 0.067, radius: 13, y: 11),
        .init(opacity: 0.043, radius: 21, y: 22),
    ])

    /// The colour one layer of a lift is cast in. The light half is the card's
    /// own slate at the layer's measured opacity, exactly as v0.2.17 cast it.
    ///
    /// The dark half is plain black, deepened: a 2 % pool under a card on
    /// `#1C1C1C` is not a lift at all. It follows `EdenColor.floatShadow(_:)`
    /// — five times the light opacity, capped at 60 % — so the three layers of
    /// a rest lift come out at 12 / 20 / 10 % rather than 2.4 / 4 / 2 %.
    public static func shadowLayer(_ opacity: Double) -> Color {
        EdenColor.dual(light: tinted(inkLight, opacity),
                       dark: EdenColor.black(min(opacity * 500, 60)))
    }

    // MARK: The two inks the pairs are cut from

    private static let inkLight: UInt32 = 0x0F172A
    private static let inkDark: UInt32 = 0xD9DCD8

    private static func tinted(_ value: UInt32, _ opacity: Double) -> Color {
        EdenColor.hex(value).opacity(opacity)
    }
}
