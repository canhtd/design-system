import AppKit
import DesignSystem
import SwiftUI

/// Thin host for `EdenTokenGallery` — `swift run TokenGallery`.
@main
struct TokenGalleryApp: App {
    init() {
        // The SwiftPM binary has no app bundle, so it starts as a background
        // process; without this the window never comes forward.
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup("Eden Token Gallery") {
            EdenTokenGallery()
                .frame(minWidth: 900, minHeight: 640)
        }
    }
}
