import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

/// Branded QR code: colored circular modules, rounded finder patterns, center logo badge.
struct QRCodeView: View {
    let url: URL
    let platform: Platform
    var size: CGFloat = 240

    var body: some View {
        Canvas { ctx, canvasSize in
            guard let matrix = QRMatrixCache.shared.matrix(for: url.absoluteString) else { return }
            renderMatrix(ctx: &ctx, matrix: matrix, canvasSize: canvasSize)
        }
        .frame(width: size, height: size)
        .background(Color.white)
        .overlay(centerLogoBadge)
    }

    private var centerLogoBadge: some View {
        let logoSize = size * 0.18
        return PlatformLogo(platform: platform, size: logoSize, color: platform.qrColor)
    }

    private func renderMatrix(ctx: inout GraphicsContext, matrix: QRMatrix, canvasSize: CGSize) {
        let modules = matrix.count
        let margin = 2
        let totalModules = CGFloat(modules + margin * 2)
        let cell = min(canvasSize.width, canvasSize.height) / totalModules
        let dark = platform.qrColor
        let light = Color.white

        // background
        ctx.fill(
            Path(CGRect(origin: .zero, size: canvasSize)),
            with: .color(light)
        )

        // Knockout area for center logo — slightly larger than the logo footprint
        // so modules never peek out from under it. Safe for error-correction level H.
        let centerPad = Int((Double(modules) * 0.12).rounded(.up))
        let cMid = Double(modules) / 2.0

        func isFinder(_ r: Int, _ c: Int) -> Bool {
            (r < 7 && c < 7) || (r < 7 && c >= modules - 7) || (r >= modules - 7 && c < 7)
        }
        func isCenter(_ r: Int, _ c: Int) -> Bool {
            abs(Double(r) - cMid + 0.5) < Double(centerPad) &&
                abs(Double(c) - cMid + 0.5) < Double(centerPad)
        }

        // modules as dots
        for r in 0..<modules {
            for c in 0..<modules {
                guard matrix.isDark(r: r, c: c) else { continue }
                if isFinder(r, c) || isCenter(r, c) { continue }
                let x = (CGFloat(c + margin) + 0.5) * cell
                let y = (CGFloat(r + margin) + 0.5) * cell
                let radius = cell * 0.42
                let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                ctx.fill(Path(ellipseIn: rect), with: .color(dark))
            }
        }

        // finder patterns (three corner eyes) — rounded squares
        drawFinder(&ctx, at: (0, 0), cell: cell, margin: margin, dark: dark, light: light)
        drawFinder(&ctx, at: (0, modules - 7), cell: cell, margin: margin, dark: dark, light: light)
        drawFinder(&ctx, at: (modules - 7, 0), cell: cell, margin: margin, dark: dark, light: light)
    }

    private func drawFinder(_ ctx: inout GraphicsContext, at origin: (row: Int, col: Int), cell: CGFloat, margin: Int, dark: Color, light: Color) {
        let x = CGFloat(origin.col + margin) * cell
        let y = CGFloat(origin.row + margin) * cell
        let size7 = 7 * cell

        // outer rounded square (dark)
        let outer = CGRect(x: x, y: y, width: size7, height: size7)
        ctx.fill(
            Path(roundedRect: outer, cornerRadius: cell * 1.6, style: .continuous),
            with: .color(dark)
        )
        // inner rounded square (light)
        let midRect = CGRect(x: x + cell, y: y + cell, width: size7 - 2*cell, height: size7 - 2*cell)
        ctx.fill(
            Path(roundedRect: midRect, cornerRadius: cell * 1.1, style: .continuous),
            with: .color(light)
        )
        // center filled square (dark)
        let innerRect = CGRect(x: x + 2*cell, y: y + 2*cell, width: size7 - 4*cell, height: size7 - 4*cell)
        ctx.fill(
            Path(roundedRect: innerRect, cornerRadius: cell * 0.7, style: .continuous),
            with: .color(dark)
        )
    }
}

// MARK: - QR Matrix

/// 2D dark/light matrix from CoreImage's QR generator.
struct QRMatrix {
    let count: Int
    private let bits: [Bool]

    init?(url: String) {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(url.utf8)
        filter.correctionLevel = "H"
        guard let output = filter.outputImage else { return nil }
        let ctx = CIContext()
        let extent = output.extent
        let width = Int(extent.width)
        let height = Int(extent.height)
        guard width == height, width > 0 else { return nil }
        guard let cg = ctx.createCGImage(output, from: extent) else { return nil }

        var pixels = [UInt8](repeating: 0, count: width * height)
        let cs = CGColorSpaceCreateDeviceGray()
        guard let pixelCtx = CGContext(
            data: &pixels,
            width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width,
            space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else { return nil }
        pixelCtx.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

        // CoreImage flips Y relative to the raster; read back straight.
        var bits = [Bool](repeating: false, count: width * height)
        for y in 0..<height {
            for x in 0..<width {
                // dark pixels are low-value (black)
                bits[(height - 1 - y) * width + x] = pixels[y * width + x] < 128
            }
        }

        self.count = width
        self.bits = bits
    }

    func isDark(r: Int, c: Int) -> Bool {
        guard r >= 0, r < count, c >= 0, c < count else { return false }
        return bits[r * count + c]
    }
}

private final class QRMatrixCache {
    static let shared = QRMatrixCache()
    private var store: [String: QRMatrix] = [:]
    private let queue = DispatchQueue(label: "qr.cache", attributes: .concurrent)

    func matrix(for key: String) -> QRMatrix? {
        var existing: QRMatrix?
        queue.sync { existing = store[key] }
        if let existing { return existing }
        guard let fresh = QRMatrix(url: key) else { return nil }
        queue.async(flags: .barrier) { self.store[key] = fresh }
        return fresh
    }
}

#Preview {
    if let url = Platform.instagram.deepLink(handle: "rob.wan") {
        QRCodeView(url: url, platform: .instagram, size: 240)
            .padding()
    }
}
