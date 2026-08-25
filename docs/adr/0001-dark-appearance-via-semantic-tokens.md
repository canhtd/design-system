# ADR 0001 — Dark Appearance is delivered through semantic tokens, not an inverted ramp

Date: 2026-08-25 · Status: accepted

## Context

The package was extracted from a light-only measurement of app.eden.so. Components
called the raw neutral ramp (`n900…n200`) and `Color.white` directly in ~16 places,
and nothing in the package responded to the System Appearance. VessaStudio locks
itself to light because of that (white-on-white text under dark).

## Decision

- Every colour a view uses is a **semantic token** with one value per Appearance.
- The neutral ramp stays a **palette**: light-only, used only to define semantic
  tokens and to display in the Token Gallery. Views never call it.
- Appearance is the **System's**; the package exposes no preference or toggle.
- Existing token names keep working as static `Color` values, so consumers
  (Principle, VessaStudio) change nothing at call sites.

## Alternatives rejected

- Inverting the ramp (`n900 ↔ n200`) — cheap, but wrong for hairlines, scrims,
  gradients and accents, and leaves views coupled to values instead of roles.
- A per-app Appearance preference — scope the apps can add later; not a token concern.

## Consequences

- Adding a colour now means naming its role and supplying two values.
- Tests assert tokens under both Appearances, not one hex.
- Dark values are initially derived from eden.so's marketing palette; if
  app.eden.so's dark palette is measured later, values change, names do not.
