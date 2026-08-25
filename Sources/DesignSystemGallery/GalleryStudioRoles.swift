import AppKit
import DesignSystem
import SwiftUI

/// The roles v0.3.1 added, drawn as the thing each one actually is.
///
/// A flat swatch is the wrong picture for most of these: seven of the nine are
/// a wash or an edge that only exists *against* something, and a card's warm
/// border reads as grey in a square. So the fills are drawn as plates on a
/// card and the edges as edges, and each one is labelled with the value the
/// Appearance being previewed resolves it to.
struct StudioRoleRow: View {
    @Environment(\.colorScheme) private var colorScheme

    private var fills: [(String, Color)] {
        [("composerFill", EdenColor.composerFill),
         ("inputFieldFill", EdenColor.inputFieldFill),
         ("plateFill", EdenColor.plateFill),
         ("sheetFooterFill", EdenColor.sheetFooterFill)]
    }

    private var edges: [(String, Color)] {
        [("ruleFaint", EdenColor.ruleFaint),
         ("inputFieldBorder", EdenColor.inputFieldBorder),
         ("cardHoverBorder", EdenColor.cardHoverBorder),
         ("chipHoverBorder", EdenColor.chipHoverBorder)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            grid { ForEach(fills, id: \.0) { name, colour in fill(name, colour) } }
            grid { ForEach(edges, id: \.0) { name, colour in edge(name, colour) } }
            onPrimary
        }
    }

    private func grid<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 168), spacing: 12)], spacing: 12,
                  content: content)
    }

    /// A wash is only itself over the surface it washes, so each sits on a card.
    private func fill(_ name: String, _ colour: Color) -> some View {
        labelled(name, colour) {
            RoundedRectangle(cornerRadius: EdenRadius.md, style: .continuous)
                .fill(EdenColor.card)
                .frame(height: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: EdenRadius.sm, style: .continuous)
                        .fill(colour)
                        .padding(8)
                }
        }
    }

    /// An edge is a line, and a 1 pt line is the only honest way to show one —
    /// the rule roles are drawn as the hairline they are, not as a fill.
    private func edge(_ name: String, _ colour: Color) -> some View {
        labelled(name, colour) {
            RoundedRectangle(cornerRadius: EdenRadius.md, style: .continuous)
                .fill(EdenColor.card)
                .frame(height: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: EdenRadius.sm, style: .continuous)
                        .strokeBorder(colour)
                        .padding(8)
                }
                .overlay { colour.frame(height: 1).padding(.horizontal, 20) }
        }
    }

    /// The one ink in the set, on the fill it belongs to — `primary80`, never
    /// the bare accent, which is light enough under dark that white is 2.4:1.
    private var onPrimary: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: EdenRadius.checkbox, style: .continuous)
                .fill(EdenColor.primary80)
                .frame(width: 18, height: 18)
                .overlay {
                    EdenIconView(.check, size: EdenIconSize.smallChevron)
                        .foregroundStyle(EdenColor.onPrimaryInk)
                }
            Text("onPrimaryInk on primary80")
                .font(EdenFont.ui(12, .medium))
                .foregroundStyle(EdenColor.textSelected)
        }
    }

    private func labelled<Content: View>(_ name: String, _ colour: Color,
                                         @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            content()
            Text(name).font(EdenFont.ui(12, .medium)).foregroundStyle(EdenColor.textSelected)
            Text(GalleryValue.label(of: colour, colorScheme))
                .font(EdenFont.ui(11)).foregroundStyle(EdenColor.textTertiary)
        }
    }
}

/// `EdenCard` — a real card, drawn with the tokens rather than described.
struct CardTokenRow: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            card("shadowRest", lift: EdenCard.shadowRest) {
                Text("A card is its text and nothing else.")
                    .font(EdenFont.ui(EdenCard.text.size))
                    .lineSpacing(EdenCard.text.lineHeight.map { $0 - EdenCard.text.size } ?? 0)
                    .foregroundStyle(EdenCard.ink)
            }
            card("shadowFocused", lift: EdenCard.shadowFocused, bottom: EdenCard.composerPaddingBottom) {
                Text("Typing…")
                    .font(EdenFont.ui(EdenCard.editorText.size))
                    .foregroundStyle(EdenCard.ink)
            }
            .overlay(alignment: .bottomTrailing) {
                Text("New card ⌘↵")
                    .font(EdenFont.ui(EdenCard.hintText.size))
                    .foregroundStyle(EdenCard.hint)
                    .padding(.trailing, EdenCard.paddingH)
                    .padding(.bottom, EdenCard.paddingTop)
            }
        }
    }

    private func card<Content: View>(_ name: String, lift: EdenCard.Shadow,
                                     bottom: CGFloat = EdenCard.paddingBottom,
                                     @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
                .frame(width: 260, alignment: .leading)
                .padding(.top, EdenCard.paddingTop)
                .padding(.horizontal, EdenCard.paddingH)
                .padding(.bottom, bottom)
                .background(EdenColor.card,
                            in: .rect(cornerRadius: EdenCard.radius, style: .continuous))
                .edenBorder(EdenCard.borderWarm, radius: EdenCard.radius)
                .edenCardShadow(lift)
            Text("\(name) · r\(String(format: "%g", EdenCard.radius)) · "
                 + "\(GalleryValue.label(of: EdenCard.borderWarm, colorScheme))")
                .font(EdenFont.ui(11)).foregroundStyle(EdenColor.textSecondary)
                .padding(.top, 10)
        }
    }
}

/// Reading a token back so a label cannot drift from the value it names. A
/// token is a pair, so the read has to say which half: the gallery labels the
/// half the page is being drawn in, or a dark page lists light values.
enum GalleryValue {
    static func label(of colour: Color, _ scheme: ColorScheme) -> String {
        var resolved: NSColor?
        NSAppearance(named: scheme == .dark ? .darkAqua : .aqua)?.performAsCurrentDrawingAppearance {
            resolved = NSColor(colour).usingColorSpace(.sRGB)
        }
        guard let srgb = resolved else { return "—" }
        let hex = String(format: "#%02x%02x%02x",
                         Int(round(srgb.redComponent * 255)),
                         Int(round(srgb.greenComponent * 255)),
                         Int(round(srgb.blueComponent * 255)))
        let alpha = Double(srgb.alphaComponent)
        guard alpha < 0.999 else { return hex }
        return hex + String(format: " · %g%%", (alpha * 1000).rounded() / 10)
    }
}
