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
        _ = Button("Pull now") {}.buttonStyle(EdenSmallPrimaryButtonStyle())
        _ = Button("Edit hashtags") {}.buttonStyle(EdenSmallPillButtonStyle())
    }

    func testComponentsAreConstructableFromOutsideTheModule() {
        _ = EdenKbd(keys: ["⌘", "K"])
        _ = EdenMonogram(text: "Principle")
        _ = EdenMonogram(text: "Vessa", size: .mono18)
        _ = EdenMonogram(text: "Vessa", size: .mono20)
        _ = EdenFilterChip(title: "All", icon: .layoutGrid, isActive: true)
        _ = EdenSegmented(titles: ["Grid", "List"], selected: 0)
        _ = EdenPageGradient()
        _ = EdenIconView(.sparkles, size: EdenIconSize.pageMark)
        _ = EdenPopover(width: 336) { EdenPopoverHeader("Daily pull") }
    }

    func testViewModifiersAreVisibleFromOutsideTheModule() {
        _ = Color.clear.edenPanelShadow()
        _ = Color.clear.edenFloatShadow()
        _ = Color.clear.edenBorder(EdenColor.hairline, radius: EdenRadius.card)
        _ = Color.clear.edenPaneSurface()
        _ = Text("All items").edenText(EdenType.pageTitle)
    }
}
