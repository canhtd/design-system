import SwiftUI

/// Eden's pill button: `+ New`, `Pull now`. h32, `controlFill` inside a
/// `controlBorder` edge, 12/500 in `textControl` (`eden-components.md` §2).
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
                .foregroundStyle(hovering && isEnabled ? EdenColor.textStrong
                                                       : EdenColor.textControl)
                .padding(.horizontal, 12)
                .frame(height: EdenMetric.pillHeight)
                .background(hovering && isEnabled ? EdenColor.controlFillHover
                                                  : EdenColor.controlFill, in: .capsule)
                .overlay(Capsule().strokeBorder(hovering && isEnabled
                                                ? EdenColor.controlBorderHover
                                                : EdenColor.controlBorder))
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

/// Its quiet neighbour — `Edit hashtags`. h28, r=full, a `controlBorderSmall`
/// edge on `controlFill`. Disabled it keeps that border and fill and only the ink
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
                .foregroundStyle(isEnabled ? (highlighted ? EdenColor.textStrong
                                                          : EdenColor.textControl)
                                           : EdenColor.textTertiary)
                .padding(.horizontal, 12)
                .frame(height: EdenMetric.smallPillHeight)
                .background(highlighted ? EdenColor.controlFillHover : EdenColor.controlFill,
                            in: .capsule)
                .overlay(Capsule().strokeBorder(EdenColor.controlBorderSmall))
                .opacity(configuration.isPressed && isEnabled ? 0.75 : 1)
                .onHover { hovering = $0 }
        }
    }
}

/// The modal's quiet action (`Cancel`): h35, r18, 12.5/500 `textControlQuiet`.
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
                .foregroundStyle(highlighted ? EdenColor.textStrong : EdenColor.textControlQuiet)
                .padding(.horizontal, 14)
                .frame(height: EdenMetric.modalButtonHeight)
                .background(highlighted ? EdenColor.ghostHoverFill : .clear,
                            in: .rect(cornerRadius: EdenRadius.lg, style: .continuous))
                .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
                .onHover { hovering = $0 }
        }
    }
}

/// The one committing action on a screen: `primary80` under `primary5` text.
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

/// The committing action of a destructive confirmation — `Delete`. Same
/// geometry as `EdenPrimaryButtonStyle`; only the fill says what it does
/// (`proto .danger`).
public struct EdenDangerButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        DangerLabel(configuration: configuration)
    }

    struct DangerLabel: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled
        @State private var hovering = false

        var body: some View {
            configuration.label
                .font(EdenFont.ui(12.5, .medium))
                .foregroundStyle(EdenColor.textInverse)
                .padding(.horizontal, 14)
                .frame(height: EdenMetric.modalButtonHeight)
                .background(EdenColor.danger,
                            in: .rect(cornerRadius: EdenRadius.lg, style: .continuous))
                .opacity(opacity)
                .onHover { hovering = $0 }
        }

        private var opacity: Double {
            if !isEnabled { return 0.35 }
            if configuration.isPressed { return 0.85 }
            return hovering ? 0.9 : 1
        }
    }
}
