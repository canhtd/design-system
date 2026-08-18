import DesignSystem
import SwiftUI
import XCTest

/// The glyph set is data plus a path parser, so both are checked here: every
/// Tabler outline in the set must parse, and must land inside the 24-grid box
/// it was drawn in. A glyph that silently parses to nothing renders as a blank
/// square in the app, which no screenshot review reliably catches.
final class EdenIconTests: XCTestCase {
    func testEveryGlyphCarriesPathData() {
        for icon in EdenIcon.allCases {
            XCTAssertFalse(icon.subpaths.isEmpty, "\(icon.rawValue) has no path data")
        }
    }

    func testEveryGlyphParsesInsideItsBox() {
        let box = CGRect(x: 0, y: 0, width: 24, height: 24)
        for icon in EdenIcon.allCases {
            let path = EdenIconShape(icon: icon).path(in: box)
            XCTAssertFalse(path.isEmpty, "\(icon.rawValue) parsed to an empty path")
            let bounds = path.boundingRect
            // Half a point of slack: a few Tabler outlines touch their edge.
            XCTAssertGreaterThanOrEqual(bounds.minX, -0.5, "\(icon.rawValue) spills left")
            XCTAssertGreaterThanOrEqual(bounds.minY, -0.5, "\(icon.rawValue) spills up")
            XCTAssertLessThanOrEqual(bounds.maxX, 24.5, "\(icon.rawValue) spills right")
            XCTAssertLessThanOrEqual(bounds.maxY, 24.5, "\(icon.rawValue) spills down")
            XCTAssertGreaterThan(bounds.width * bounds.height, 4,
                                 "\(icon.rawValue) collapsed to a dot")
        }
    }

    /// `chevron-down` is `M6 9l6 6l6 -6`, so its box is exactly 12 × 6 in the
    /// middle of the grid. If the parser drops a relative `l` this fails first.
    func testRelativeLinesAreRead() {
        let path = EdenIconShape(icon: .chevronDown).path(in: CGRect(x: 0, y: 0, width: 24, height: 24))
        XCTAssertEqual(path.boundingRect.minX, 6, accuracy: 0.01)
        XCTAssertEqual(path.boundingRect.minY, 9, accuracy: 0.01)
        XCTAssertEqual(path.boundingRect.width, 12, accuracy: 0.01)
        XCTAssertEqual(path.boundingRect.height, 6, accuracy: 0.01)
    }

    /// `M12 21a9 9 0 1 0 0 -18a9 9 0 0 0 0 18` is a circle of radius 9 drawn as
    /// two arcs — the only proof the arc conversion is right.
    func testArcsBecomeTheCircleTheyDescribe() {
        let path = EdenIconShape(icon: .circleChevronDown).path(in: CGRect(x: 0, y: 0, width: 24, height: 24))
        let bounds = path.boundingRect
        XCTAssertEqual(bounds.minX, 3, accuracy: 0.05)
        XCTAssertEqual(bounds.maxX, 21, accuracy: 0.05)
        XCTAssertEqual(bounds.minY, 3, accuracy: 0.05)
        XCTAssertEqual(bounds.maxY, 21, accuracy: 0.05)
    }

    /// Scaling is uniform, so a glyph in a 48 pt box is the 24-grid doubled.
    func testGlyphsScaleWithTheirBox() {
        let small = EdenIconShape(icon: .cube).path(in: CGRect(x: 0, y: 0, width: 24, height: 24))
        let large = EdenIconShape(icon: .cube).path(in: CGRect(x: 0, y: 0, width: 48, height: 48))
        XCTAssertEqual(large.boundingRect.width, small.boundingRect.width * 2, accuracy: 0.05)
    }

    /// Only these two are painted; every other glyph is a 1.7 stroke (R-80).
    func testOnlyPlayAndTiktokAreFilled() {
        let filled = EdenIcon.allCases.filter(\.isFilled)
        XCTAssertEqual(Set(filled), [.playerPlay, .brandTiktok])
        XCTAssertEqual(EdenIconShape.stroke, 1.7)
    }
}
