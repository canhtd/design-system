import SwiftUI

/// How a block of markdown is set. `AttributedString(markdown:)` renders
/// emphasis and links but flattens `## Hook` into literal text, so a view that
/// wants Eden's headings lays the blocks out itself — and takes its measures
/// from here rather than spelling them.
///
/// Two of them, because the same Output is read in two places at two sizes:
/// in the Chat pane while it is being written, and on the Board as a document
/// once it is pinned.
public struct EdenMarkdownStyle: Sendable, Equatable {
    public let body: EdenTextStyle
    public let heading: EdenTextStyle
    /// Below a paragraph (`margin-bottom`), and around a heading.
    public let paragraphGap: CGFloat
    public let headingTop: CGFloat
    public let headingBottom: CGFloat
    /// How far a list hangs in (`padding-left: 1.5em`).
    public let listIndent: CGFloat

    public init(body: EdenTextStyle, heading: EdenTextStyle, paragraphGap: CGFloat,
                headingTop: CGFloat, headingBottom: CGFloat, listIndent: CGFloat) {
        self.body = body
        self.heading = heading
        self.paragraphGap = paragraphGap
        self.headingTop = headingTop
        self.headingBottom = headingBottom
        self.listIndent = listIndent
    }

    /// The assistant's answer inside a Chat pane (`.ai-sidepeek-chat .cc-md`,
    /// `.cc-md h4`: 0.95rem / 1.2rem / 0.6rem over a 0.9rem paragraph gap).
    public static let chat = EdenMarkdownStyle(
        body: EdenType.chatBody, heading: EdenType.chatHeading,
        paragraphGap: 14.4, headingTop: 19.2, headingBottom: 9.6, listIndent: 21)

    /// The same Output on the Board, as a document card (`proto .doccard .md`).
    public static let document = EdenMarkdownStyle(
        body: EdenType.cardBody, heading: EdenType.documentHeading,
        paragraphGap: 10, headingTop: 16, headingBottom: 4, listIndent: 21)
}
