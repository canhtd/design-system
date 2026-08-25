import AppKit
import SwiftUI
import XCTest

/// Reading a token the way AppKit draws it.
///
/// A semantic token is a pair, and which half comes out depends on the
/// Appearance that is current *at the moment it is resolved* — so a test that
/// wants the dark half asks for it inside a dark `NSAppearance`, exactly as a
/// dark window does. Shared by every test that checks both halves.
enum EdenTestAppearance {
    case light, dark
    var name: NSAppearance.Name { self == .dark ? .darkAqua : .aqua }
}

@MainActor
extension XCTestCase {
    func resolved(_ colour: Color, _ appearance: EdenTestAppearance) -> NSColor {
        var result: NSColor?
        NSAppearance(named: appearance.name)!.performAsCurrentDrawingAppearance {
            result = NSColor(colour).usingColorSpace(.sRGB)
        }
        return result ?? .clear
    }

    func hex(of colour: Color, _ appearance: EdenTestAppearance) -> UInt32 {
        let value = resolved(colour, appearance)
        return UInt32(round(value.redComponent * 255)) << 16
            | UInt32(round(value.greenComponent * 255)) << 8
            | UInt32(round(value.blueComponent * 255))
    }

    /// Asserts both halves of one token, colour and alpha.
    func assertPair(_ colour: Color, _ light: UInt32, _ dark: UInt32,
                    lightAlpha: Double = 1, darkAlpha: Double = 1,
                    file: StaticString = #filePath, line: UInt = #line) {
        let gotLight = hex(of: colour, .light), gotDark = hex(of: colour, .dark)
        XCTAssertEqual(gotLight, light,
                       String(format: "light: expected #%06X, got #%06X", light, gotLight),
                       file: file, line: line)
        XCTAssertEqual(gotDark, dark,
                       String(format: "dark: expected #%06X, got #%06X", dark, gotDark),
                       file: file, line: line)
        XCTAssertEqual(Double(resolved(colour, .light).alphaComponent), lightAlpha,
                       accuracy: 0.001, "light alpha", file: file, line: line)
        XCTAssertEqual(Double(resolved(colour, .dark).alphaComponent), darkAlpha,
                       accuracy: 0.001, "dark alpha", file: file, line: line)
    }
}
