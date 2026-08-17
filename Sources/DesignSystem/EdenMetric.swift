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

    /// Library container: `max-w-[1640px] px-12 pt-5 pb-16`.
    public static let libraryMaxWidth: CGFloat = 1640
    public static let libraryPaddingH: CGFloat = 48
    public static let libraryPaddingTop: CGFloat = 20
    public static let libraryPaddingBottom: CGFloat = 64
    /// Header pills (`+ New`, `Pull now`) and the filter chips.
    public static let pillHeight: CGFloat = 32
    public static let searchFieldHeight: CGFloat = 50
    public static let segmentedHeight: CGFloat = 30

    /// The New Project modal.
    public static let modalWidth: CGFloat = 640
    public static let modalTopInset: CGFloat = 118
    public static let fieldHeight: CGFloat = 44
    public static let modalButtonHeight: CGFloat = 35
}
