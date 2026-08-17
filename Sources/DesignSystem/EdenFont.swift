import SwiftUI

/// SF Pro at Eden's px sizes (decision D3 in VessaStudio's `docs/specs/m1-runs.md`:
/// native font, Eden's scale). Eden itself ships Geist, which is not bundled here.
public enum EdenFont {
    public static func ui(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
}
