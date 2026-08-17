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
        XCTAssertEqual(EdenRadius.sm, 8)
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

    func testLibraryMetricsMatchDocs() {
        XCTAssertEqual(EdenMetric.libraryMaxWidth, 1640)
        XCTAssertEqual(EdenMetric.libraryPaddingH, 48)
        XCTAssertEqual(EdenMetric.pillHeight, 32)
        XCTAssertEqual(EdenMetric.searchFieldHeight, 50)
        XCTAssertEqual(EdenMetric.segmentedHeight, 30)
    }

    /// Not in the Eden docs — pinned against the extracted originals.
    func testModalMetricsMatchTheExtractedOriginals() {
        XCTAssertEqual(EdenMetric.modalWidth, 640)
        XCTAssertEqual(EdenMetric.modalTopInset, 118)
        XCTAssertEqual(EdenMetric.fieldHeight, 44)
        XCTAssertEqual(EdenMetric.modalButtonHeight, 35)
    }

}
