import DesignSystem
import SwiftUI
import XCTest

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
