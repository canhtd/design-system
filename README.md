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

**Appearance:** every semantic token carries two values — one for the light
Appearance, one for the dark — and resolves whichever the window is currently
drawing in, re-resolving on its own when the System changes. Nothing at a call
site changes: `EdenColor.canvas` is still a `static let Color`, usable in a
modifier, a style or a preview. The package follows the System Appearance and
never chooses one itself, so it exposes no toggle and no preference; an app
that wants to offer one owns that decision. The neutral ramp (`n900…n200`) is
the exception on purpose — it is a light-only palette that semantic tokens are
cut from, not a set of roles, so it does not follow the Appearance. Dark values
are measured off app.eden.so; where a role had no measurement its doc comment
says it is derived. `swift run TokenGallery` has a System / Light / Dark switch
for previewing both.

**API:** `EdenColor`, `EdenFont`, `EdenRadius`, `EdenMetric`, `EdenPageGradient`,
the `eden*` view modifiers, three button styles, five components.
`swift run TokenGallery` renders every one of them in a window.

**Open decision — the font:** Eden ships Geist; this package uses the system
face (SF Pro) at Eden's px sizes (VessaStudio spec decision D3). Whether to
bundle Geist is still open; if it lands, it lands here, once, for both apps.
