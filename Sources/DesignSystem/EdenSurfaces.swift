import SwiftUI

extension View {
    /// `shadow-sm` — the sidebar panel.
    public func edenPanelShadow() -> some View {
        shadow(color: EdenColor.panelShadow, radius: 1.5, y: 1)
    }

    /// The floating-chrome shadow Eden puts under modals and toolbars.
    public func edenFloatShadow(opacity: Double = 8) -> some View {
        shadow(color: EdenColor.floatShadow(opacity), radius: 30, y: 22)
    }

    /// The inset card a Board, a Chat or a split column sits on: r12, a 1 pt
    /// `paneBorder` edge, and its content clipped to that shape (`proto .pane`).
    /// The gap around it belongs to the container, not to the pane.
    public func edenPaneSurface() -> some View {
        clipShape(.rect(cornerRadius: EdenRadius.md, style: .continuous))
            .edenBorder(EdenColor.paneBorder, radius: EdenRadius.md)
    }

    /// A 1 pt inside border, the way CSS `border` paints it.
    public func edenBorder(_ colour: Color, radius: CGFloat, width: CGFloat = 1) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(colour, lineWidth: width)
        )
    }
}

/// `--background-page-gradient`: two very faint elliptical washes multiplied
/// over the canvas. Subtle, but it is what stops Eden's background reading as
/// flat. This is the one definition of the wash — an app that wants it uses
/// this view rather than spelling a gradient of its own.
///
/// The measured Eden doc says 8%/4%; 5.5%/3% is the tuned value, the one
/// checked against the real app, so it is what ships.
///
/// It is one wash for a whole window, not one per column: it multiplies over
/// the sidebar panel as well as the canvas, so the ground reads as continuous
/// and the strip of canvas around the panel does not sit lighter than the
/// content beside it. Because it multiplies, it goes *over* the panel — a
/// gradient behind an opaque fill shows nothing.
public struct EdenPageGradient: View {
    public init() {}

    public var body: some View {
        ZStack {
            EllipticalGradient(colors: [EdenColor.pageWashTop, .clear],
                               center: UnitPoint(x: 0.08, y: -0.1),
                               endRadiusFraction: 0.72)
            EllipticalGradient(colors: [EdenColor.pageWashBottom, .clear],
                               center: UnitPoint(x: 1.05, y: 1.08),
                               endRadiusFraction: 0.54)
        }
        .blendMode(.multiply)
        .allowsHitTesting(false)
    }
}
