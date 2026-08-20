/// Tabler's glyphs, the icon set the frozen M1 prototype draws
/// (`docs/prototypes/m1-eden-clone.html`, `ICONS`). Every one is authored on a
/// 24 × 24 grid and stroked at 1.7 with round caps and joins; `player-play` and
/// `brand-tiktok` are filled instead. The raw name is the Tabler one, so a
/// glyph can be looked up against tabler.io without translating.
public enum EdenIcon: String, Sendable, CaseIterable {
    case arrowRight = "arrow-right"
    case arrowUp = "arrow-up"
    case arrowsExchange = "arrows-exchange"
    case bolt = "bolt"
    case brandTiktok = "brand-tiktok"
    case calendar = "calendar"
    case check = "check"
    case chevronDown = "chevron-down"
    case chevronLeft = "chevron-left"
    case chevronRight = "chevron-right"
    case circleChevronDown = "circle-chevron-down"
    case circleChevronRight = "circle-chevron-right"
    case copy = "copy"
    case cube = "cube"
    case dots = "dots"
    case fileText = "file-text"
    case externalLink = "external-link"
    case folder = "folder"
    case layoutBoard = "layout-board"
    case layoutCollage = "layout-collage"
    case layoutGrid = "layout-grid"
    case layoutSidebar = "layout-sidebar"
    case layoutSidebarRight = "layout-sidebar-right"
    case listDetails = "list-details"
    case loader2 = "loader-2"
    case logout = "logout"
    case messageCircle = "message-circle"
    case microphone = "microphone"
    case moon = "moon"
    case notes = "notes"
    case palette = "palette"
    case pencil = "pencil"
    case playerPlay = "player-play"
    case plus = "plus"
    case refresh = "refresh"
    case search = "search"
    case selector = "selector"
    case settings = "settings"
    case share3 = "share-3"
    case sparkle = "sparkle"
    case sparkles = "sparkles"
    case stack2 = "stack-2"
    case sun = "sun"
    case tag = "tag"
    case trash = "trash"
    case upload = "upload"
    case user = "user"
    case x = "x"

    /// The two glyphs Tabler paints rather than strokes (`proto .ic-fill`).
    public var isFilled: Bool { self == .playerPlay || self == .brandTiktok }

    /// The glyph's `<path d="…">` list, in 24-grid coordinates.
    public var subpaths: [String] { EdenIconData.subpaths[self] ?? [] }
}
