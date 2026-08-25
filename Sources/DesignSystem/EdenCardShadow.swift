import SwiftUI

extension View {
    /// Casts one of `EdenCard`'s two lifts.
    ///
    /// The layers stack outwards, contact edge first, exactly as v0.2.17 cast
    /// them. What changed is where the colour comes from: `EdenCard.ink` is a
    /// pair now and goes *light* under dark, so a lift drawn with it would
    /// become a halo. `EdenCard.shadowLayer(_:)` is the pair that stays dark.
    ///
    /// This modifier lives apart from `EdenCard.swift` on purpose. That file
    /// spells colour values and is on the semantic-token guard's allowlist;
    /// this one draws, so it stays under the guard — and it can, because it
    /// asks for a role and never names a colour.
    public func edenCardShadow(_ shadow: EdenCard.Shadow) -> some View {
        shadow.layers.reduce(AnyView(self)) { view, layer in
            AnyView(view.shadow(color: EdenCard.shadowLayer(layer.opacity),
                                radius: layer.radius, y: layer.y))
        }
    }
}
