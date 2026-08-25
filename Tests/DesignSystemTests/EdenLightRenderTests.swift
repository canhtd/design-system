import AppKit
import DesignSystem
import DesignSystemGallery
import SwiftUI
import XCTest

/// The light Appearance is the measured one: it shipped, two apps are built on
/// it, and every step towards dark has to leave it exactly where it was. So
/// the render is pinned to a picture in `Goldens/`, not to a description of
/// one — swapping a spelled colour for a semantic token must move nothing.
///
/// **Why the comparison has a tolerance.** `ImageRenderer` does not rasterise
/// glyphs bit-identically from run to run: measured over five renders of the
/// gallery, an occasional run differs on 0.03 % of the bytes by at most 2
/// levels — antialiasing along letter edges, nothing else. So the rule is: no
/// byte may move by more than `maxDelta`, and no more than `maxDrift` of them
/// may move at all. Mixing up two ink roles moves bytes by 15 levels or more
/// and fails on the first clause; dropping a border or a fill fails on the
/// second. The exact values behind each role are pinned separately, and
/// exactly, by `EdenSemanticTokenTests`.
///
/// **Re-capturing.** Delete the PNG and re-run: the test writes the baseline
/// and fails, so a golden is never taken silently. Do that only for a change
/// that is *meant* to move light pixels — never to make this test go away.
@MainActor
final class EdenLightRenderTests: XCTestCase {
    /// No byte of a pixel may move further than this.
    private static let maxDelta = 4
    /// And no more than this share of the bytes may move at all.
    private static let maxDrift = 0.005

    /// Everything the Token Gallery draws: the controls, the components, the
    /// surfaces and the page wash, on one page.
    func testGalleryRendersTheSameLightPixels() throws {
        try assertRenderMatchesGolden(named: "gallery",
                                      content: EdenTokenGallery().content.frame(width: 1100))
    }

    /// The call sites the gallery does not put on the page: the popover
    /// surface, the pane border, the destructive button, the signal ladders.
    func testUngalleriedCallSitesRenderTheSameLightPixels() throws {
        try assertRenderMatchesGolden(named: "call-sites", content: LightCallSites())
    }

    /// `EdenViewModes` is deprecated but still drawn by whoever has not moved
    /// to `EdenSegmented`, so its pixels are pinned too. The test is itself
    /// deprecated so that drawing the control here raises no warning.
    @available(*, deprecated, message: "pins the deprecated EdenViewModes")
    func testDeprecatedViewModesRendersTheSameLightPixels() throws {
        try assertRenderMatchesGolden(named: "view-modes", content: DeprecatedViewModesSample())
    }

    // MARK: Golden plumbing

    private func assertRenderMatchesGolden<Content: View>(
        named name: String, content: Content,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        let renderer = ImageRenderer(content: content)
        let rendered = try XCTUnwrap(renderer.cgImage, "\(name) produced no image",
                                     file: file, line: line)
        let url = Self.goldenURL(name)

        guard let data = try? Data(contentsOf: url),
              let golden = NSBitmapImageRep(data: data)?.cgImage else {
            try Self.write(rendered, to: url)
            XCTFail("No light baseline for \"\(name)\" — captured \(url.lastPathComponent). "
                    + "Re-run to compare against it.", file: file, line: line)
            return
        }

        XCTAssertEqual(rendered.width, golden.width, "\(name) changed width", file: file, line: line)
        XCTAssertEqual(rendered.height, golden.height, "\(name) changed height", file: file, line: line)
        guard rendered.width == golden.width, rendered.height == golden.height else { return }

        let new = try bytes(of: rendered), old = try bytes(of: golden)
        var moved = 0, worst = 0
        for index in 0..<new.count where new[index] != old[index] {
            moved += 1
            worst = max(worst, abs(Int(new[index]) - Int(old[index])))
        }
        let drift = Double(moved) / Double(new.count)
        XCTAssertLessThanOrEqual(worst, Self.maxDelta, """
            The light render of "\(name)" changed colour: a byte moved \(worst) levels \
            (\(moved) bytes, \(String(format: "%.4f", drift * 100)) % of the image). A semantic \
            token must resolve to exactly the value its call site spelled before.
            """, file: file, line: line)
        XCTAssertLessThanOrEqual(drift, Self.maxDrift, """
            The light render of "\(name)" moved over \(String(format: "%.4f", drift * 100)) % of \
            its bytes — too much of the picture for glyph antialiasing to explain.
            """, file: file, line: line)
    }

    /// Both pictures are redrawn into one known buffer layout, so what is
    /// compared is colour and never how a `CGImage` happened to be laid out.
    private func bytes(of image: CGImage) throws -> [UInt8] {
        let width = image.width, height = image.height
        var buffer = [UInt8](repeating: 0, count: width * height * 4)
        let context = try XCTUnwrap(CGContext(
            data: &buffer, width: width, height: height, bitsPerComponent: 8,
            bytesPerRow: width * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), "could not make an sRGB context")
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return buffer
    }

    private static func goldenURL(_ name: String) -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Goldens/\(name)-light.png")
    }

    private static func write(_ image: CGImage, to url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        let representation = NSBitmapImageRep(cgImage: image)
        let png = try XCTUnwrap(representation.representation(using: .png, properties: [:]))
        try png.write(to: url)
    }
}

/// The controls and surfaces the Token Gallery does not draw.
private struct LightCallSites: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EdenPopover(width: 280) {
                EdenPopoverHeader("Recently deleted") { EdenKbd(keys: ["⌘", "K"], tone: .quiet) }
            }
            Button("Delete") {}.buttonStyle(EdenDangerButtonStyle())
            Button("Delete") {}.buttonStyle(EdenDangerButtonStyle()).disabled(true)
            Color.clear.frame(width: 220, height: 60)
                .background(EdenColor.card)
                .edenPaneSurface()
            HStack(spacing: 8) {
                ForEach([1.0, 2.5, 4, 9, 20, 91], id: \.self) { multiple in
                    band(EdenSignal.outlier(multiple),
                         label: String(format: "%g×", multiple),
                         border: multiple < 2 ? EdenSignal.outlier(multiple).outlierBaseBorder : nil)
                }
            }
            HStack(spacing: 8) {
                ForEach([93, 97, 100], id: \.self) { rank in
                    if let pill = EdenSignal.percentile(rank) {
                        band(pill, label: "P\(rank)", border: nil)
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 420, alignment: .leading)
        .background(EdenColor.canvas)
    }

    private func band(_ pill: EdenSignal.Band, label: String, border: Color?) -> some View {
        Text(label)
            .edenText(EdenType.chip)
            .foregroundStyle(pill.hue)
            .padding(.horizontal, 8)
            .frame(height: EdenMetric.usagePillHeight)
            .background(pill.fill, in: .capsule)
            .overlay(Capsule().strokeBorder(border ?? pill.border))
    }
}

@available(*, deprecated, message: "pins the deprecated EdenViewModes")
private struct DeprecatedViewModesSample: View {
    var body: some View {
        EdenViewModes(symbols: ["square.grid.2x2", "list.bullet", "chart.xyaxis.line"],
                      selected: 1)
            .padding(20)
            .background(EdenColor.canvas)
    }
}
