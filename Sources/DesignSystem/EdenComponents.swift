import SwiftUI

/// The `⌘ K` keycaps in the Create-or-search pill: 15 pt square, r4, a
/// `keycapFill` plate under 10/500 `textSecondary`.
public struct EdenKbd: View {
    /// How loud the keycap is. A row that is not here yet still shows the
    /// letter it will answer to, in `textFaint` — the plate keeps its strength, so
    /// the row reads as waiting rather than as faded out
    /// (`proto .ck-row.off .mkbd`).
    public enum Tone {
        case normal, quiet

        var letter: Color {
            switch self {
            case .normal: EdenColor.textSecondary
            case .quiet: EdenColor.textFaint
            }
        }
    }

    public let keys: [String]
    public let tone: Tone

    public init(keys: [String], tone: Tone = .normal) {
        self.keys = keys
        self.tone = tone
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(EdenFont.ui(10, .medium))
                    .foregroundStyle(tone.letter)
                    .frame(minWidth: 15, minHeight: 15)
                    .padding(.horizontal, 2)
                    .background(EdenColor.keycapFill, in: .rect(cornerRadius: 4))
            }
        }
    }
}

/// A name reduced to its first letter on a tinted square.
public struct EdenMonogram: View {
    /// The two squares Eden draws. They differ in more than size — casing and
    /// fill are part of the variant, so a caller only picks the slot.
    public enum Size {
        /// The account row and a popover's header: 20 pt square, `EdenRadius.xs`,
        /// `monogramFill`, 10/600 `textControl`, initial in caps.
        case mono20
        /// The small monogram: 18 pt square, `EdenRadius.mono`, `primaryTint`
        /// behind 9.5/600 `primary`, initial in lower case.
        case mono18

        /// v0.1.0's name for `mono20`.
        @available(*, deprecated, renamed: "mono20")
        public static var switcher20: Size { .mono20 }

        var side: CGFloat { self == .mono18 ? EdenMetric.mono18 : EdenMetric.iconSlot }
        var radius: CGFloat { self == .mono18 ? EdenRadius.mono : EdenRadius.xs }
        var font: Font { EdenFont.ui(self == .mono18 ? 9.5 : 10, .semibold) }
        var foreground: Color { self == .mono18 ? EdenColor.primary : EdenColor.textControl }
        var fill: Color { self == .mono18 ? EdenColor.primaryTint : EdenColor.monogramFill }
    }

    public let text: String
    public let size: Size

    public init(text: String, size: Size = .mono20) {
        self.text = text
        self.size = size
    }

    public var body: some View {
        Text(size == .mono18 ? initial.lowercased() : initial.uppercased())
            .font(size.font)
            .foregroundStyle(size.foreground)
            .frame(width: size.side, height: size.side)
            .background(size.fill, in: .rect(cornerRadius: size.radius))
    }

    private var initial: String { String(text.prefix(1)) }
}

/// A Library filter chip. Presentational only — the host app owns filtering.
public struct EdenFilterChip: View {
    public let title: String
    public let icon: EdenIcon
    public var chevron: Bool
    public var isActive: Bool
    /// A chip squeezed for room drops its label and keeps its glyph, rather
    /// than wrapping the row onto a second line (R-... narrow Library).
    public var isCompact: Bool

    public init(title: String, icon: EdenIcon, chevron: Bool = false,
                isActive: Bool = false, isCompact: Bool = false) {
        self.title = title
        self.icon = icon
        self.chevron = chevron
        self.isActive = isActive
        self.isCompact = isCompact
    }

    public var body: some View {
        HStack(spacing: 6) {
            EdenIconView(icon, size: EdenIconSize.chip)
            if !isCompact {
                Text(title).edenText(EdenType.chip).fixedSize()
                if chevron {
                    EdenIconView(.chevronDown, size: EdenIconSize.chipChevron).opacity(0.7)
                }
            }
        }
        .foregroundStyle(isActive ? EdenColor.textStrong : EdenColor.textSecondary)
        .padding(.horizontal, isCompact ? 8 : 10)
        .frame(height: EdenMetric.pillHeight)
        .background(isActive ? EdenColor.chipActiveFill : .clear, in: .capsule)
        .overlay(Capsule().strokeBorder(isActive ? EdenColor.chipActiveBorder : .clear))
        .accessibilityLabel(title)
    }
}

/// The `Grid | List | Creators` track on the right of the filter row. Drawn
/// with its current mode marked; the host app owns the switching.
public struct EdenSegmented: View {
    public let titles: [String]
    public let selected: Int

    public init(titles: [String], selected: Int) {
        self.titles = titles
        self.selected = selected
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(titles.enumerated()), id: \.offset) { index, title in
                Text(title)
                    .edenText(EdenType.chip)
                    .fixedSize()
                    .foregroundStyle(index == selected ? EdenColor.textSelected
                                                      : EdenColor.textSecondary)
                    .padding(.horizontal, 10)
                    .frame(height: EdenMetric.segmentedHeight - 4)
                    .background(index == selected ? EdenColor.segmentSelectedFill : .clear,
                                in: .capsule)
            }
        }
        .padding(2)
        .frame(height: EdenMetric.segmentedHeight)
        .fixedSize()
        .background(EdenColor.segmentTrackFill, in: .capsule)
        .overlay(Capsule().strokeBorder(EdenColor.segmentTrackBorder))
    }
}

/// The view-mode glyphs beside a page title (Browse / Graph / Index).
/// Eden dropped the trio: `EdenSegmented` is the only view switcher now.
@available(*, deprecated, message: "Use EdenSegmented — Eden has one view switcher")
public struct EdenViewModes: View {
    public let symbols: [String]
    public let selected: Int

    public init(symbols: [String], selected: Int) {
        self.symbols = symbols
        self.selected = selected
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { index, symbol in
                Image(systemName: symbol)
                    .font(EdenFont.ui(14))
                    .foregroundStyle(index == selected ? EdenColor.textSelected
                                                      : EdenColor.textTertiary)
                    .frame(width: 28, height: 24)
                    .background(index == selected ? EdenColor.chipActiveFill : .clear,
                                in: .capsule)
                    .shadow(color: index == selected ? EdenColor.raisedShadow : .clear,
                            radius: 1, y: 1)
            }
        }
        .padding(2)
        .background(EdenColor.keycapFill, in: .capsule)
    }
}
