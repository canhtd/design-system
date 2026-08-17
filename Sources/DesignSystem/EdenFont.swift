import SwiftUI

/// SF Pro at Eden's px sizes (decision D3 in VessaStudio's `docs/specs/m1-runs.md`:
/// native font, Eden's scale). Eden itself ships Geist, which is not bundled here.
public enum EdenFont {
    public static func ui(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
}

/// Eden overrides Tailwind's radius scale — `lg` (18) is bigger than `xl` (12).
public enum EdenRadius {
    public static let sm: CGFloat = 8
    /// `rounded-md`/`rounded-xl`: sidebar panel and rows, list rows, tiles.
    public static let md: CGFloat = 12
    /// `rounded-lg`: the Library banner, modal footer buttons.
    public static let lg: CGFloat = 18
    /// `rounded-2xl`: content cards, promo cards, floating toolbars.
    public static let card: CGFloat = 16
    /// `rounded-3xl`: board title bar, item-detail header buttons, modals.
    public static let modal: CGFloat = 24
}
