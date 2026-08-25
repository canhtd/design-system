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
        _ = Color.clear.edenCardShadow(EdenCard.shadowRest)
        _ = Color.clear.edenCardShadow(EdenCard.shadowFocused)
        _ = Text("All items").edenText(EdenType.pageTitle)
    }

    /// The roles v0.3.1 adds. A consumer reaching one of these is the whole
    /// point of the release — VessaStudio's 46 near-miss call sites move onto
    /// them, so a name that is not public is a name that changes nothing.
    func testTheStudioRolesAreReachableFromOutsideTheModule() {
        let roles: [Color] = [
            EdenColor.ruleFaint, EdenColor.inputFieldFill, EdenColor.inputFieldBorder,
            EdenColor.composerFill, EdenColor.cardHoverBorder, EdenColor.chipHoverBorder,
            EdenColor.plateFill, EdenColor.sheetFooterFill, EdenColor.onPrimaryInk
        ]
        XCTAssertEqual(roles.count, 9)
    }

    /// And the card's own namespace: its colours, its geometry, its faces and
    /// the two lifts.
    func testTheCardTokensAreReachableFromOutsideTheModule() {
        _ = EdenCard.borderWarm
        _ = EdenCard.ink
        _ = EdenCard.hint
        _ = EdenCard.shadowLayer(0.024)
        _ = [EdenCard.radius, EdenCard.paddingTop, EdenCard.paddingH,
             EdenCard.paddingBottom, EdenCard.composerPaddingBottom]
        _ = [EdenCard.text, EdenCard.editorText, EdenCard.hintText]
        _ = [EdenCard.shadowRest, EdenCard.shadowFocused].map(\.layers)
    }
}
