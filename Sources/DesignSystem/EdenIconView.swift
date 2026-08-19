import SwiftUI

/// One Tabler glyph, drawn the way the prototype's `ico(name, size)` draws it:
/// a `size × size` box holding the 24-grid outline, stroked at 1.7 (scaled with
/// the box) with round caps and joins, in the current foreground style.
///
/// The glyph is decorative — a control's name comes from its label, never from
/// the picture — so it is hidden from accessibility.
public struct EdenIconView: View {
    public let icon: EdenIcon
    public let size: CGFloat

    public init(_ icon: EdenIcon, size: CGFloat) {
        self.icon = icon
        self.size = size
    }

    public var body: some View {
        let shape = EdenIconShape(icon: icon)
        Group {
            if icon.isFilled {
                shape
            } else {
                shape.stroke(style: StrokeStyle(lineWidth: EdenIconShape.stroke * size / 24,
                                                lineCap: .round, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// The glyph as a `Shape`, so a caller that needs to fill or stroke it itself
/// (a badge, a mask) can.
public struct EdenIconShape: Shape {
    /// `stroke-width` at the 24 grid (`proto .ic`).
    public static let stroke: CGFloat = 1.7

    public let icon: EdenIcon

    public init(icon: EdenIcon) { self.icon = icon }

    public func path(in rect: CGRect) -> Path {
        let scale = min(rect.width, rect.height) / 24
        var path = Path()
        for subpath in icon.subpaths {
            path.addPath(Path(EdenIconPath.cgPath(subpath, scale: scale)))
        }
        return path.offsetBy(dx: rect.minX, dy: rect.minY)
    }
}

/// The size a glyph is drawn at in each slot of the M1 screens
/// (`docs/design/refs/design-rules.md` R-81, `interaction-spec.md` §2). Views
/// name the slot; nobody spells the number.
public enum EdenIconSize {
    /// Sidebar `Library` / `Agents`, and the create pill's `+`.
    public static let nav: CGFloat = 17
    /// The footer's theme and bin buttons.
    public static let footer: CGFloat = 18
    /// A Project's cube, a `Boards`/`Chats` row, a popover row.
    public static let child: CGFloat = 16
    /// A Board row, an Output row, a `Recently deleted` row.
    public static let row: CGFloat = 15
    /// A row's fold chevron, the account `selector`, a pull row's platform.
    public static let chevron: CGFloat = 14
    /// The `Your projects` chevron, the chat pane title's chevron.
    public static let smallChevron: CGFloat = 12
    /// The `open in pane` affordance and the pane header's glyph.
    public static let pane: CGFloat = 13
    /// A filter chip's leading glyph, and the pull popover's two actions.
    public static let chip: CGFloat = 13
    /// A dropdown chip's trailing chevron.
    public static let chipChevron: CGFloat = 11
    /// The Library search field's magnifier.
    public static let search: CGFloat = 16
    /// The sparkle in the search field's AI button.
    public static let aiSparkle: CGFloat = 15
    /// The sparkle before a page title.
    public static let pageMark: CGFloat = 27
    /// The Board header's back chevron.
    public static let back: CGFloat = 18
    /// A chat pane header action, and the composer's own buttons.
    public static let chatAction: CGFloat = 16
    /// The sparkle above `What are we making?`.
    public static let hero: CGFloat = 40
    /// The modal's close `x`.
    public static let modalClose: CGFloat = 14
    /// The `x` on a hashtag token.
    public static let tagClose: CGFloat = 10
    /// A row's `⋯` menu handle, and a Chat row's "show beside view" glyph.
    public static let rowMenu: CGFloat = 14
    public static let splitPane: CGFloat = 14
    /// A section header's own actions, one size up from a row's.
    public static let sectionAction: CGFloat = 15
    /// An Actor row's kind glyph, inside `EdenMetric.actorKindTile`.
    public static let kindTile: CGFloat = 17
}
