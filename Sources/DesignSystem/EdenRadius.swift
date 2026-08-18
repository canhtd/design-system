import SwiftUI

/// Eden overrides Tailwind's radius scale — `lg` (18) is bigger than `xl` (12).
public enum EdenRadius {
    /// The smallest square Eden rounds: a monogram, a Board's disclosure, the
    /// `+` on a section header.
    public static let xs: CGFloat = 6
    public static let sm: CGFloat = 8
    /// `rounded-md`/`rounded-xl`: sidebar panel and rows, list rows, tiles.
    public static let md: CGFloat = 12
    /// `rounded-lg`: the Library banner, modal footer buttons.
    public static let lg: CGFloat = 18
    /// `rounded-2xl`: content cards, promo cards, floating toolbars.
    public static let card: CGFloat = 16
    /// `rounded-3xl`: board title bar, item-detail header buttons, modals.
    public static let modal: CGFloat = 24

    /// The 18 pt monogram square (`EdenMetric.mono18`).
    public static let mono: CGFloat = 5
    /// A sidebar child row — tighter than `md`, because the row is shorter.
    public static let childRow: CGFloat = 10
}
