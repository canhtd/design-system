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

## Dark palette — measured from app.eden.so (2026-08-25)

Computed custom properties read off app.eden.so under `prefers-color-scheme: dark`
(`<html class="dark">`, body bg `#111`, body text `#D9DCD8`). Eden's app follows
the System with no in-app toggle — same model as this package. Where a role was
not measured, the executor derives it and says so in the doc comment.

| role | light (today) | dark | Eden variable |
|---|---|---|---|
| canvas | `#FAFAF8` | `#111111` | `--surface-canvas` |
| sidebar | `#F4F3EE` | `#171717` | `--surface-sidebar` |
| card | `#FFFFFF` | `#1C1C1C` | `--surface-card` |
| pane / main region | — | `#181818` | `--color-background-pane` (use for chat/board regions if a role needs it) |
| field / secondary fill | — | `#2A2A2A` | `--color-background-field` (chips, inputs, followUp surfaces) |
| menu / page | — | `#222222` | `--color-background-menu` (popover, cmdk) |
| textPrimary | `#272523` | `#D9DCD8` | `--color-text-dark-primary` |
| text, secondary (today `n500`) | `#737373` | `#919191` | `--color-text-dark-secondary` |
| text, tertiary (today `n400`) | `#A1A1A1` | derive between `#919191` and `#2F2F2F` (unmeasured) | — |
| icon, secondary | — | `#C3C3C3` | `--color-icon-dark-secondary` |
| hairline | `#E0E0E0` | `#2F2F2F` | `--color-border-subtle` |
| divider | — | white 10 % | `--color-divider` |
| primary (accent) | `#09321F` | `#73B490` | `--color-primary` / `--color-eden-accent` |
| primary80 (filled button bg) | `#224735` | `#395A4B` | `--color-button-primary-default-background` |
| primary5 (text on filled button) | `#EFF2EE` | `#EFF2EE` | `--color-button-primary-default-text` |
| olive | `#39624D` | `#73B490` | `--color-accent-olive` |
| primaryHover | `#375847` | derive from `#395A4B` lifted one step (unmeasured) | — |
| primaryTint | primary 9 % | `#73B490` at 15 % | `--color-background-primary-selected` |
| danger | as today | `#E5737A` | `--color-text-dark-error` |
| scrim, guideRail*, status*, chat*, followUp*, section hues, Band hues | as today | derive; every one legible on `#111`/`#1C1C1C` | accent set available: gooseberry `#D4A83A`, blueberry `#6E96B8`, acai `#9B8BB8`, strawberry `#C96A6A`, seed `#C9A68A`, stone `#A0A0A0`, vine `#5C8470` |

Contrast floor still applies: text on canvas and on card ≥ 4.5:1 in both Appearances.

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
