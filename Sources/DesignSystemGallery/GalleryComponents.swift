import DesignSystem
import SwiftUI

struct MetricList: View {
    private var metrics: [(String, CGFloat)] {
        [("sidebarWidth", EdenMetric.sidebarWidth),
         ("sidebarInset", EdenMetric.sidebarInset),
         ("sidebarColumn", EdenMetric.sidebarColumn),
         ("sidebarContent", EdenMetric.sidebarContent),
         ("sidebarPadding", EdenMetric.sidebarPadding),
         ("rowHeight", EdenMetric.rowHeight),
         ("groupHeaderHeight", EdenMetric.groupHeaderHeight),
         ("createPillHeight", EdenMetric.createPillHeight),
         ("switcherHeight", EdenMetric.switcherHeight),
         ("iconSlot", EdenMetric.iconSlot),
         ("navGlyph", EdenMetric.navGlyph),
         ("mono18", EdenMetric.mono18),
         ("childRowHeight", EdenMetric.childRowHeight),
         ("libraryMaxWidth", EdenMetric.libraryMaxWidth),
         ("libraryPaddingH", EdenMetric.libraryPaddingH),
         ("libraryPaddingTop", EdenMetric.libraryPaddingTop),
         ("libraryPaddingBottom", EdenMetric.libraryPaddingBottom),
         ("pillHeight", EdenMetric.pillHeight),
         ("searchFieldHeight", EdenMetric.searchFieldHeight),
         ("segmentedHeight", EdenMetric.segmentedHeight),
         ("modalWidth", EdenMetric.modalWidth),
         ("modalTopInset", EdenMetric.modalTopInset),
         ("fieldHeight", EdenMetric.fieldHeight),
         ("modalButtonHeight", EdenMetric.modalButtonHeight)]
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: 8)],
                  alignment: .leading, spacing: 8) {
            ForEach(metrics, id: \.0) { name, value in
                HStack(spacing: 8) {
                    Text(name).font(EdenFont.ui(12)).foregroundStyle(EdenColor.n700)
                    Spacer(minLength: 8)
                    Text(String(format: "%g", value))
                        .font(EdenFont.ui(12, .medium)).foregroundStyle(EdenColor.n900)
                }
                .padding(.horizontal, 10)
                .frame(height: EdenMetric.rowHeight)
                .background(EdenColor.card, in: .rect(cornerRadius: EdenRadius.md, style: .continuous))
                .edenBorder(EdenColor.black(6), radius: EdenRadius.md)
            }
        }
    }
}

struct ControlRow: View {
    var body: some View {
        HStack(spacing: 16) {
            Button("+ New") {}.buttonStyle(EdenPillButtonStyle())
            Button("Pull now") {}.buttonStyle(EdenPillButtonStyle())
            Button("Disabled") {}.buttonStyle(EdenPillButtonStyle()).disabled(true)
            Button("Cancel") {}.buttonStyle(EdenGhostButtonStyle())
            Button("Create Project") {}.buttonStyle(EdenPrimaryButtonStyle())
            Button("Disabled") {}.buttonStyle(EdenPrimaryButtonStyle()).disabled(true)
        }
    }
}

struct ComponentRow: View {
    var body: some View {
        HStack(spacing: 20) {
            EdenKbd(keys: ["⌘", "K"])
            EdenMonogram(text: "Principle")
            EdenMonogram(text: "Vessa", size: .mono18)
            EdenFilterChip(title: "All", symbol: "square.grid.2x2", isActive: true)
            EdenFilterChip(title: "Type", symbol: "doc", chevron: true)
            EdenSegmented(titles: ["Grid", "List", "Creators"], selected: 0)
            EdenViewModes(symbols: ["square.grid.2x2", "point.3.connected.trianglepath.dotted", "list.bullet"],
                          selected: 0)
        }
    }
}

/// The sidebar's child rows: h28, r10, 14/400 `n600`, hung off a 1 px
/// `guideRail`. There is no `EdenSidebarRow` control in the package yet, so
/// this is the gallery showing what the metrics add up to.
struct ChildRowSample: View {
    private let titles = ["Today", "This week", "Archive"]

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            EdenColor.guideRail.frame(width: 1)
            VStack(alignment: .leading, spacing: 2) {
                ForEach(titles, id: \.self) { title in
                    Text(title)
                        .font(EdenFont.ui(14))
                        .foregroundStyle(EdenColor.n600)
                        .padding(.horizontal, 10)
                        .frame(height: EdenMetric.childRowHeight, alignment: .leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(title == titles.first ? EdenColor.black(4) : .clear,
                                    in: .rect(cornerRadius: EdenRadius.childRow, style: .continuous))
                }
            }
        }
        .padding(12)
        .frame(width: 200)
        .background(EdenColor.sidebar, in: .rect(cornerRadius: EdenRadius.md, style: .continuous))
    }
}

struct SurfaceRow: View {
    var body: some View {
        HStack(spacing: 16) {
            surface("edenPanelShadow", fill: EdenColor.sidebar) { $0.edenPanelShadow() }
            surface("edenFloatShadow", fill: EdenColor.white(80)) { $0.edenFloatShadow() }
            surface("edenBorder(hairline)", fill: EdenColor.card) {
                $0.edenBorder(EdenColor.hairline, radius: EdenRadius.card)
            }
            // The wash belongs behind a content canvas, so it is shown on one.
            surface("EdenPageGradient", fill: EdenColor.canvas) {
                $0.overlay(
                    EdenPageGradient()
                        .clipShape(RoundedRectangle(cornerRadius: EdenRadius.card, style: .continuous))
                )
            }
        }
    }

    private func surface<Modified: View>(
        _ title: String,
        fill: Color,
        modifier: (AnyView) -> Modified
    ) -> some View {
        VStack(spacing: 8) {
            modifier(AnyView(
                RoundedRectangle(cornerRadius: EdenRadius.card, style: .continuous)
                    .fill(fill)
                    .frame(width: 180, height: 88)
            ))
            Text(title).font(EdenFont.ui(11)).foregroundStyle(EdenColor.n500)
        }
    }
}
