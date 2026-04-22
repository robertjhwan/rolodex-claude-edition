import SwiftUI

/// A single branded card, full-size (480pt tall in the stack).
struct BrandCardView: View {
    let card: Card
    var width: CGFloat = 340
    var height: CGFloat = 480
    var qrSize: CGFloat = 210

    var body: some View {
        let platform = card.platform
        let url = platform.deepLink(handle: card.handle)

        ZStack(alignment: .top) {
            platform.background

            // top-right highlight glow
            LinearGradient(
                colors: [Color.white.opacity(0.18), .clear],
                startPoint: .topTrailing, endPoint: .center
            )
            .blendMode(.overlay)
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                header(platform: platform)
                    .padding(.horizontal, 22)
                    .padding(.top, 22)

                Spacer(minLength: 0)

                if let url {
                    QRCodeView(url: url, platform: platform, size: qrSize)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.25), radius: 15, y: 10)
                        )
                }

                Spacer(minLength: 0)

                footer(platform: platform)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.5), radius: 30, y: 30)
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        }
    }

    private func header(platform: Platform) -> some View {
        HStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 34, height: 34)
                    .overlay {
                        PlatformLogo(platform: platform, size: 20, color: platform.textColor)
                    }
                Text(platform.name)
                    .font(.system(size: 14, weight: .semibold))
                    .kerning(-0.1)
                    .foregroundStyle(platform.textColor.opacity(0.95))
            }
            Spacer()
            Text("#\(idTag)")
                .font(AppFont.mono(size: 10))
                .kerning(0.5)
                .foregroundStyle(platform.textColor.opacity(0.6))
                .textCase(.uppercase)
        }
    }

    private func footer(platform: Platform) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(card.displayHandle)
                .font(AppFont.platformHandle(platform, size: 26))
                .kerning(-0.5)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(platform.textColor)
            Text(platform.formatted(handle: card.handle))
                .font(AppFont.mono(size: 10))
                .kerning(1.2)
                .textCase(.uppercase)
                .foregroundStyle(platform.textColor.opacity(0.65))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var idTag: String {
        let hash = abs(card.id.uuidString.hashValue) % 9999
        return String(format: "%04d", hash)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            ForEach(Card.samples.prefix(3)) { card in
                BrandCardView(card: card)
            }
        }
        .padding()
    }
    .background(Color.black)
}
