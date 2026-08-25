import AppKit
import SwiftUI

/// How a token carries two values at once.
///
/// `CONTEXT.md`: the package follows the **System Appearance** and never picks
/// one itself. So a semantic token is not a colour, it is a *pair* — and the
/// window decides which half is drawn, re-deciding on its own the moment the
/// System flips.
///
/// The pair is carried by `NSColor(name:dynamicProvider:)`, wrapped back into
/// a SwiftUI `Color`. That is what keeps every token a plain `static let`
/// `Color`: the resolution happens inside AppKit at draw time, so a call site
/// needs no environment, no view, and no change — `EdenColor.canvas` is used in
/// a modifier, a `ButtonStyle` or a preview exactly as it was when it was one
/// flat value. Rejected alternatives: an `@Environment` lookup (would force
/// every call site to be inside a view) and a global mutable "current
/// appearance" (would not follow a second window on a second display).
///
/// Reading a token back in a test is the mirror of drawing it: resolve it
/// inside `NSAppearance.performAsCurrentDrawingAppearance` and both halves can
/// be asserted. Rendering under an Appearance is `.environment(\.colorScheme,)`.
extension EdenColor {
    /// A token with one value per Appearance. `light` must stay exactly what
    /// the token was before this pair existed — light rendering is measured
    /// and shipped, and does not move.
    public static func dual(light: Color, dark: Color) -> Color {
        // Both halves are resolved to AppKit once, here, rather than on every
        // draw: they are plain sRGB values and cannot themselves be dynamic.
        let lightValue = NSColor(light), darkValue = NSColor(dark)
        return Color(nsColor: NSColor(name: nil) { appearance in
            appearance.isDark ? darkValue : lightValue
        })
    }

    /// The same pair, spelled as two hex values — the common case.
    public static func dual(light: UInt32, dark: UInt32) -> Color {
        dual(light: hex(light), dark: hex(dark))
    }
}

extension NSAppearance {
    /// Whether this Appearance is a dark one, accessibility variants included.
    /// `bestMatch` rather than a name comparison: macOS has four dark
    /// Appearances and only the plain one is called `darkAqua`.
    public var isDark: Bool {
        bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
    }
}
