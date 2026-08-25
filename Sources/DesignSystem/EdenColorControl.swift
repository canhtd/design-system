import SwiftUI

/// The fills, edges, lifts and washes a view paints a *surface* with.
///
/// Same contract as the ink roles: the name says what is being painted, the
/// doc comment keeps the measured light value it stands for. Alpha-on-black is
/// how Eden draws almost all of them under light — which is exactly why they
/// cannot stay spelled at the call site, since black on a dark canvas paints
/// nothing.
extension EdenColor {
    // MARK: Controls

    /// The resting fill of Eden's pill controls — `+ New`, `Edit hashtags`:
    /// `white/80`, so the ground shows through.
    public static let controlFill = white(80)
    /// The same pill under the pointer: it goes fully opaque rather than
    /// changing hue.
    public static let controlFillHover = Color.white
    /// A pill's resting edge — `black/7%`.
    public static let controlBorder = black(7)
    /// That edge under the pointer, one step firmer — `black/10%`.
    public static let controlBorderHover = black(10)
    /// The h28 pill's single edge — `black/9%`. The small pill does not firm
    /// its edge on hover; only its fill and its ink move.
    public static let controlBorderSmall = black(9)
    /// The wash a borderless button takes under the pointer — the modal's
    /// `Cancel`. `black/4%`.
    public static let ghostHoverFill = black(4)

    /// The filter chip that is on. The same value as `card` under light, but
    /// its own role: it has to lift off the canvas, not match a card.
    public static let chipActiveFill = Color.white
    /// That chip's edge — `black/15%`, the firmest edge in the filter row.
    public static let chipActiveBorder = black(15)

    /// The track a segmented control sits in — `black/1.8%`.
    public static let segmentTrackFill = black(1.8)
    /// The track's edge — `black/6.5%`.
    public static let segmentTrackBorder = black(6.5)
    /// The chosen segment's own capsule inside that track — `black/5.5%`.
    public static let segmentSelectedFill = black(5.5)

    /// The plate under a `⌘ K` keycap — `black/5%`. The deprecated
    /// `EdenViewModes` draws its track on the same plate.
    public static let keycapFill = black(5)
    /// The square a `mono20` monogram's initial sits on — `black/6%`. The
    /// small monogram is tinted with `primaryTint` instead.
    public static let monogramFill = black(6)
    /// The 1 pt lift under a raised control — the current glyph in the
    /// deprecated `EdenViewModes`. `black/8%`.
    public static let raisedShadow = black(8)

    // MARK: Surfaces a view paints

    /// The edge of the inset pane a Board, a Chat or a split column sits on —
    /// `black/6%` (`edenPaneSurface`).
    public static let paneBorder = black(6)

    /// What the sidebar panel casts — `shadow-sm`, `black/10%`.
    public static let panelShadow = black(10)

    /// What Eden's floating chrome casts. Parameterised because the modifier
    /// is: a modal drops a deeper shadow than a toolbar does. `percent` is a
    /// percentage, as it is for `black(_:)`.
    public static func floatShadow(_ percent: Double) -> Color { black(percent) }

    /// `--background-page-gradient`'s two elliptical washes: the stronger one
    /// off the top-left corner, the softer one off the bottom-right. They are
    /// multiplied over the ground, so under light they are ink, not paint.
    public static let pageWashTop = black(5.5)
    public static let pageWashBottom = black(3)

    // MARK: The signal ladders' neutral rung

    /// `< 2×` on the Outlier ladder: the absence of a signal, drawn in neutral
    /// ink so that it never reads as one — `black/55%`.
    public static let signalNone = black(55)
    /// Its pill's edge, which does not follow the ladder's 25 % derivation —
    /// `black/10%`.
    public static let signalNoneBorder = black(10)
}
