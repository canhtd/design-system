import SwiftUI

/// Every token in the package on one scrolling page, so a human can eyeball
/// them: `swift run TokenGallery`, an Xcode preview, or an `ImageRenderer`
/// snapshot in a test.
public struct EdenTokenGallery: View {
    public init() {}

    public var body: some View {
        ScrollView {
            content
        }
        .background(
            ZStack {
                EdenColor.canvas
                EdenPageGradient()
            }
            .ignoresSafeArea()
        )
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
                .foregroundStyle(EdenColor.n500)
            content
        }
    }
}

#Preview {
    EdenTokenGallery()
        .frame(width: 900, height: 700)
}
