# design-system

Shared Eden-based design tokens and SwiftUI controls for Danny's Mac apps
(Principle, VessaStudio). SwiftPM library `DesignSystem`, macOS 14+, Swift 6.

**Source of truth:** `docs/design/eden-tokens.md` and `eden-components.md` in
the VessaStudio repo — computed styles measured off `app.eden.so`, one CSS px =
one point. This package is an extraction of those docs, not a reinterpretation:
token names and values are unchanged, and `swift test` spot-checks them. Where
a value has no doc behind it (the New Project modal; the page-gradient washes)
the code says so.

**The rule:** change a token here, never per app. An app that needs a new value
adds it to this package first, so the next screen in the next app reuses it.

**Adding the dependency:** `.package(url: "https://github.com/canhtd/design-system.git", branch: "main")`,
then `.product(name: "DesignSystem", package: "design-system")` — or *File ▸ Add
Package Dependencies* in Xcode.

**API:** `EdenColor`, `EdenFont`, `EdenRadius`, `EdenMetric`, `EdenPageGradient`,
the `eden*` view modifiers, three button styles, five components.
`swift run TokenGallery` renders every one of them in a window.

**Open decision — the font:** Eden ships Geist; this package uses the system
face (SF Pro) at Eden's px sizes (VessaStudio spec decision D3). Whether to
bundle Geist is still open; if it lands, it lands here, once, for both apps.
