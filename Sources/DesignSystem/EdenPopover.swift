import SwiftUI

/// The surface every floating menu in Eden is drawn on: r12, **opaque** white,
/// a 1 pt `hairline` border, the float shadow, and 4 pt of padding around its
/// rows. No callout tail — Eden's popovers are panels anchored to a control,
/// not speech bubbles pointing at it.
///
/// It is a plain container rather than a presentation modifier on purpose: the
/// host app decides where it hangs and what closes it, and a system popover
/// would bring back both the tail and a translucent ground.
public struct EdenPopover<Content: View>: View {
    public let width: CGFloat
    @ViewBuilder public var content: Content

    public init(width: CGFloat, @ViewBuilder content: () -> Content) {
        self.width = width
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) { content }
            .frame(width: width, alignment: .leading)
            .padding(EdenMetric.popoverPadding)
            .background(EdenColor.card,
                        in: .rect(cornerRadius: EdenRadius.md, style: .continuous))
            .edenBorder(EdenColor.hairline, radius: EdenRadius.md)
            .edenFloatShadow()
    }
}

/// A popover's own section label: `Recently deleted`, `Daily pull · 5 hashtags`.
public struct EdenPopoverHeader<Trailing: View>: View {
    public let title: String
    @ViewBuilder public var trailing: Trailing

    public init(_ title: String, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(title)
                .edenText(EdenType.chip)
                .foregroundStyle(EdenColor.n500)
            Spacer(minLength: 8)
            trailing
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 5)
    }
}

extension EdenPopoverHeader where Trailing == EmptyView {
    public init(_ title: String) {
        self.init(title) { EmptyView() }
    }
}
