import CoreGraphics
import Foundation

/// SVG's elliptical-arc command as cubic Béziers.
///
/// `A` is the one path command Core Graphics has no direct equivalent for when
/// the ellipse is rotated or non-circular, so it is converted the way the SVG
/// implementation notes (F.6.5) describe: endpoint parameters to centre
/// parameters, then one cubic per quarter turn or less.
enum EdenArc {
    struct Segment {
        let control1: CGPoint
        let control2: CGPoint
        let end: CGPoint
    }

    static func curves(from start: CGPoint, to end: CGPoint, radii: CGPoint,
                       rotation: CGFloat, largeArc: Bool, sweep: Bool) -> [Segment] {
        // Degenerate radii mean a straight line (F.6.2).
        var rx = abs(radii.x)
        var ry = abs(radii.y)
        guard rx > 0, ry > 0, start != end else {
            return [Segment(control1: start, control2: end, end: end)]
        }
        let phi = rotation * .pi / 180
        let cosPhi = cos(phi)
        let sinPhi = sin(phi)

        let dx = (start.x - end.x) / 2
        let dy = (start.y - end.y) / 2
        let x1 = cosPhi * dx + sinPhi * dy
        let y1 = -sinPhi * dx + cosPhi * dy

        // F.6.6 — grow radii that are too small to span the two endpoints.
        let lambda = (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry)
        if lambda > 1 {
            rx *= sqrt(lambda)
            ry *= sqrt(lambda)
        }

        let numerator = max(0, rx * rx * ry * ry - rx * rx * y1 * y1 - ry * ry * x1 * x1)
        let denominator = rx * rx * y1 * y1 + ry * ry * x1 * x1
        var factor = denominator == 0 ? 0 : sqrt(numerator / denominator)
        if largeArc == sweep { factor = -factor }

        let cx1 = factor * rx * y1 / ry
        let cy1 = -factor * ry * x1 / rx
        let cx = cosPhi * cx1 - sinPhi * cy1 + (start.x + end.x) / 2
        let cy = sinPhi * cx1 + cosPhi * cy1 + (start.y + end.y) / 2

        let theta = angle(1, 0, (x1 - cx1) / rx, (y1 - cy1) / ry)
        var delta = angle((x1 - cx1) / rx, (y1 - cy1) / ry, (-x1 - cx1) / rx, (-y1 - cy1) / ry)
        if !sweep, delta > 0 { delta -= 2 * .pi }
        if sweep, delta < 0 { delta += 2 * .pi }

        let count = max(1, Int(ceil(abs(delta) / (.pi / 2))))
        let step = delta / CGFloat(count)
        // The magic constant that makes a cubic follow a circular arc of `step`.
        let alpha = 4.0 / 3.0 * tan(step / 4)

        var segments: [Segment] = []
        var angleStart = theta
        for _ in 0..<count {
            let angleEnd = angleStart + step
            let p1 = point(cx, cy, rx, ry, cosPhi, sinPhi, angleStart)
            let p2 = point(cx, cy, rx, ry, cosPhi, sinPhi, angleEnd)
            let d1 = derivative(rx, ry, cosPhi, sinPhi, angleStart)
            let d2 = derivative(rx, ry, cosPhi, sinPhi, angleEnd)
            segments.append(Segment(
                control1: CGPoint(x: p1.x + alpha * d1.x, y: p1.y + alpha * d1.y),
                control2: CGPoint(x: p2.x - alpha * d2.x, y: p2.y - alpha * d2.y),
                end: p2))
            angleStart = angleEnd
        }
        return segments
    }

    private static func point(_ cx: CGFloat, _ cy: CGFloat, _ rx: CGFloat, _ ry: CGFloat,
                              _ cosPhi: CGFloat, _ sinPhi: CGFloat, _ t: CGFloat) -> CGPoint {
        let x = rx * cos(t)
        let y = ry * sin(t)
        return CGPoint(x: cosPhi * x - sinPhi * y + cx, y: sinPhi * x + cosPhi * y + cy)
    }

    private static func derivative(_ rx: CGFloat, _ ry: CGFloat,
                                   _ cosPhi: CGFloat, _ sinPhi: CGFloat, _ t: CGFloat) -> CGPoint {
        let x = -rx * sin(t)
        let y = ry * cos(t)
        return CGPoint(x: cosPhi * x - sinPhi * y, y: sinPhi * x + cosPhi * y)
    }

    /// The signed angle between two vectors, the way F.6.5.4 defines it.
    private static func angle(_ ux: CGFloat, _ uy: CGFloat,
                              _ vx: CGFloat, _ vy: CGFloat) -> CGFloat {
        let dot = ux * vx + uy * vy
        let length = sqrt(ux * ux + uy * uy) * sqrt(vx * vx + vy * vy)
        guard length > 0 else { return 0 }
        let clamped = min(1, max(-1, dot / length))
        let sign: CGFloat = (ux * vy - uy * vx) < 0 ? -1 : 1
        return sign * acos(clamped)
    }
}
