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

/// The committing action inside a popover — `Pull now`. Shorter than a modal's
/// button and fully rounded: h28, r=full, `primary80` under `primary5`.
///
/// Disabled or busy it fades to 0.75, never further: at 0.4 the label and the
/// fill wash to the same grey and the button stops saying what it is
/// (`proto .pull-now.is-busy{opacity:.75}`).
public struct EdenSmallPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        SmallPrimaryLabel(configuration: configuration)
    }

    struct SmallPrimaryLabel: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .edenText(EdenType.chip)
                .foregroundStyle(EdenColor.primary5)
                .padding(.horizontal, 12)
                .frame(height: EdenMetric.smallPillHeight)
                .background(EdenColor.primary80, in: .capsule)
                .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.75)
        }
    }
}

/// Its quiet neighbour — `Edit hashtags`. h28, r=full, `black(9)` border on
/// `white/80`. Disabled it keeps its resting border and fill and only the ink
/// fades, so it reads as "not yet", not as "broken".
public struct EdenSmallPillButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        SmallPillLabel(configuration: configuration)
    }

    struct SmallPillLabel: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled
        @State private var hovering = false

        var body: some View {
            let highlighted = hovering && isEnabled
            configuration.label
                .edenText(EdenType.chip)
                .foregroundStyle(isEnabled ? (highlighted ? EdenColor.n900 : EdenColor.n700)
                                           : EdenColor.n400)
                .padding(.horizontal, 12)
                .frame(height: EdenMetric.smallPillHeight)
                .background(highlighted ? Color.white : EdenColor.white(80), in: .capsule)
                .overlay(Capsule().strokeBorder(EdenColor.black(9)))
                .opacity(configuration.isPressed && isEnabled ? 0.75 : 1)
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
        @Environment(\.isEnabled) private var isEnabled
        @State private var hovering = false

        var body: some View {
            let highlighted = hovering && isEnabled
            configuration.label
                .font(EdenFont.ui(12.5, .medium))
                .foregroundStyle(highlighted ? EdenColor.n900 : EdenColor.n600)
                .padding(.horizontal, 14)
                .frame(height: EdenMetric.modalButtonHeight)
                .background(highlighted ? EdenColor.black(4) : .clear,
                            in: .rect(cornerRadius: EdenRadius.lg, style: .continuous))
                .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
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
