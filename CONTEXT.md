# CONTEXT — DesignSystem glossary

Vocabulary for the `DesignSystem` package. Glossary only: no implementation detail.

## Appearance

The window's light-or-dark rendering, as macOS reports it. Values: **light**, **dark**.
The package follows the System Appearance; it never chooses one itself. Use
"Appearance", not "theme" or "mode", in code, docs and issues.

## Semantic token

A colour named for its *role* (`canvas`, `textPrimary`, `hairline`) rather than its
value. Every semantic token has one value per Appearance. Views only ever use
semantic tokens.

## Palette token

A colour named for its *value* (the neutral ramp `n900…n200`). Palette tokens are
raw material for semantic tokens and the Token Gallery; views never use them.

## Token Gallery

The `TokenGallery` executable that renders every token and control in a window. A
development tool, not a product surface.
