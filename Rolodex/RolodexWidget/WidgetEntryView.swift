import WidgetKit
import SwiftUI

// MARK: - Dispatcher

struct WidgetEntryView: View {
    let entry: RolodexEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:          SmallWidget(card: entry.card)
        case .systemMedium:         MediumWidget(card: entry.card)
        case .systemLarge:          LargeWidget(card: entry.card)
        case .accessoryCircular:    AccessoryCircularWidget(card: entry.card)
        case .accessoryRectangular: AccessoryRectangularWidget(card: entry.card)
        default:                    SmallWidget(card: entry.card)
        }
    }
}

// MARK: - Shared helpers

/// Rounded badge with the platform logo — mirrors BrandCardView's header icon.
private struct PlatformBadge: View {
    let platform: Platform
    var size: CGFloat = 32

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
            .fill(Color.white.opacity(0.22))
            .frame(width: size, height: size)
            .overlay {
                PlatformLogo(platform: platform, size: size * 0.55, color: platform.textColor)
            }
    }
}

/// The top-right highlight glow used on every branded surface.
private struct HighlightOverlay: View {
    var body: some View {
        LinearGradient(
            colors: [Color.white.opacity(0.14), .clear],
            startPoint: .topTrailing, endPoint: .center
        )
        .blendMode(.overlay)
        .allowsHitTesting(false)
    }
}

/// Empty-state when no cards exist yet.
private struct NoCardPlaceholder: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(.white.opacity(0.35))
            Text("Open Rolodex\nto add a card")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .kerning(0.5)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.35))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - systemSmall

private struct SmallWidget: View {
    let card: Card?

    var body: some View {
        ZStack(alignment: .topLeading) {
            HighlightOverlay()

            if let card {
                VStack(alignment: .leading, spacing: 0) {
                    PlatformBadge(platform: card.platform, size: 30)

                    Spacer(minLength: 0)

                    Text(card.displayHandle)
                        .font(AppFont.platformHandle(card.platform, size: 17))
                        .lineLimit(2)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(card.platform.textColor)

                    Text(card.platform.name.uppercased())
                        .font(.system(size: 8.5, weight: .medium, design: .monospaced))
                        .kerning(1.5)
                        .foregroundStyle(card.platform.textColor.opacity(0.6))
                        .padding(.top, 3)

                    HStack(spacing: 3) {
                        Image(systemName: "viewfinder")
                            .font(.system(size: 8, weight: .semibold))
                        Text("\(card.scans) scans")
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                    }
                    .foregroundStyle(card.platform.textColor.opacity(0.45))
                    .padding(.top, 4)
                }
                .padding(14)
            } else {
                NoCardPlaceholder()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            if let card {
                card.platform.background
            } else {
                Color.black
            }
        }
    }
}

// MARK: - systemMedium

private struct MediumWidget: View {
    let card: Card?

    var body: some View {
        ZStack {
            HighlightOverlay()

            if let card {
                let platform = card.platform
                let url      = platform.deepLink(handle: card.handle)

                HStack(spacing: 0) {
                    // Left column: identity
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 7) {
                            PlatformBadge(platform: platform, size: 28)
                            Text(platform.name)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(platform.textColor.opacity(0.8))
                        }

                        Spacer(minLength: 0)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(card.displayHandle)
                                .font(AppFont.platformHandle(platform, size: 20))
                                .kerning(-0.3)
                                .lineLimit(2)
                                .minimumScaleFactor(0.65)
                                .foregroundStyle(platform.textColor)

                            Text(platform.formatted(handle: card.handle))
                                .font(.system(size: 7.5, weight: .medium, design: .monospaced))
                                .kerning(0.7)
                                .foregroundStyle(platform.textColor.opacity(0.55))
                                .lineLimit(1)

                            HStack(spacing: 3) {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 7.5, weight: .semibold))
                                Text("\(card.scans) scans")
                                    .font(.system(size: 7.5, weight: .medium, design: .monospaced))
                            }
                            .foregroundStyle(platform.textColor.opacity(0.45))
                            .padding(.top, 2)
                        }
                    }
                    .padding(14)
                    .frame(maxHeight: .infinity, alignment: .leading)

