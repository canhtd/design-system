import DesignSystem
import SwiftUI
import XCTest

/// Geometry spot-checks. The radii and the sidebar/library numbers are
/// stated in `docs/design/eden-tokens.md` / `eden-components.md` in the
/// VessaStudio repo; the New Project modal was never measured on Eden, so
/// those values are pinned against VessaStudio's own EdenTokens.swift at
/// beb0f21 instead. Either way: fix the token, never the expectation.
final class EdenGeometryTests: XCTestCase {
    /// Eden overrides Tailwind: `lg` (18) is bigger than `xl`/`md` (12).
    func testRadiiMatchDocs() {
        XCTAssertEqual(EdenRadius.xs, 6)
        XCTAssertEqual(EdenRadius.mono, 5)
        XCTAssertEqual(EdenRadius.sm, 8)
        XCTAssertEqual(EdenRadius.childRow, 10)
        XCTAssertEqual(EdenRadius.md, 12)
        XCTAssertEqual(EdenRadius.card, 16)
        XCTAssertEqual(EdenRadius.lg, 18)
        XCTAssertEqual(EdenRadius.modal, 24)
        XCTAssertGreaterThan(EdenRadius.lg, EdenRadius.md)
    }

    func testSidebarMetricsMatchDocs() {
        XCTAssertEqual(EdenMetric.sidebarWidth, 260)
        XCTAssertEqual(EdenMetric.sidebarInset, 8)
        XCTAssertEqual(EdenMetric.sidebarColumn, 268)
        XCTAssertEqual(EdenMetric.sidebarContent, 234)
        XCTAssertEqual(EdenMetric.rowHeight, 30)
        XCTAssertEqual(EdenMetric.iconSlot, 20)
    }

    /// A child row is shorter than the nav row it hangs under, and the small
    /// monogram is smaller than the switcher's icon slot. If either inverts,
    /// the sidebar hierarchy stops reading.
    func testSidebarChildAndMonogramMetrics() {
        XCTAssertEqual(EdenMetric.childRowHeight, 28)
        XCTAssertEqual(EdenMetric.mono18, 18)
        XCTAssertLessThan(EdenMetric.childRowHeight, EdenMetric.rowHeight)
        XCTAssertLessThan(EdenMetric.mono18, EdenMetric.iconSlot)
        XCTAssertLessThan(EdenRadius.mono, EdenRadius.childRow)
    }

    func testLibraryMetricsMatchDocs() {
        XCTAssertEqual(EdenMetric.libraryMaxWidth, 1640)
        XCTAssertEqual(EdenMetric.libraryPaddingH, 48)
        XCTAssertEqual(EdenMetric.pillHeight, 32)
        XCTAssertEqual(EdenMetric.searchFieldHeight, 50)
        XCTAssertEqual(EdenMetric.segmentedHeight, 30)
    }

    /// Not in the Eden docs — pinned against the frozen M1 prototype
    /// (`docs/prototypes/m1-eden-clone.html`, `.modal` / `.scrim`).
    func testModalMetricsMatchTheFrozenPrototype() {
        XCTAssertEqual(EdenMetric.modalWidth, 680)
        XCTAssertEqual(EdenMetric.modalTopInset, 104)
        XCTAssertEqual(EdenMetric.fieldHeight, 44)
        XCTAssertEqual(EdenMetric.modalButtonHeight, 35)
    }

}
