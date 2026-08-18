import SwiftUI

/// The two coloured ladders Eden uses on an Item card: how far a post beat its
/// author's usual reach (`Outlier`), and where it sits in its niche
/// (`Percentile`). Both are drawn as a pill whose fill is the hue at 8 % and
/// whose border is the same hue at 25 % (`docs/design/eden-tokens.md` §2).
public enum EdenSignal {
    /// Views ask for a band, never for a hex.
    public struct Band: Sendable, Equatable {
        public let hue: Color
        public var fill: Color { hue.opacity(0.08) }
        public var border: Color { hue.opacity(0.25) }
    }

    /// `< 2×` is the one rung drawn in neutral ink rather than a hue: it is the
    /// absence of a signal, so it must not read as one.
    public static let outlierBase = Band(hue: EdenColor.black(55))

    /// An Item's views over its author's followers.
    public static func outlier(_ multiple: Double) -> Band {
        switch multiple {
        case ..<2: outlierBase
        case ..<3: Band(hue: EdenColor.hex(0x0069A8))
        case ..<5: Band(hue: EdenColor.hex(0x007A55))
        case ..<10: Band(hue: EdenColor.hex(0xE17100))
        case ..<50: Band(hue: EdenColor.hex(0xF54A00))
        default: Band(hue: EdenColor.hex(0xEC003F))
        }
    }

    /// Where an Item ranks in its niche, as a whole percentile. Below 91 there
    /// is no pill at all.
    public static func percentile(_ rank: Int) -> Band? {
        switch rank {
        case 91...95: Band(hue: EdenColor.hex(0x7008E7))
        case 96...99: Band(hue: EdenColor.hex(0xA800B7))
        case 100...: Band(hue: EdenColor.hex(0xEC003F))
        default: nil
        }
    }
}

extension EdenSignal.Band {
    /// `< 2×`'s border is black 10 %, not the shared 25 % derivation.
    public var outlierBaseBorder: Color { EdenColor.black(10) }
}
