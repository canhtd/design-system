import DesignSystem
import SwiftUI

/// Every token in the package on one scrolling page, so a human can eyeball
/// them: `swift run TokenGallery`, an Xcode preview, or an `ImageRenderer`
/// snapshot in a test.
public struct EdenTokenGallery: View {
    /// Which Appearance the *gallery window* is previewing. A development
    /// affordance and nothing more: the package itself has no preference and
    /// no toggle (ADR 0001), so this sets the window's Appearance and lets the
    /// tokens do exactly what they would do on a System flip.
    @State private var preview = GalleryAppearance.system

    public init() {}

    @ViewBuilder public var body: some View {
        let page = VStack(spacing: 0) {
            GalleryAppearanceSwitch(preview: $preview)
            ScrollView { content }
        }
        .background(
            ZStack {
                EdenColor.canvas
                EdenPageGradient()
            }
            .ignoresSafeArea()
        )

        // `System` applies neither override, so the window follows macOS.
        // The other two pin both the SwiftUI environment and the window's
        // Appearance: the first is what SwiftUI resolves colours against, the
        // second is what AppKit hands to a dynamic `NSColor`.
        if let scheme = preview.colorScheme {
            page.environment(\.colorScheme, scheme).preferredColorScheme(scheme)
        } else {
            page
        }
    }

    /// The page without the scroll view — what a snapshot renders.
    public var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            GallerySection("Colour") { ColourGrid() }
            GallerySection("Alpha ramps") { AlphaRamps() }
            GallerySection("Type scale — SF Pro at Eden px sizes") { TypeScale() }
            GallerySection("Radii") { RadiusRow() }
            GallerySection("Metrics") { MetricList() }
            GallerySection("Controls") { ControlRow() }
            GallerySection("Components") { ComponentRow() }
            GallerySection("Icons — Tabler, 24 grid, stroke 1.7") { IconSheet() }
            GallerySection("Sidebar child rows") { ChildRowSample() }
            GallerySection("Surfaces") { SurfaceRow() }
        }
        .padding(32)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EdenColor.canvas)
    }
}

struct GallerySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(EdenFont.ui(13.5, .medium))
                .foregroundStyle(EdenColor.textSecondary)
            content
        }
    }
}

#Preview {
    EdenTokenGallery()
        .frame(width: 900, height: 700)
}


/// What the gallery's switch can be set to.
enum GalleryAppearance: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    /// `nil` means "whatever macOS says", which is the package's own model.
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

/// The switch itself. Deliberately a plain AppKit segmented control rather
/// than `EdenSegmented`: it is gallery chrome, not an Eden control, and it
/// should not be mistaken for one of the things on display.
struct GalleryAppearanceSwitch: View {
    @Binding var preview: GalleryAppearance

    var body: some View {
        HStack(spacing: 10) {
            Text("Appearance")
                .font(EdenFont.ui(12, .medium))
                .foregroundStyle(EdenColor.textSecondary)
            Picker("Appearance", selection: $preview) {
                ForEach(GalleryAppearance.allCases) { Text($0.title).tag($0) }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 220)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(EdenColor.sidebar)
        .overlay(alignment: .bottom) { EdenColor.hairline.frame(height: 1) }
    }
}
