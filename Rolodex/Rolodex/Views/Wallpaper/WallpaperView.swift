import SwiftUI

/// Full-bleed lock-screen wallpaper rendered offscreen via ImageRenderer.
///
/// Lock-screen safe zones (iPhone 17 Pro, 393×852 pt logical):
///   • Clock + widgets fill roughly the top 53 % (~452 pt).
///   • Flashlight / Camera row sits at ~87 % (~741 pt).
/// Layout uses a fixed-height Color.clear top spacer so the QR block
/// lands in the clear band between those two zones regardless of how
/// ImageRenderer resolves Spacer() or ZStack alignment.
struct WallpaperView: View {
    let card: Card
    let size: CGSize

    var body: some View {
        let platform = card.platform
        let deepURL = platform.deepLink(handle: card.handle)
        // Large QR fills ~87 % of screen width so it's easy to scan.
        // Top spacer starts at 39 % — the clock renders on top of the
        // gradient (not the white card), so a slight overlap is fine and
        // matches the aesthetic in the inspiration image.
        let qrSize   = size.width * 0.76
        let scale    = size.width / 393.0

        ZStack {
            platform.background

            LinearGradient(
                colors: [Color.white.opacity(0.18), .clear],
                startPoint: .topTrailing, endPoint: .center
            )
            .blendMode(.overlay)
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                Color.clear.frame(height: size.height * 0.39)

                if let deepURL {
                    QRCodeView(url: deepURL, platform: platform, size: qrSize)
                        .padding(qrSize * 0.07)
                        .background(
                            RoundedRectangle(cornerRadius: qrSize * 0.10, style: .continuous)
                                .fill(Color.white)
                        )
                        .shadow(color: .black.opacity(0.28), radius: 28 * scale, x: 0, y: 14 * scale)
                }

                Color.clear.frame(height: 16 * scale)

                Text(card.displayHandle.uppercased())
                    .font(AppFont.platformHandle(platform, size: 32 * scale))
                    .kerning(2 * scale)
                    .foregroundStyle(platform.textColor)
                    .shadow(color: .black.opacity(0.25), radius: 8 * scale, y: 2 * scale)
                    .padding(.horizontal, 20 * scale)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)

                Text(platform.formatted(handle: card.handle))
                    .font(AppFont.mono(size: 10 * scale))
                    .kerning(1.6 * scale)
                    .textCase(.uppercase)
                    .foregroundStyle(platform.textColor.opacity(0.7))
                    .padding(.top, 8 * scale)
            }
            .frame(width: size.width, height: size.height, alignment: .top)
        }
        .frame(width: size.width, height: size.height)
        .clipped()
    }
}

#Preview {
    WallpaperView(card: Card.samples[0], size: CGSize(width: 393, height: 852))
        .frame(width: 393, height: 852)
}
