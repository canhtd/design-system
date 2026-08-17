import SwiftUI

struct ColourGrid: View {
    private var swatches: [(String, Color, String)] {
        [("canvas", EdenColor.canvas, "#fafaf8"),
         ("sidebar", EdenColor.sidebar, "#f4f3ee"),
         ("card", EdenColor.card, "#ffffff"),
         ("textPrimary", EdenColor.textPrimary, "#272523"),
         ("n900", EdenColor.n900, "#171717"),
         ("n800", EdenColor.n800, "#262626"),
         ("n700", EdenColor.n700, "#404040"),
         ("n600", EdenColor.n600, "#525252"),
         ("n500", EdenColor.n500, "#737373"),
         ("n400", EdenColor.n400, "#a1a1a1"),
         ("n300", EdenColor.n300, "#d4d4d4"),
         ("n200", EdenColor.n200, "#e5e5e5"),
         ("primary", EdenColor.primary, "#09321f"),
         ("primary5", EdenColor.primary5, "#eff2ee"),
         ("primary80", EdenColor.primary80, "#224735"),
         ("olive", EdenColor.olive, "#39624d"),
         ("hairline", EdenColor.hairline, "#e0e0e0")]
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
            ForEach(swatches, id: \.0) { name, colour, hex in
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: EdenRadius.md, style: .continuous)
                        .fill(colour)
                        .frame(height: 48)
                        .edenBorder(EdenColor.black(10), radius: EdenRadius.md)
                    Text(name).font(EdenFont.ui(12, .medium)).foregroundStyle(EdenColor.n800)
                    Text(hex).font(EdenFont.ui(11)).foregroundStyle(EdenColor.n400)
                }
            }
        }
    }
}

struct AlphaRamps: View {
    private let steps: [Double] = [1.8, 3, 4, 5, 5.5, 6, 6.5, 7, 8, 10, 15]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ramp("black(%)", over: EdenColor.canvas, label: EdenColor.n400) { EdenColor.black($0) }
            // White-on-white is invisible: the white ramp is only legible over
            // a dark surface, which is how Eden uses it (chrome over content).
            ramp("white(%)", over: EdenColor.n800, label: EdenColor.n300) { EdenColor.white($0) }
        }
    }

    private func ramp(_ title: String,
                      over backdrop: Color,
                      label: Color,
                      _ colour: @escaping (Double) -> Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(EdenFont.ui(11.5)).foregroundStyle(EdenColor.n500)
            HStack(spacing: 6) {
                ForEach(steps, id: \.self) { step in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: EdenRadius.sm, style: .continuous)
                            .fill(colour(step))
                            .frame(width: 56, height: 34)
                            .edenBorder(EdenColor.black(10), radius: EdenRadius.sm)
                        Text(String(format: "%g", step))
                            .font(EdenFont.ui(10)).foregroundStyle(label)
                    }
                }
            }
            .padding(8)
            .background(backdrop, in: .rect(cornerRadius: EdenRadius.md, style: .continuous))
        }
    }
}

struct TypeScale: View {
    private var rows: [(CGFloat, Font.Weight, String)] {
        [(27, .medium, "Library page title"),
         (26, .medium, "Discover tab title"),
         (21, .medium, "Board title"),
         (15, .regular, "Item-detail body"),
         (14.5, .regular, "Sidebar Academy row"),
         (14, .regular, "Sidebar nav / chat rows"),
         (13.5, .regular, "Page subtitle, section headers"),
         (13.5, .medium, "List-row title"),
         (13, .semibold, "Banner title, author name"),
         (12.5, .semibold, "Card creator name"),
         (12.5, .medium, "Modal buttons, promo title"),
         (12, .regular, "Row age, context chip"),
         (12, .medium, "Pill button label"),
         (11.5, .medium, "Filter chips, segmented"),
         (11.5, .regular, "Card metric row"),
         (11, .regular, "Card age, timestamps"),
         (10.5, .regular, "Card footer line"),
         (10, .medium, "kbd, monogram, badges")]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text(String(format: "%g", row.0))
                        .font(EdenFont.ui(11)).foregroundStyle(EdenColor.n400)
                        .frame(width: 34, alignment: .trailing)
                    Text(row.2)
                        .font(EdenFont.ui(row.0, row.1))
                        .foregroundStyle(EdenColor.textPrimary)
                }
            }
        }
    }
}

struct RadiusRow: View {
    private var radii: [(String, CGFloat)] {
        [("sm", EdenRadius.sm), ("md", EdenRadius.md), ("card", EdenRadius.card),
         ("lg", EdenRadius.lg), ("modal", EdenRadius.modal)]
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(radii, id: \.0) { name, value in
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: value, style: .continuous)
                        .fill(EdenColor.card)
                        .frame(width: 92, height: 72)
                        .edenBorder(EdenColor.black(10), radius: value)
                    Text("\(name) · \(String(format: "%g", value))")
                        .font(EdenFont.ui(11)).foregroundStyle(EdenColor.n500)
                }
            }
        }
    }
}
