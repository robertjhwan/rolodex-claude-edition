import SwiftUI
import UIKit

struct PresentView: View {
    let card: Card
    var onClose: () -> Void
    var onPrev: () -> Void
    var onNext: () -> Void

    @Environment(\.openURL) private var openURL
    @State private var toastMessage: String?
    @State private var toastTask: Task<Void, Never>?

    var body: some View {
        let platform = card.platform
        let url = platform.deepLink(handle: card.handle)

        ZStack {
            platform.background
                .ignoresSafeArea()

            LinearGradient(
                colors: [Color.white.opacity(0.2), .clear],
                startPoint: .topTrailing, endPoint: .center
            )
            .blendMode(.overlay)
            .allowsHitTesting(false)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar(platform: platform)
                    .padding(.top, 14)
                    .padding(.horizontal, 22)

                Spacer()

                if let url {
                    QRCodeView(url: url, platform: platform, size: 280)
                        .padding(22)
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.35), radius: 30, y: 15)
                        )
                }

                Spacer()

                footer(platform: platform, url: url)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 30)
            }

            if let message = toastMessage {
                VStack {
                    Spacer()
                    Text(message)
                        .font(AppFont.mono(size: 12))
                        .kerning(0.8)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.black.opacity(0.6), in: Capsule())
                        .padding(.bottom, 120)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .foregroundStyle(platform.textColor)
        .animation(.easeInOut(duration: 0.25), value: toastMessage)
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < -80 {
                        onNext()
                    } else if value.translation.width > 80 {
                        onPrev()
                    } else if value.translation.height > 100 {
                        onClose()
                    }
                }
        )
    }

    @ViewBuilder
    private func topBar(platform: Platform) -> some View {
        HStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 34, height: 34)
                    .overlay {
                        PlatformLogo(platform: platform, size: 20, color: platform.textColor)
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Scan me")
                        .font(AppFont.mono(size: 11))
                        .kerning(1.5)
                        .textCase(.uppercase)
                        .opacity(0.65)
                    Text(platform.name)
                        .font(AppFont.platformHandle(platform, size: 15))
                }
            }
            Spacer()
            HStack(spacing: 10) {
                Button(action: exportWallpaper) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(Color.black.opacity(0.2), in: Circle())
                }
                .buttonStyle(.plain)
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .frame(width: 36, height: 36)
                        .background(Color.black.opacity(0.2), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func exportWallpaper() {
        Task { @MainActor in
            showToast("Saving…")
            let result = await WallpaperExporter.saveToPhotos(card: card)
            switch result {
            case .saved:
                showToast("Saved to Photos")
            case .denied:
                showToast("Allow Photos access in Settings")
            case .failed:
                showToast("Save failed — try again")
            }
        }
    }

    @MainActor
    private func showToast(_ message: String) {
        toastTask?.cancel()
        toastMessage = message
        toastTask = Task {
            try? await Task.sleep(for: .seconds(2.5))
            guard !Task.isCancelled else { return }
            toastMessage = nil
        }
    }

    @ViewBuilder
    private func footer(platform: Platform, url: URL?) -> some View {
        VStack(spacing: 14) {
            Text(card.displayHandle)
                .font(AppFont.platformHandle(platform, size: 38))
                .kerning(-0.75)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(platform.formatted(handle: card.handle))
                .font(AppFont.mono(size: 10))
                .kerning(1.5)
                .textCase(.uppercase)
                .opacity(0.65)

            openButton(platform: platform, url: url)

            HStack(spacing: 16) {
                iconCircle(systemName: "chevron.left", action: onPrev)
                Text("\(card.scans) scans")
                    .font(AppFont.mono(size: 11))
                    .kerning(1.2)
                    .opacity(0.75)
                iconCircle(systemName: "chevron.right", action: onNext)
            }
        }
    }

    private func openButton(platform: Platform, url: URL?) -> some View {
        Button {
            if let url { openURL(url) }
        } label: {
            HStack(spacing: 8) {
                Text("Open in \(platform.name)")
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .bold))
            }
            .font(AppFont.platformHandle(platform, size: 15))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.18))
            )
        }
        .buttonStyle(.plain)
    }

    private func iconCircle(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .bold))
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.15), in: Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PresentView(card: Card.samples[0], onClose: {}, onPrev: {}, onNext: {})
}
