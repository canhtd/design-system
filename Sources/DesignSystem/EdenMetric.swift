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
    /// h28, `EdenRadius.childRow`, 14/400 in `EdenColor.textControlQuiet`.
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
    /// How far that hit target's trailing edge sits inside the sidebar's own
    /// content column. Eden pulls the affordance back out of the row's padding
    /// (`.rowact{margin-right:-6px}` against a row padded 12), and every row
    /// that carries one shares the column whatever its own padding is.
    public static let rowActionInset: CGFloat = 5.5
    /// The disclosure that replaces a Board row's leading icon on hover.
    public static let disclosureSize: CGFloat = 20
    /// The window's own chrome: the title bar is hidden, so the sidebar's first
    /// control clears the traffic lights itself.
    public static let sidebarTopInset: CGFloat = 30
    /// The same panel in native full screen, where there are no traffic lights
    /// to clear: the panel keeps its own top pad and gives back the room the
    /// lights were holding.
    public static let sidebarTopInsetFullScreen: CGFloat = 20
    /// How far the traffic lights sit from the sidebar panel's top and leading
    /// edges. They belong inside the panel, with room around them, the way
    /// Notion and Eden place them — not tucked against its corner.
    public static let trafficLightInset: CGFloat = 12
    public static let windowMinWidth: CGFloat = 900
    public static let windowMinHeight: CGFloat = 600
    public static let windowDefaultWidth: CGFloat = 1440
    public static let windowDefaultHeight: CGFloat = 800

    /// Library container: `max-w-[1640px] px-12 pt-5 pb-16`.
    public static let libraryMaxWidth: CGFloat = 1640
    public static let libraryPaddingH: CGFloat = 48
    /// The same padding for a Library that is only half a window wide — one
    /// side of a split. 48 there costs the header its one-line rhythm: the
    /// pull chip drops off the title row. Eden's own value is 24
    /// (`proto libraryScreen()`: `W < 900 ? 24 : 48`); the extra point is the
    /// pane card's 1 pt border, which a SwiftUI overlay stroke does not consume
    /// the way CSS `border-box` does.
    public static let libraryPaddingHNarrow: CGFloat = 25
    /// Below this width a Library is drawn narrow.
    public static let libraryNarrowWidth: CGFloat = 900
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
    /// Between the two cards of a split view. Wider than `paneGap`: a split is
    /// two separate surfaces on the ground, not two halves of one card.
    public static let splitGutter: CGFloat = 12
    /// A Chat beside a Board keeps its own width (`proto .pane--chat`).
    public static let chatPaneWidth: CGFloat = 572
    /// How wide a composer or a hero block is allowed to get inside it.
    public static let composerMaxWidth: CGFloat = 620
    /// A circular 28 pt button: the chat pane header, a composer's own
    /// buttons, a Board's back chevron (`proto .cbtn28`).
    public static let circleButton: CGFloat = 28
    /// How wide a centred empty state's sentence is allowed to run.
    public static let emptyStateMaxWidth: CGFloat = 460

    /// The New Project modal.
    public static let modalWidth: CGFloat = 680
    public static let modalTopInset: CGFloat = 104
    public static let fieldHeight: CGFloat = 44
    public static let modalButtonHeight: CGFloat = 35
    /// The blur behind `EdenColor.scrim`.
    public static let scrimBlur: CGFloat = 3

    // MARK: - Sidebar row actions (round 7)

    /// A section header's own hover action (`+`, the split glyph): a 20 pt
    /// square with `EdenRadius.xs` corners (`proto .sb-sechd .gact`).
    public static let sectionActionSize: CGFloat = 20
    /// The "show beside view" glyph at the right edge of a Chat row
    /// (`proto .rowact--side`). Narrower than `rowActionSize` because it sits
    /// flush against the row's edge with the `⋯` inside it.
    public static let chatSideWidth: CGFloat = 26
    /// How much width the two trailing actions of a Chat row take together, so
    /// the title stops before them instead of sliding underneath
    /// (`proto .sb-krow--chat:hover .txt{padding-right:52px}`).
    public static let chatRowActionsWidth: CGFloat = 52

    // MARK: - Actors screen

    /// The content column of a screen that lists rows rather than cards.
    public static let listScreenMaxWidth: CGFloat = 1056
    /// An Actor row: `min-height:70`, `padding:12 14`, `EdenRadius.md`.
    public static let actorRowMinHeight: CGFloat = 70
    public static let actorRowPaddingH: CGFloat = 14
    public static let actorRowPaddingV: CGFloat = 12
    /// The 34 pt tile holding an Actor's kind glyph.
    public static let actorKindTile: CGFloat = 34
    /// The `Usage N / 50 today` pill. Shorter than a chip; never money.
    public static let usagePillHeight: CGFloat = 20

    // MARK: - Command palette and the sheets round 7 adds

    /// The ⌘K create palette (`proto .modal--cmdk`).
    public static let commandPaletteWidth: CGFloat = 640
    /// Its search row, which the rows hang under.
    public static let commandSearchHeight: CGFloat = 52
    public static let commandRowHeight: CGFloat = 40
    /// r7.3 — the destination pill on `New card`, which names where the card
    /// will land instead of taking a shortcut letter (`proto .ck-dest`).
    public static let commandDestHeight: CGFloat = 24
    public static let commandDestGap: CGFloat = 5
    public static let commandDestLeading: CGFloat = 8
    public static let commandDestTrailing: CGFloat = 7
    /// The Actor detail sheet (`proto .modal--actor`).
    public static let actorSheetWidth: CGFloat = 600
    /// A delete confirmation, and the `Move to…` picker.
    public static let confirmSheetWidth: CGFloat = 420
    /// A row's `⋯` menu (`proto .pop--ctx`).
    public static let contextMenuWidth: CGFloat = 178
    // MARK: - The Board (interaction-spec-board.md)

    /// The Board's header floats over the cards rather than sitting above them:
    /// inset 20 a side, 6 from the top, 36 tall (`proto .boardhd`).
    public static let boardHeaderInset: CGFloat = 20
    public static let boardHeaderTop: CGFloat = 6
    public static let boardHeaderHeight: CGFloat = 36
    /// The cards scroll under it, so the column starts below the header and
    /// ends clear of the floating toolbar (`proto .boardscroll`).
    public static let boardScrollTop: CGFloat = 79
    public static let boardScrollSide: CGFloat = 32
    public static let boardScrollBottom: CGFloat = 120
    /// The floating toolbar and the right rail (`proto .btoolbar`, `.brail`).
    public static let boardFloaterInset: CGFloat = 20
    public static let boardFloaterHeight: CGFloat = 46
    public static let boardFloaterPadding: CGFloat = 4
    public static let boardRailWidth: CGFloat = 46
    /// A floating-toolbar button.
    public static let toolbarButton: CGFloat = 36
    /// The `+` menu over the toolbar (`proto .pop--add`).
    public static let addMenuWidth: CGFloat = 252
    public static let addMenuRowHeight: CGFloat = 34
    /// Masonry: three columns above this width of pane, else two
    /// (`proto boardCards()`).
    public static let masonryBreakpoint: CGFloat = 900
    public static let masonryGutterWide: CGFloat = 21
    public static let masonryGutterNarrow: CGFloat = 19
    /// `List` is one centred column, not a full-bleed card, and its cards sit
    /// closer together than the grid's.
    public static let masonryGutterList: CGFloat = 12
    public static let boardListColumnWidth: CGFloat = 760
    /// A card's own padding (`proto .card`, `.notecard`, `.doccard`).
    public static let cardPadding: CGFloat = 14
    public static let notePaddingH: CGFloat = 24
    public static let notePaddingV: CGFloat = 16
    /// Four lines of room while a Note still says `Write a note…`.
    public static let noteMinHeight: CGFloat = 84
    public static let documentPaddingH: CGFloat = 28
    public static let documentPaddingTop: CGFloat = 24
    public static let documentPaddingBottom: CGFloat = 28
    /// The Add-from-Library picker and the Board settings sheet are the same
    /// width (`proto .modal--pick`, `.modal--bset`).
    public static let wideSheetWidth: CGFloat = 560
    /// How far the picker's list may run before it scrolls.
    public static let pickListMaxHeight: CGFloat = 470
    /// A picker row's checkbox and its round monogram.
    public static let pickCheckbox: CGFloat = 16
    public static let pickAvatar: CGFloat = 28
    /// The Brand & voice textarea (`proto .bs-area`).
    public static let brandAreaMinHeight: CGFloat = 72
    /// A section's colour dot, on a chip and in the settings list.
    public static let sectionDotChip: CGFloat = 6
    public static let sectionDotRow: CGFloat = 8
    /// The section dot on a Board card, top-right (`proto .secdot`). Bigger
    /// than either of the above: it sits on a card, not in a line of text, and
    /// it is the only thing saying which section the card is filed under.
    public static let sectionDotCard: CGFloat = 9
    /// The white ring around that dot, and the inset it sits at.
    public static let sectionDotRing: CGFloat = 0.75
    public static let sectionDotInset: CGFloat = 9
    /// The `@` picker inside the composer (`proto .mpop`).
    public static let mentionTabHeight: CGFloat = 26
    public static let mentionRowHeight: CGFloat = 34

    /// A field inside a sheet (`proto .bs-field`, `.ag-sel`).
    public static let sheetFieldHeight: CGFloat = 36
    public static let sheetSelectHeight: CGFloat = 32
    /// How tall a list inside a sheet may grow before it scrolls. A Workspace
    /// can hold more Folders than a 900 pt window has room for, and a sheet
    /// that grows past the window loses its own footer off the bottom.
    public static let sheetListMaxHeight: CGFloat = 320

    // MARK: - The Chat turn (spec §3.7, `proto chatTurn()`)

    /// How wide the turns run inside the pane before they centre
    /// (`.ai-sidepeek-chat .cc__scroll-content`).
    public static let chatTurnMaxWidth: CGFloat = 620
    /// The padding around one turn (`.ai-sidepeek-chat .cc__msg-pad`).
    public static let chatTurnPaddingH: CGFloat = 18
    public static let chatTurnPaddingV: CGFloat = 14
    /// How much of the column one turn may take (`.ai-sidepeek-chat .cc-msg`).
    public static let chatTurnWidthFraction: CGFloat = 0.95
    /// Between the pieces of one turn — chip, markdown, follow-up
    /// (`proto .cc-msg__parts`).
    public static let chatPartGap: CGFloat = 8
    /// The user's bubble (`.ai-sidepeek-chat .cc-msg--user .cc-msg__bubble`).
    public static let chatBubblePaddingH: CGFloat = 15
    public static let chatBubblePaddingV: CGFloat = 10
    /// An @mention chip (`proto .cc-selected-item`), and the row of them.
    public static let chatMentionGap: CGFloat = 6
    public static let chatMentionPaddingH: CGFloat = 10
    public static let chatMentionPaddingV: CGFloat = 4
    public static let chatMentionMaxWidth: CGFloat = 180
    /// A turn's hover actions — Copy · Save as document · Regenerate
    /// (`proto .cc-msg__action-btn`).
    public static let chatActionButton: CGFloat = 24
    public static let chatActionGap: CGFloat = 2
    public static let chatActionGlyph: CGFloat = 14
    /// The collapsed activity chip (`proto .cc-tool__head`, `.cc-tool__left`).
    public static let chatActivityHeight: CGFloat = 20
    public static let chatActivityGap: CGFloat = 8
    /// Its count pill (`proto .cc-tool__count`).
    public static let chatCountPaddingH: CGFloat = 7
    public static let chatCountPaddingV: CGFloat = 1
    /// The follow-up card and its chips (`proto .cc-format-pick`).
    public static let chatFollowUpPaddingH: CGFloat = 18
    public static let chatFollowUpPaddingV: CGFloat = 16
    public static let chatFollowUpGap: CGFloat = 12
    public static let chatFollowUpChipGap: CGFloat = 8
    public static let chatFollowUpChipHeight: CGFloat = 35
    public static let chatFollowUpChipPaddingH: CGFloat = 13
    /// `Today`, between two hairlines (`proto .cc__day-divider`).
    public static let chatDayGap: CGFloat = 12
    public static let chatDayPaddingH: CGFloat = 24
    public static let chatDayPaddingTop: CGFloat = 10
}
