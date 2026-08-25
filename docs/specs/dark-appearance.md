# Spec — Dark Appearance for DesignSystem

Owner: Danny · 2026-08-25 · Vocabulary: `CONTEXT.md` · Decision: `docs/adr/0001`

## Goal

Every surface built from this package renders correctly under the macOS **dark**
Appearance, with no change at consumer call sites. Light rendering stays
pixel-identical to today.

## Non-goals

- No Appearance toggle or preference in the package.
- No changes in VessaStudio / Principle (their un-locking is follow-up work in
  their repos).
- No new font, radius or metric work.

## Behaviour

1. Each semantic token in `EdenColor` (and `EdenSignal`) resolves to a light or a
   dark value from the window's current Appearance, and re-resolves live when
   the System Appearance changes.
2. `EdenColor.<token>` remains a `static let` `Color` — usable without an
   environment, in modifiers, styles and previews exactly as today.
3. Views in `Sources/DesignSystem` use only semantic tokens: no `n900…n200`, no
   `Color.white` / `Color.black` / `.white` / `.black`, no literal hex. The
   ramp remains public for the Gallery.
4. `EdenPageGradient` and the shadow helpers in `EdenSurfaces` have a dark
   variant that reads as a wash, not as a stain.
5. The Token Gallery renders every token and control under both Appearances,
   and has a gallery-only switch (System / Light / Dark) for previewing.

## Dark palette — initial values

Derived from eden.so (marketing site, measured 2026-08-25). Replace values, not
names, if app.eden.so's dark palette is measured later.

| role | light (today) | dark |
|---|---|---|
| canvas | `#FAFAF8` | `#0A0A0A` |
| sidebar | `#F4F3EE` | `#141414` |
| card | `#FFFFFF` | `#1A1A1A` |
| textPrimary | `#272523` | `#F5F5F5` |
| text, secondary (today `n500`) | `#737373` | `#A3A3A3` |
| text, tertiary (today `n400`) | `#A1A1A1` | `#737373` |
| hairline | `#E0E0E0` | white 9 % |
| stronger edge (today `n300`/`n200`) | as today | white 16 % / 6 % |
| primary / primary80 / olive / primaryHover | as today | lifted so text on them and they on canvas both pass WCAG AA (≥ 4.5:1); keep the green hue |
| scrim, guideRail*, status*, danger, chat*, followUp*, section hues, Band hues | as today | executor derives; every one must be legible on dark canvas and card |

The executor names the new semantic roles from the actual call sites (expected:
`textSecondary`, `textTertiary`, an edge/border step or two, an inverse
foreground for filled buttons). Keep names in the existing style.

## Verification (done means all of these)

- `swift test` green, with colour tests asserting both Appearances.
- A test fails if a view file in `Sources/DesignSystem` references the ramp or
  `Color.white/black` (except `EdenColor.swift`).
- Light rendering unchanged: the gallery render test's light output matches
  before/after.
- Two gallery screenshots (light, dark) attached to the ticket; text contrast on
  canvas and card ≥ 4.5:1 in both.
- README gains an "Appearance" paragraph; no "dark mode" wording.
