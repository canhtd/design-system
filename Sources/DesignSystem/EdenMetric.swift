import SwiftUI

/// Geometry from `docs/design/eden-components.md` in the VessaStudio repo. The
/// sidebar numbers are what a whole window is laid out against, so they live
/// here rather than in any one view.
public enum EdenMetric {
    /// The sidebar panel itself: `aside [8, 8, 260, 738]`.
    public static let sidebarWidth: CGFloat = 260
    /// `my-2 ml-2` — 8 pt of canvas around the panel, flush on its right edge.
    public static let sidebarInset: CGFloat = 8
    /// Main content starts at x 268 with the sidebar open.
    public static let sidebarColumn: CGFloat = sidebarWidth + sidebarInset
    /// Panel content width (`px-3` inside 260).
    public static let sidebarContent: CGFloat = 234
    public static let sidebarPadding: CGFloat = 12
    /// Nav / chat / board rows, and the group headers above them.
    public static let rowHeight: CGFloat = 30
    public static let groupHeaderHeight: CGFloat = 26
    /// The `Create or search` pill and the Project switcher.
    public static let createPillHeight: CGFloat = 40
    public static let switcherHeight: CGFloat = 36
    /// Sidebar nav icon slot (glyph inside it is ~17).
    public static let iconSlot: CGFloat = 20
    public static let navGlyph: CGFloat = 17
    /// The small monogram square: 18 pt, `EdenRadius.mono`, `primaryTint`
    /// behind 9.5/600 `primary` — see `EdenMonogram.Size.mono18`.
    public static let mono18: CGFloat = 18
    /// A child row under a sidebar group, beside `EdenColor.guideRail`:
    /// h28, `EdenRadius.childRow`, 14/400 in `EdenColor.n600`.
    public static let childRowHeight: CGFloat = 28
    /// A child row's icon slot, smaller than a nav row's 20.
    public static let childIconSlot: CGFloat = 16
    /// How far a child list hangs off its parent, and how far the rail sits
    /// from the rows beside it (`proto .sb-kids`).
    public static let childIndent: CGFloat = 15
    /// The same, one level deeper (`proto .sb-kids--deep`).
    public static let childIndentDeep: CGFloat = 9
    public static let childRailPadding: CGFloat = 11
    /// A row's hover affordance ("open in pane"): a 28 pt hit target around a
    /// 13 pt glyph. Its own metric, because it is not a child row's height.
    public static let rowActionSize: CGFloat = 28
    /// The disclosure that replaces a Board row's leading icon on hover.
    public static let disclosureSize: CGFloat = 20
    /// The window's own chrome: the title bar is hidden, so the sidebar's first
    /// control clears the traffic lights itself.
    public static let sidebarTopInset: CGFloat = 30
    public static let windowMinWidth: CGFloat = 900
    public static let windowMinHeight: CGFloat = 600
    public static let windowDefaultWidth: CGFloat = 1440
    public static let windowDefaultHeight: CGFloat = 800

    /// Library container: `max-w-[1640px] px-12 pt-5 pb-16`.
    public static let libraryMaxWidth: CGFloat = 1640
    public static let libraryPaddingH: CGFloat = 48
    public static let libraryPaddingTop: CGFloat = 20
    public static let libraryPaddingBottom: CGFloat = 64
    /// Header pills (`+ New`) and the filter chips.
    public static let pillHeight: CGFloat = 32
    /// A status chip (`Daily pull`) and a hashtag token — shorter than a pill.
    public static let chipHeight: CGFloat = 26
    /// A popover's own actions (`Pull now`, `Edit hashtags`) and the modal's
    /// chips: taller than a chip, shorter than a header pill.
    public static let smallPillHeight: CGFloat = 28
    public static let searchFieldHeight: CGFloat = 50
    public static let segmentedHeight: CGFloat = 30

    /// A floating menu: 4 pt of padding around rows of 32.
    public static let popoverPadding: CGFloat = 4
    public static let popoverRowHeight: CGFloat = 32

    /// The bar naming what a second pane holds, above that pane's content.
    public static let paneHeaderHeight: CGFloat = 34
    /// The inset and the gap of the pane surface a Board/Chat sits on
    /// (`proto .panes`).
    public static let paneInset: CGFloat = 9
    public static let paneGap: CGFloat = 9

    /// The New Project modal.
    public static let modalWidth: CGFloat = 680
    public static let modalTopInset: CGFloat = 104
    public static let fieldHeight: CGFloat = 44
    public static let modalButtonHeight: CGFloat = 35
    /// The blur behind `EdenColor.scrim`.
    public static let scrimBlur: CGFloat = 3
}
