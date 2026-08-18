import CoreGraphics
import Foundation

/// Turns one SVG `d` string into a `CGPath`.
///
/// Only the commands Tabler's 24-grid outlines actually use are supported —
/// `M m L l H h V v C c S s A a Z z`. Anything else is a glyph this set does
/// not contain, so it is skipped rather than guessed at.
enum EdenIconPath {
    /// `d` is read in the 24-grid the glyph was authored in and scaled by
    /// `scale` (the rendered size ÷ 24).
    static func cgPath(_ d: String, scale: CGFloat) -> CGPath {
        let path = CGMutablePath()
        var scanner = Scanner(d)
        var current = CGPoint.zero
        var start = CGPoint.zero
        // Where the previous cubic's second control point was, for `s`/`S`.
        var lastControl: CGPoint?
        var command: Character = "M"

        func point(_ x: CGFloat, _ y: CGFloat, relative: Bool) -> CGPoint {
            relative ? CGPoint(x: current.x + x, y: current.y + y) : CGPoint(x: x, y: y)
        }
        func move(to p: CGPoint) {
            path.move(to: CGPoint(x: p.x * scale, y: p.y * scale))
            current = p
            start = p
            lastControl = nil
        }
        func line(to p: CGPoint) {
            path.addLine(to: CGPoint(x: p.x * scale, y: p.y * scale))
            current = p
            lastControl = nil
        }
        func curve(_ c1: CGPoint, _ c2: CGPoint, _ end: CGPoint) {
            path.addCurve(to: CGPoint(x: end.x * scale, y: end.y * scale),
                          control1: CGPoint(x: c1.x * scale, y: c1.y * scale),
                          control2: CGPoint(x: c2.x * scale, y: c2.y * scale))
            current = end
            lastControl = c2
        }

        while true {
            if let letter = scanner.command() { command = letter }
            guard scanner.hasNumber || command == "Z" || command == "z" else { break }
            let relative = command.isLowercase
            switch command.lowercased().first {
            case "m":
                guard let x = scanner.number(), let y = scanner.number() else { return path }
                move(to: point(x, y, relative: relative))
                // A repeated pair after `M` is an implicit `L` (SVG 8.3.2).
                command = relative ? "l" : "L"
            case "l":
                guard let x = scanner.number(), let y = scanner.number() else { return path }
                line(to: point(x, y, relative: relative))
            case "h":
                guard let x = scanner.number() else { return path }
                line(to: CGPoint(x: relative ? current.x + x : x, y: current.y))
            case "v":
                guard let y = scanner.number() else { return path }
                line(to: CGPoint(x: current.x, y: relative ? current.y + y : y))
            case "c":
                guard let a = scanner.pair(), let b = scanner.pair(), let e = scanner.pair()
                else { return path }
                curve(point(a.x, a.y, relative: relative),
                      point(b.x, b.y, relative: relative),
                      point(e.x, e.y, relative: relative))
            case "s":
                guard let b = scanner.pair(), let e = scanner.pair() else { return path }
                let reflected = lastControl.map {
                    CGPoint(x: 2 * current.x - $0.x, y: 2 * current.y - $0.y)
                } ?? current
                curve(reflected,
                      point(b.x, b.y, relative: relative),
                      point(e.x, e.y, relative: relative))
            case "a":
                guard let radii = scanner.pair(), let rotation = scanner.number(),
                      let large = scanner.flag(), let sweep = scanner.flag(),
                      let e = scanner.pair()
                else { return path }
                let end = point(e.x, e.y, relative: relative)
                for segment in EdenArc.curves(from: current, to: end, radii: radii,
                                              rotation: rotation, largeArc: large, sweep: sweep) {
                    curve(segment.control1, segment.control2, segment.end)
                }
                current = end
                lastControl = nil
            case "z":
                path.closeSubpath()
                current = start
                lastControl = nil
                // `Z` takes no arguments and does not repeat: without clearing
                // it, a `d` that ends in `z` would close forever.
                command = "\0"
            default:
                return path
            }
        }
        return path
    }
}

/// A number reader over an SVG `d` string. Flags in an elliptical-arc command
/// are single characters (`a1 1 0 010 1` is legal), so they are read as such
/// rather than as numbers.
private struct Scanner {
    private let characters: [Character]
    private var index = 0

    init(_ text: String) { characters = Array(text) }

    private mutating func skipSeparators() {
        while index < characters.count,
              characters[index] == " " || characters[index] == "," || characters[index] == "\n" {
            index += 1
        }
    }

    mutating func command() -> Character? {
        skipSeparators()
        guard index < characters.count, characters[index].isLetter else { return nil }
        defer { index += 1 }
        return characters[index]
    }

    var hasNumber: Bool {
        var probe = index
        while probe < characters.count,
              characters[probe] == " " || characters[probe] == "," { probe += 1 }
        guard probe < characters.count else { return false }
        let c = characters[probe]
        return c.isNumber || c == "-" || c == "+" || c == "."
    }

    mutating func number() -> CGFloat? {
        skipSeparators()
        var text = ""
        if index < characters.count, characters[index] == "-" || characters[index] == "+" {
            text.append(characters[index])
            index += 1
        }
        while index < characters.count, characters[index].isNumber || characters[index] == "." {
            // A second dot starts the next number ("1.5.5" is two of them).
            if characters[index] == ".", text.contains(".") { break }
            text.append(characters[index])
            index += 1
        }
        guard let value = Double(text) else { return nil }
        return CGFloat(value)
    }

    mutating func pair() -> CGPoint? {
        guard let x = number(), let y = number() else { return nil }
        return CGPoint(x: x, y: y)
    }

    mutating func flag() -> Bool? {
        skipSeparators()
        guard index < characters.count else { return nil }
        let c = characters[index]
        guard c == "0" || c == "1" else { return nil }
        index += 1
        return c == "1"
    }
}
