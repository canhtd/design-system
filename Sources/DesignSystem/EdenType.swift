import SwiftUI

/// A face Eden names rather than a size a view spells: the tight titles carry
/// negative tracking, and a view that writes `27` and `-0.945` by hand has
/// already drifted from the next screen that writes them slightly differently.
public struct EdenTextStyle: Sendable, Equatable {
    public let size: CGFloat
    public let weight: Font.Weight
    /// Points, not ems — `letter-spacing: -.035em` at 27 px is −0.945 pt.
    public let tracking: CGFloat

    public init(size: CGFloat, weight: Font.Weight = .regular, tracking: CGFloat = 0) {
        self.size = size
        self.weight = weight
        self.tracking = tracking
    }

    public var font: Font { EdenFont.ui(size, weight) }
}

/// Eden's named faces. Sizes and tracking come from `docs/design/eden-tokens.md`
/// §1 and the frozen M1 prototype.
public enum EdenType {
    /// A screen's own title — `All items`, `Pulled today` (`proto .lib-title`).
    public static let pageTitle = EdenTextStyle(size: 27, weight: .medium, tracking: -0.945)
    /// The New Project sheet's name field (`proto .np-title`).
    public static let sheetTitle = EdenTextStyle(size: 26, weight: .medium, tracking: -1.04)
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
}

extension View {
    /// Applies a named face — size, weight and tracking in one place.
    public func edenText(_ style: EdenTextStyle) -> some View {
        font(style.font).tracking(style.tracking)
    }
}
