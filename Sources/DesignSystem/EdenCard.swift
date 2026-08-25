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
public enum EdenCard {
    // MARK: The box

    /// `1px rgba(70,60,45,.08)`. Warm, where a card's edge used to be the cool
    /// `#e2e8f0` — against white paper the warmth is what keeps the edge from
    /// reading as a table rule.
    public static let borderWarm = EdenColor.hex(0x463C2D).opacity(0.08)
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
    /// strength rather than a grey of its own.
    public static let hint = ink.opacity(0.5)

    /// `#0F172A`, the ink a card is set in and the colour its lift is cast in.
    static let ink = EdenColor.hex(0x0F172A)

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
}

extension View {
    /// Casts one of `EdenCard`'s two lifts.
    public func edenCardShadow(_ shadow: EdenCard.Shadow) -> some View {
        shadow.layers.reduce(AnyView(self)) { view, layer in
            AnyView(view.shadow(color: EdenCard.ink.opacity(layer.opacity),
                                radius: layer.radius, y: layer.y))
        }
    }
}
