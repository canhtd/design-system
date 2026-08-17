import SwiftUI

/// Eden's pill button: `+ New`, `Pull now`. h32, `white/80` on a `black/7%`
/// border, 12/500 in `#404040` (`eden-components.md` §2).
public struct EdenPillButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PillLabel(configuration: configuration)
    }

    struct PillLabel: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled
        @State private var hovering = false

        var body: some View {
            configuration.label
                .font(EdenFont.ui(12, .medium))
                .foregroundStyle(hovering && isEnabled ? EdenColor.n900 : EdenColor.n700)
                .padding(.horizontal, 12)
                .frame(height: EdenMetric.pillHeight)
                .background(hovering && isEnabled ? Color.white : EdenColor.white(80), in: .capsule)
                .overlay(Capsule().strokeBorder(EdenColor.black(hovering && isEnabled ? 10 : 7)))
                .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
                .onHover { hovering = $0 }
        }
    }
}

/// The modal's quiet action (`Cancel`): h35, r18, 12.5/500 `#525252`.
public struct EdenGhostButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        GhostLabel(configuration: configuration)
    }

    struct GhostLabel: View {
        let configuration: Configuration
        @State private var hovering = false

        var body: some View {
            configuration.label
                .font(EdenFont.ui(12.5, .medium))
                .foregroundStyle(hovering ? EdenColor.n900 : EdenColor.n600)
                .padding(.horizontal, 14)
                .frame(height: EdenMetric.modalButtonHeight)
                .background(hovering ? EdenColor.black(4) : .clear,
                            in: .rect(cornerRadius: EdenRadius.lg, style: .continuous))
                .opacity(configuration.isPressed ? 0.75 : 1)
                .onHover { hovering = $0 }
        }
    }
}

/// The one committing action on a screen: `#224735` with `#eff2ee` text.
public struct EdenPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PrimaryLabel(configuration: configuration)
    }

    struct PrimaryLabel: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .font(EdenFont.ui(12.5, .medium))
                .foregroundStyle(EdenColor.primary5)
                .padding(.horizontal, 14)
                .frame(height: EdenMetric.modalButtonHeight)
                .background(EdenColor.primary80,
                            in: .rect(cornerRadius: EdenRadius.lg, style: .continuous))
                .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.35)
        }
    }
}
