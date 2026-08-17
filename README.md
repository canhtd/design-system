# design-system

Shared Eden-based design tokens and SwiftUI controls for Danny's Mac apps
(Principle, VessaStudio). SwiftPM library `DesignSystem`, macOS 14+, Swift 6.

**Source of truth for the values:** `docs/design/eden-tokens.md` and
`docs/design/eden-components.md` in the VessaStudio repo — computed styles
measured off `app.eden.so` at 1440 × 754 CSS px, DPR 2, one CSS px = one point.
This package is an extraction of those docs, not a reinterpretation: names and
values are identical, and `swift test` spot-checks them (`#09321f`, `#fafaf8`,
`#f4f3ee`, the radius scale, the sidebar geometry).

**The rule:** change a token here, never per app. An app that needs a new value
adds it to this package first, so the next screen in the next app reuses it.

## Adding the dependency

```swift
.package(url: "https://github.com/canhtd/design-system.git", branch: "main")
```

…then add `.product(name: "DesignSystem", package: "design-system")` to the
target, or add the repo via *File ▸ Add Package Dependencies* in Xcode.

## API

`EdenColor` (surfaces, neutral ramp, accent, `black(_:)`/`white(_:)` alphas,
`hex(_:)`) · `EdenFont.ui(_:_:)` · `EdenRadius` · `EdenMetric` ·
`EdenPageGradient` · `View.edenPanelShadow()` / `edenFloatShadow(opacity:)` /
`edenBorder(_:radius:width:)` · `EdenPillButtonStyle`, `EdenGhostButtonStyle`,
`EdenPrimaryButtonStyle` · `EdenKbd`, `EdenMonogram`, `EdenFilterChip`,
`EdenSegmented`, `EdenViewModes`.

`swift run TokenGallery` renders every colour, type style, radius, metric and
control in one window for eyeballing.

## Open decision — the font

Eden ships **Geist**; this package uses the system face (SF Pro) at Eden's px
sizes (VessaStudio spec decision D3). Whether to bundle Geist is still open; if
it lands, it lands here as `EdenFont`, once, for both apps.