                    // Right column: QR code
                    if let url {
                        QRCodeView(url: url, platform: platform, size: 108)
                            .padding(9)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
                            )
                            .padding(.trailing, 14)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                NoCardPlaceholder()
            }
        }
        .containerBackground(for: .widget) {
            if let card {
                card.platform.background
            } else {
                Color.black
            }
        }
    }
}

// MARK: - systemLarge

private struct LargeWidget: View {
    let card: Card?

    var body: some View {
        ZStack {
            HighlightOverlay()

            if let card {
                let platform = card.platform
                let url      = platform.deepLink(handle: card.handle)

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        HStack(spacing: 9) {
                            PlatformBadge(platform: platform, size: 32)
                            Text(platform.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(platform.textColor.opacity(0.9))
                        }
                        Spacer()
                        Text("SCAN ME")
                            .font(.system(size: 7.5, weight: .medium, design: .monospaced))
                            .kerning(2.0)
                            .foregroundStyle(platform.textColor.opacity(0.5))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    Spacer(minLength: 0)

                    // QR code centrepiece
                    if let url {
                        QRCodeView(url: url, platform: platform, size: 192)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.22), radius: 18, y: 10)
                            )
                    }

                    Spacer(minLength: 0)

                    // Footer
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.displayHandle)
                            .font(AppFont.platformHandle(platform, size: 28))
                            .kerning(-0.5)
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)
                            .foregroundStyle(platform.textColor)

                        Text(platform.formatted(handle: card.handle).uppercased())
                            .font(.system(size: 7.5, weight: .medium, design: .monospaced))
                            .kerning(1.4)
                            .foregroundStyle(platform.textColor.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                NoCardPlaceholder()
            }
        }
        .containerBackground(for: .widget) {
            if let card {
                card.platform.background
            } else {
                Color.black
            }
        }
    }
}

// MARK: - accessoryCircular (lock screen)

private struct AccessoryCircularWidget: View {
    let card: Card?
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        ZStack {
            if let card {
                if renderingMode == .fullColor {
                    card.platform.solidColor
                        .clipShape(Circle())
                }
                PlatformLogo(
                    platform: card.platform,
                    size: 22,
                    color: renderingMode == .fullColor ? card.platform.textColor : .primary
                )
            } else {
                Image(systemName: "rectangle.stack")
                    .font(.system(size: 18, weight: .light))
            }
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

// MARK: - accessoryRectangular (lock screen)

private struct AccessoryRectangularWidget: View {
    let card: Card?

    var body: some View {
        HStack(spacing: 8) {
            if let card {
                PlatformLogo(platform: card.platform, size: 20, color: .primary)
                    .frame(width: 22, height: 22)

                VStack(alignment: .leading, spacing: 1) {
                    Text(card.displayHandle)
                        .font(.system(size: 13, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(card.platform.name.uppercased())
                        .font(.system(size: 8, weight: .medium, design: .monospaced))
                        .kerning(1.2)
                        .opacity(0.55)
                }
                Spacer(minLength: 0)
            } else {
                Image(systemName: "rectangle.stack")
                    .font(.system(size: 16, weight: .light))
                Text("No cards")
                    .font(.system(size: 13, weight: .medium))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) { Color.clear }
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    RolodexWidget()
} timeline: {
    RolodexEntry.placeholder
    RolodexEntry(date: .now, card: Card.samples[2], cardCount: 4)
}

#Preview("Medium", as: .systemMedium) {
    RolodexWidget()
} timeline: {
    RolodexEntry.placeholder
    RolodexEntry(date: .now, card: Card.samples[1], cardCount: 4)
}

#Preview("Large", as: .systemLarge) {
    RolodexWidget()
} timeline: {
    RolodexEntry.placeholder
}

#Preview("Circular", as: .accessoryCircular) {
    RolodexWidget()
} timeline: {
    RolodexEntry.placeholder
}

#Preview("Rectangular", as: .accessoryRectangular) {
    RolodexWidget()
} timeline: {
    RolodexEntry.placeholder
}
