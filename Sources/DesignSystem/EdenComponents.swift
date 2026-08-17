import SwiftUI

/// The `⌘ K` keycaps in the Create-or-search pill: 15 pt square, r4,
/// `black/5%`, 10/500 `#737373`.
public struct EdenKbd: View {
    public let keys: [String]

    public init(keys: [String]) {
        self.keys = keys
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(EdenFont.ui(10, .medium))
                    .foregroundStyle(EdenColor.n500)
                    .frame(minWidth: 15, minHeight: 15)
                    .padding(.horizontal, 2)
                    .background(EdenColor.black(5), in: .rect(cornerRadius: 4))
            }
        }
    }
}

/// A Project's initial in the switcher: 20 pt square, r6, `black/6%`, 10/600.
public struct EdenMonogram: View {
    public let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text.prefix(1).uppercased())
            .font(EdenFont.ui(10, .semibold))
            .foregroundStyle(EdenColor.n700)
            .frame(width: EdenMetric.iconSlot, height: EdenMetric.iconSlot)
            .background(EdenColor.black(6), in: .rect(cornerRadius: 6))
    }
}

/// A Library filter chip. Presentational only — the host app owns filtering.
public struct EdenFilterChip: View {
    public let title: String
    public let symbol: String
    public var chevron: Bool
    public var isActive: Bool

    public init(title: String, symbol: String, chevron: Bool = false, isActive: Bool = false) {
        self.title = title
        self.symbol = symbol
        self.chevron = chevron
        self.isActive = isActive
    }

    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: symbol).font(.system(size: 13))
            Text(title).font(EdenFont.ui(11.5, .medium))
            if chevron {
                Image(systemName: "chevron.down").font(.system(size: 9)).opacity(0.7)
            }
        }
        .foregroundStyle(isActive ? EdenColor.n900 : EdenColor.n500)
        .padding(.horizontal, 10)
        .frame(height: EdenMetric.pillHeight)
        .background(isActive ? Color.white : .clear, in: .capsule)
        .overlay(Capsule().strokeBorder(isActive ? EdenColor.black(15) : .clear))
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
                    .font(EdenFont.ui(11.5, .medium))
                    .foregroundStyle(index == selected ? EdenColor.n800 : EdenColor.n500)
                    .padding(.horizontal, 10)
                    .frame(height: EdenMetric.segmentedHeight - 4)
                    .background(index == selected ? EdenColor.black(5.5) : .clear, in: .capsule)
            }
        }
        .padding(2)
        .frame(height: EdenMetric.segmentedHeight)
        .background(EdenColor.black(1.8), in: .capsule)
        .overlay(Capsule().strokeBorder(EdenColor.black(6.5)))
    }
}

/// The view-mode glyphs beside a page title (Browse / Graph / Index).
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
                    .font(.system(size: 14))
                    .foregroundStyle(index == selected ? EdenColor.n800 : EdenColor.n400)
                    .frame(width: 28, height: 24)
                    .background(index == selected ? Color.white : .clear, in: .capsule)
                    .shadow(color: index == selected ? EdenColor.black(8) : .clear, radius: 1, y: 1)
            }
        }
        .padding(2)
        .background(EdenColor.black(5), in: .capsule)
    }
}
