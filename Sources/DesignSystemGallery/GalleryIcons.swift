import DesignSystem
import SwiftUI

/// Every Tabler glyph the package ships, at the size a sidebar row draws it and
/// again at four times that. The big one is the point: a path parser that drops
/// a curve is invisible at 16 pt and obvious at 64.
public struct IconSheet: View {
    public init() {}

    private let columns = [GridItem(.adaptive(minimum: 108), spacing: 12)]

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(EdenIcon.allCases, id: \.self) { icon in
                VStack(spacing: 8) {
                    EdenIconView(icon, size: 64)
                        .foregroundStyle(EdenColor.textSelected)
                    EdenIconView(icon, size: EdenIconSize.child)
                        .foregroundStyle(EdenColor.textControlQuiet)
                    Text(icon.rawValue)
                        .font(EdenFont.ui(10))
                        .foregroundStyle(EdenColor.textTertiary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(EdenColor.card, in: .rect(cornerRadius: EdenRadius.md, style: .continuous))
                .edenBorder(EdenColor.paneBorder, radius: EdenRadius.md)
            }
        }
    }
}
