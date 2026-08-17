import DesignSystem
import SwiftUI
import XCTest

/// Geometry spot-checks against `docs/design/eden-tokens.md` and
/// `eden-components.md` in the VessaStudio repo.
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

    func testLibraryAndModalMetricsMatchDocs() {
        XCTAssertEqual(EdenMetric.libraryMaxWidth, 1640)
        XCTAssertEqual(EdenMetric.libraryPaddingH, 48)
        XCTAssertEqual(EdenMetric.pillHeight, 32)
        XCTAssertEqual(EdenMetric.searchFieldHeight, 50)
        XCTAssertEqual(EdenMetric.segmentedHeight, 30)
        XCTAssertEqual(EdenMetric.modalWidth, 640)
        XCTAssertEqual(EdenMetric.modalButtonHeight, 35)
    }

    func testFontUsesSystemFaceAtEdenSizes() {
        XCTAssertEqual(EdenFont.ui(13.5, .medium), .system(size: 13.5, weight: .medium))
        XCTAssertEqual(EdenFont.ui(12), .system(size: 12, weight: .regular))
    }
}

/// Compile-time proof that the controls and components are part of the public
/// API — a consumer can build every one of them from outside the module.
@MainActor
final class EdenPublicAPITests: XCTestCase {
    func testControlsAreConstructableFromOutsideTheModule() {
        _ = Button("New") {}.buttonStyle(EdenPillButtonStyle())
        _ = Button("Cancel") {}.buttonStyle(EdenGhostButtonStyle())
        _ = Button("Create") {}.buttonStyle(EdenPrimaryButtonStyle())
    }

    func testComponentsAreConstructableFromOutsideTheModule() {
        _ = EdenKbd(keys: ["⌘", "K"])
        _ = EdenMonogram(text: "Principle")
        _ = EdenFilterChip(title: "All", symbol: "square.grid.2x2", isActive: true)
        _ = EdenSegmented(titles: ["Grid", "List"], selected: 0)
        _ = EdenViewModes(symbols: ["square.grid.2x2"], selected: 0)
        _ = EdenPageGradient()
    }

    func testViewModifiersAreVisibleFromOutsideTheModule() {
        _ = Color.clear.edenPanelShadow()
        _ = Color.clear.edenFloatShadow()
        _ = Color.clear.edenBorder(EdenColor.hairline, radius: EdenRadius.card)
    }
}
