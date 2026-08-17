import SwiftUI

extension View {
    /// `shadow-sm` — the sidebar panel.
    public func edenPanelShadow() -> some View {
        shadow(color: EdenColor.black(10), radius: 1.5, y: 1)
    }

    /// The floating-chrome shadow Eden puts under modals and toolbars.
    public func edenFloatShadow(opacity: Double = 8) -> some View {
        shadow(color: EdenColor.black(opacity), radius: 30, y: 22)
    }

    /// A 1 pt inside border, the way CSS `border` paints it.
    public func edenBorder(_ colour: Color, radius: CGFloat, width: CGFloat = 1) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(colour, lineWidth: width)
        )
    }
}

/// `--background-page-gradient`: two very faint radial washes multiplied over
/// the canvas. Subtle, but it is what stops Eden's background reading as flat.
public struct EdenPageGradient: View {
    public init() {}

    public var body: some View {
        ZStack {
            RadialGradient(colors: [EdenColor.black(5.5), .clear],
                           center: UnitPoint(x: 0.08, y: -0.1),
                           startRadius: 0, endRadius: 900)
            RadialGradient(colors: [EdenColor.black(3), .clear],
                           center: UnitPoint(x: 1.05, y: 1.08),
                           startRadius: 0, endRadius: 700)
        }
        .blendMode(.multiply)
        .allowsHitTesting(false)
    }
}
