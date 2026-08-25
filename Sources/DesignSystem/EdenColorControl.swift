import SwiftUI

/// The fills, edges, lifts and washes a view paints a *surface* with.
///
/// Same contract as the ink roles: the name says what is being painted, the
/// doc comment keeps the measured light value it stands for. Alpha-on-black is
/// how Eden draws almost all of these under light — which is exactly why they
/// could not stay spelled at the call site, since black on a dark ground
/// paints nothing. Under dark each one flips to white at the percentage that
/// lands on the measured surface: white 10 % over `#111` is `#292929`, which
/// is Eden's own `--color-background-field`.
///
/// The three shadows are the exception: they stay black and go *deeper* under
/// dark, because depth on a dark ground is still a shadow, not a glow.
extension EdenColor {
    // MARK: Controls

    /// The resting fill of Eden's pill controls — `+ New`, `Edit hashtags`:
    /// `white/80` under light, so the ground shows through; white 10 % under
    /// dark, which composites to the measured field fill.
    public static let controlFill = dual(light: white(80), dark: white(10))
    /// The same pill under the pointer: opaque under light, a clear step up
    /// off the ground under dark, rather than changing hue.
    public static let controlFillHover = dual(light: white(100), dark: white(16))
    /// A pill's resting edge — `black/7%`, dark `--color-divider` (white 10 %).
    public static let controlBorder = dual(light: black(7), dark: white(10))
    /// That edge under the pointer, one step firmer — the spec's stronger edge.
    public static let controlBorderHover = dual(light: black(10), dark: white(16))
    /// The h28 pill's single edge. The small pill does not firm its edge on
    /// hover; only its fill and its ink move.
    public static let controlBorderSmall = dual(light: black(9), dark: white(13))
    /// The wash a borderless button takes under the pointer — the modal's
    /// `Cancel`.
    public static let ghostHoverFill = dual(light: black(4), dark: white(7))

    /// The filter chip that is on. `card`'s white under light; under dark it
    /// takes `--color-background-field` rather than the card, because it has
    /// to lift off the canvas, not match a card.
    public static let chipActiveFill = dual(light: white(100), dark: hex(0x2A2A2A))
    /// That chip's edge — the firmest edge in the filter row.
    public static let chipActiveBorder = dual(light: black(15), dark: white(20))

    /// The track a segmented control sits in.
    public static let segmentTrackFill = dual(light: black(1.8), dark: white(4))
    /// The track's edge.
    public static let segmentTrackBorder = dual(light: black(6.5), dark: white(9))
    /// The chosen segment's own capsule inside that track.
    public static let segmentSelectedFill = dual(light: black(5.5), dark: white(10))

    /// The plate under a `⌘ K` keycap. The deprecated `EdenViewModes` draws
    /// its track on the same plate.
    public static let keycapFill = dual(light: black(5), dark: white(8))
    /// The square a `mono20` monogram's initial sits on. The small monogram is
    /// tinted with `primaryTint` instead.
    public static let monogramFill = dual(light: black(6), dark: white(9))
    /// The 1 pt lift under a raised control — the current glyph in the
    /// deprecated `EdenViewModes`. Deeper under dark, where a 8 % shadow on a
    /// dark ground is not a lift at all.
    public static let raisedShadow = dual(light: black(8), dark: black(60))

    // MARK: Surfaces a view paints

    /// The edge of the inset pane a Board, a Chat or a split column sits on
    /// (`edenPaneSurface`).
    public static let paneBorder = dual(light: black(6), dark: white(9))

    /// What the sidebar panel casts — `shadow-sm`.
    public static let panelShadow = dual(light: black(10), dark: black(55))

    /// What Eden's floating chrome casts. Parameterised because the modifier
    /// is: a modal drops a deeper shadow than a toolbar does. `percent` is a
    /// percentage, as it is for `black(_:)`; under dark it is multiplied and
    /// capped, so a toolbar's 8 % becomes 40 % and nothing exceeds 60 %.
    public static func floatShadow(_ percent: Double) -> Color {
        dual(light: black(percent), dark: black(min(percent * 5, 60)))
    }

    /// `--background-page-gradient`'s two elliptical washes: the stronger one
    /// off the top-left corner, the softer one off the bottom-right. Under
    /// light they are multiplied over the ground and so are ink; under dark
    /// `EdenPageGradient` screens them instead, and they are light.
    public static let pageWashTop = dual(light: black(5.5), dark: white(4))
    public static let pageWashBottom = dual(light: black(3), dark: white(2.5))

    // MARK: The signal ladders' neutral rung

    /// `< 2×` on the Outlier ladder: the absence of a signal, drawn in neutral
    /// ink so that it never reads as one.
    public static let signalNone = dual(light: black(55), dark: white(45))
    /// Its pill's edge, which does not follow the ladder's 25 % derivation.
    public static let signalNoneBorder = dual(light: black(10), dark: white(16))
}
