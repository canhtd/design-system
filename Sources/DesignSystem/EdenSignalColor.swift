import SwiftUI

/// The two coloured ladders Eden uses on an Item card: how far a post beat its
/// author's usual reach (`Outlier`), and where it sits in its niche
/// (`Percentile`). Both are drawn as a pill whose fill is the hue at 8 % and
/// whose border is the same hue at 25 % (`docs/design/eden-tokens.md` §2).
///
/// Each rung is a pair. The light hues are measured; the dark ones are lifted
/// so that a rung still carries its own label — every one clears 4.5:1 on both
/// `canvas` and `card` under dark, where the measured light hues sat as low as
/// 1.4:1. Two come from the accent set in `docs/specs/dark-appearance.md`
/// (blueberry, gooseberry); the rest are derived and marked below.
public enum EdenSignal {
    /// Views ask for a band, never for a hex.
    public struct Band: Sendable, Equatable {
        public let hue: Color
        public var fill: Color { hue.opacity(0.08) }
        public var border: Color { hue.opacity(0.25) }
    }

    /// `< 2×` is the one rung drawn in neutral ink rather than a hue: it is the
    /// absence of a signal, so it must not read as one.
    public static let outlierBase = Band(hue: EdenColor.signalNone)

    /// An Item's views over its author's followers.
    public static func outlier(_ multiple: Double) -> Band {
        switch multiple {
        case ..<2: outlierBase
        case ..<3: Band(hue: blue)
        case ..<5: Band(hue: green)
        case ..<10: Band(hue: amber)
        case ..<50: Band(hue: orange)
        default: Band(hue: red)
        }
    }

    /// Where an Item ranks in its niche, as a whole percentile. Below 91 there
    /// is no pill at all.
    public static func percentile(_ rank: Int) -> Band? {
        switch rank {
        case 91...95: Band(hue: violet)
        case 96...99: Band(hue: magenta)
        case 100...: Band(hue: red)
        default: nil
        }
    }

    // MARK: The rungs

    /// `2–3×`. Dark is the accent set's blueberry.
    static let blue = EdenColor.dual(light: 0x0069A8, dark: 0x6E96B8)
    /// `3–5×`. Dark derived — the measured green is 1.5:1 on a dark card.
    static let green = EdenColor.dual(light: 0x007A55, dark: 0x55C79A)
    /// `5–10×`. Dark is the accent set's gooseberry.
    static let amber = EdenColor.dual(light: 0xE17100, dark: 0xD4A83A)
    /// `10–50×`. Dark derived: the accent set's seed is too quiet for a rung
    /// this high, so the measured orange is lifted instead.
    static let orange = EdenColor.dual(light: 0xF54A00, dark: 0xFF8A4C)
    /// The top of both ladders — `≥ 50×` and `P100`. Dark derived: strawberry
    /// reads as a warning, and this rung is a celebration.
    static let red = EdenColor.dual(light: 0xEC003F, dark: 0xFF6B81)
    /// `P91–95`. Dark derived; the accent set's acai loses the violet.
    static let violet = EdenColor.dual(light: 0x7008E7, dark: 0xA78BFA)
    /// `P96–99`. Dark derived from the measured magenta.
    static let magenta = EdenColor.dual(light: 0xA800B7, dark: 0xD07BDF)
}

extension EdenSignal.Band {
    /// `< 2×`'s border is `signalNoneBorder`, not the shared 25 % derivation.
    public var outlierBaseBorder: Color { EdenColor.signalNoneBorder }
}
