import Foundation
import XCTest

/// `CONTEXT.md`: *"Views only ever use semantic tokens."* This reads the
/// package's own source off disk and holds that line, because the compiler
/// cannot: a view that spells `black(6)` or `n500` compiles perfectly and then
/// paints black-on-black the moment the window is dark.
///
/// It is a guard, not a style rule — the fix for a failure is to name the role
/// in `EdenColorInk.swift` / `EdenColorControl.swift` and use it, never to add
/// the file to `tokenFiles`.
final class EdenSemanticTokenGuardTests: XCTestCase {
    /// The only files allowed to spell a colour value. Each one defines
    /// tokens and draws nothing; every other file in the target is a view, a
    /// style or a modifier.
    private static let tokenFiles: Set<String> = [
        "EdenColor.swift",          // the palette, the surfaces, the helpers
        "EdenColorInk.swift",       // the ink roles
        "EdenColorControl.swift",   // fills, edges, lifts, washes
        "EdenColorBoard.swift",     // the Board, the Chat turn, the rules
        "EdenSignalColor.swift",    // the two signal ladders' measured hues
        "EdenCard.swift"            // a card on a Board: its edge, ink and lift
    ]

    private static let forbidden: [(what: String, pattern: String)] = [
        ("the neutral ramp (n900…n200)", #"\bn[0-9]{3}\b"#),
        ("a black or white literal", #"\.\s*(white|black)\b"#),
        ("a hex literal", #"0[xX][0-9A-Fa-f]{3,8}\b"#),
        ("a component-wise Color", #"Color\s*\(\s*(\.sRGB|red\s*:|white\s*:|hue\s*:)"#),
        // A system colour follows the Appearance too — but on AppKit's terms,
        // not Eden's, so it is a second uncontrolled palette. The lookbehind
        // is what lets `EdenColor.primary` through and stops a bare
        // `.foregroundStyle(.secondary)`.
        ("a system colour", #"(?<![A-Za-z0-9_])\.\s*(gray|secondary|primary|accentColor)\b"#),
        // Spelled out, `Color.primary` needs its own rule: the lookbehind
        // above exists to let `EdenColor.primary` past, and it lets this past
        // with it. `\bColor` does not match inside `EdenColor`.
        ("a system colour", #"\bColor\s*\.\s*(gray|secondary|primary|accentColor)\b"#),
        ("an AppKit colour", #"\bNSColor\s*\."#)
    ]

    func testViewFilesSpellNoColourOfTheirOwn() throws {
        let files = try Self.sourceFiles()
        XCTAssertGreaterThan(files.count, 10, "the source directory was not found or is empty")

        var offences: [String] = []
        for url in files where !Self.tokenFiles.contains(url.lastPathComponent) {
            let code = Self.stripCommentsAndStrings(try String(contentsOf: url, encoding: .utf8))
            for (what, pattern) in Self.forbidden {
                for line in Self.lines(of: code, matching: pattern) {
                    offences.append("\(url.lastPathComponent):\(line.number) spells \(what) — \(line.text)")
                }
            }
        }
        XCTAssert(offences.isEmpty, """
            A view spelled a colour instead of asking for a role:
            \(offences.joined(separator: "\n"))
            """)
    }

    /// A guard that cannot fail is decoration. These are the lines the rules
    /// are meant to catch, and the ones they must not: `EdenColor.primary` is
    /// a token and `.primary` is AppKit's, and only a lookbehind tells them
    /// apart.
    func testThePatternsCatchWhatTheyClaimAndNothingElse() {
        let caught = [
            ".foregroundStyle(EdenColor.n500)",
            ".background(EdenColor.black(5))",
            ".background(Color.white)",
            ".foregroundStyle(.white)",
            "let a = EdenColor.hex(0xE17100)",
            "Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1)",
            ".foregroundStyle(.secondary)",
            ".foregroundStyle(.gray)",
            ".fill(Color.primary)",
            ".tint(.accentColor)",
            "let c = NSColor.controlAccentColor"
        ]
        let allowed = [
            ".foregroundStyle(EdenColor.textSecondary)",
            ".background(EdenColor.chipActiveFill)",
            ".fill(EdenColor.primary)",
            ".fill(EdenColor.primaryTint)",
            ".overlay(EdenColor.hairline)",
            "if colorScheme == .dark { }",
            ".blendMode(.multiply)",
            ".background(.clear)",
            "Color(nsColor: resolved)",
            "let n = EdenMetric.mono18"
        ]
        for line in caught {
            XCTAssert(offends(line), "the guard would have let through: \(line)")
        }
        for line in allowed {
            XCTAssertFalse(offends(line), "the guard would have rejected: \(line)")
        }
    }

    private func offends(_ line: String) -> Bool {
        let code = Self.stripCommentsAndStrings(line)
        return Self.forbidden.contains { !Self.lines(of: code, matching: $0.pattern).isEmpty }
    }

    /// The allowlist is only honest if every file on it is really there: a
    /// renamed token file must not quietly widen the exemption.
    func testEveryExemptFileExists() throws {
        let present = Set(try Self.sourceFiles().map(\.lastPathComponent))
        for name in Self.tokenFiles {
            XCTAssert(present.contains(name),
                      "\(name) is exempt from the guard but is not in Sources/DesignSystem")
        }
    }

    // MARK: Reading the source

    /// Walks the target recursively: a file that grows a `Sources/DesignSystem/
    /// <Something>/` subdirectory later must not be silently unguarded.
    private static func sourceFiles() throws -> [URL] {
        let directory = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // DesignSystemTests
            .deletingLastPathComponent()   // Tests
            .deletingLastPathComponent()   // the package
            .appendingPathComponent("Sources/DesignSystem")
        guard let walk = FileManager.default.enumerator(at: directory,
                                                       includingPropertiesForKeys: nil) else {
            return []
        }
        return walk.compactMap { $0 as? URL }
            .filter { $0.pathExtension == "swift" }
            .sorted { $0.path < $1.path }
    }

    /// Blanks out `//` comments, `/* */` comments and string literals, keeping
    /// newlines so that line numbers still point at the offending line. A hex
    /// in prose is documentation; a hex in code is the bug.
    static func stripCommentsAndStrings(_ source: String) -> String {
        enum State { case code, line, block, string }
        var state = State.code
        var output = ""
        let characters = Array(source)
        var index = 0
        while index < characters.count {
            let character = characters[index]
            let next = index + 1 < characters.count ? characters[index + 1] : "\0"
            switch state {
            case .code:
                if character == "/" && next == "/" { state = .line; output += "  "; index += 2; continue }
                if character == "/" && next == "*" { state = .block; output += "  "; index += 2; continue }
                if character == "\"" { state = .string; output += " "; index += 1; continue }
                output.append(character)
            case .line:
                if character == "\n" { state = .code; output.append(character) } else { output += " " }
            case .block:
                if character == "*" && next == "/" { state = .code; output += "  "; index += 2; continue }
                output += character == "\n" ? "\n" : " "
            case .string:
                if character == "\\" { output += "  "; index += 2; continue }
                if character == "\"" { state = .code; output += " "; index += 1; continue }
                output += character == "\n" ? "\n" : " "
            }
            index += 1
        }
        return output
    }

    static func lines(of code: String,
                              matching pattern: String) -> [(number: Int, text: String)] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return code.components(separatedBy: "\n").enumerated().compactMap { offset, line in
            let range = NSRange(line.startIndex..., in: line)
            guard regex.firstMatch(in: line, range: range) != nil else { return nil }
            return (offset + 1, line.trimmingCharacters(in: .whitespaces))
        }
    }
}
