import SwiftUI

/// A face Eden names rather than a size a view spells: the tight titles carry
/// negative tracking, and a view that writes `27` and `-0.945` by hand has
/// already drifted from the next screen that writes them slightly differently.
public struct EdenTextStyle: Sendable, Equatable {
    public let size: CGFloat
    public let weight: Font.Weight
    /// Points, not ems — `letter-spacing: -.035em` at 27 px is −0.945 pt.
    public let tracking: CGFloat
    /// The CSS line box, where a face has one. SwiftUI has no line-height, only
    /// `lineSpacing` *between* lines, so this is for the places that build their
    /// own text — `NSTextField`'s paragraph style — and is `nil` everywhere the
    /// font's natural leading is what the prototype uses.
    public let lineHeight: CGFloat?

    public init(size: CGFloat, weight: Font.Weight = .regular, tracking: CGFloat = 0,
                lineHeight: CGFloat? = nil) {
        self.size = size
        self.weight = weight
        self.tracking = tracking
        self.lineHeight = lineHeight
    }

    public var font: Font { EdenFont.ui(size, weight) }
}

/// Eden's named faces. Sizes and tracking come from `docs/design/eden-tokens.md`
/// §1 and the frozen M1 prototype.
public enum EdenType {
    /// A screen's own title — `All items`, `Pulled today` (`proto .lib-title`).
    public static let pageTitle = EdenTextStyle(size: 27, weight: .medium, tracking: -0.945)
    /// The New Project sheet's name field (`proto .np-title`, `line-height:1.3`).
    public static let sheetTitle = EdenTextStyle(size: 26, weight: .medium, tracking: -1.04,
                                                lineHeight: 33.8)
    /// `What are we making?` above the composer (`proto .hero-h`).
    public static let heroTitle = EdenTextStyle(size: 26, weight: .medium, tracking: -1.04)
    /// A Board's title, and an empty state's headline (`proto .btitle h1`).
    public static let sectionTitle = EdenTextStyle(size: 21, weight: .medium, tracking: -0.42)
    /// The line under a page title, and the body of an empty state.
    public static let subtitle = EdenTextStyle(size: 13.5)
    /// A sidebar row, a search field's input.
    public static let row = EdenTextStyle(size: 14)
    /// A chip, a segmented button, a popover header.
    public static let chip = EdenTextStyle(size: 11.5, weight: .medium)
    /// A trailing count or age.
    public static let meta = EdenTextStyle(size: 12)
    /// A list row's own name — an Actor row, a sheet's headline row.
    public static let rowTitle = EdenTextStyle(size: 13.5, weight: .medium)
    /// The line under it: `5 hashtags · every day 07:00 · last run 7 min ago`.
    public static let rowMeta = EdenTextStyle(size: 11.5)
    /// `Usage 12 / 50 today` — tabular, and never money.
    public static let usagePill = EdenTextStyle(size: 10.5, weight: .medium, tracking: 0.264)
    /// A `SOON` tag on a row that is drawn but cannot work yet.
    public static let soonTag = EdenTextStyle(size: 9.5, weight: .semibold, tracking: 0.25)
    /// A sheet's own heading — `Delete “X”?`, an `Add from Library` title.
    public static let modalTitle = EdenTextStyle(size: 15, weight: .medium)
    /// A table cell and a sheet's select control.
    public static let tableCell = EdenTextStyle(size: 12.5)
    /// A popover row, a Folder pane's list row.
    public static let popoverRow = EdenTextStyle(size: 13)
}

extension View {
    /// Applies a named face — size, weight and tracking in one place.
    public func edenText(_ style: EdenTextStyle) -> some View {
        font(style.font).tracking(style.tracking)
    }
}
