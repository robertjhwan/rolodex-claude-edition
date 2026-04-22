import SwiftUI

struct OnboardingView: View {
    var onDone: () -> Void

    @State private var step = 0
    @Environment(\.openURL) private var openURL

    private struct Slide {
        let eyebrow: String
        let title: [TitleChunk]
        let body: String
        let visual: Visual
    }

    private enum Visual {
        case cards
        case cameraControl
    }

    private enum TitleChunk {
        case plain(String)
        case italic(String)
        case newline
    }

    private let slides: [Slide] = [
        .init(
            eyebrow: "Welcome",
            title: [.plain("Your socials,"), .newline, .italic("one stack.")],
            body: "No more scrambling through 5 different apps. Everyone you meet, one swipe away.",
            visual: .cards
        ),
        .init(
            eyebrow: "The Rolodex Button",
            title: [.plain("Squeeze"), .newline, .italic("Camera Control.")],
            body: "Assign Rolodex to your iPhone's Camera Control button. Squeeze anywhere — even on the lock screen — and your top card is ready.",
            visual: .cameraControl
        ),
        .init(
            eyebrow: "Ready",
            title: [.plain("Build your"), .newline, .italic("first cards.")],
            body: "Add Instagram, LinkedIn, WhatsApp — or all twelve. Each QR is generated live from a deep link, so usernames can change without rescreenshotting.",
            visual: .cards
        )
    ]

    var body: some View {
        let s = slides[step]
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Group {
                    switch s.visual {
                    case .cameraControl:
                        CameraControlButtonView()
                    case .cards:
                        onboardingCardsIllustration
                    }
                }
                .padding(.bottom, 40)

                Text(s.eyebrow)
                    .font(AppFont.mono(size: 10))
                    .kerning(2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.white.opacity(0.45))
                    .padding(.bottom, 14)

                titleText(chunks: s.title)
                    .multilineTextAlignment(.center)

                Text(s.body)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .frame(maxWidth: 320)
                    .padding(.top, 18)
                    .padding(.horizontal, 28)

                Spacer()

                bottomControls
                    .padding(.horizontal, 28)
                    .padding(.bottom, 40)
            }
        }
        .foregroundStyle(.white)
        .animation(.spring(response: 0.4, dampingFraction: 0.88), value: step)
    }

    private func titleText(chunks: [TitleChunk]) -> some View {
        var plain = AttributedString()
        for chunk in chunks {
            switch chunk {
            case .plain(let s):
                var seg = AttributedString(s)
                seg.font = AppFont.serif(size: 44)
                plain += seg
            case .italic(let s):
                var seg = AttributedString(s)
                seg.font = AppFont.serif(size: 44, italic: true)
                plain += seg
            case .newline:
                plain += AttributedString("\n")
            }
        }
        return Text(plain)
            .lineSpacing(2)
    }

    private var onboardingCardsIllustration: some View {
        ZStack {
            ForEach(Array(decorationCards.enumerated()), id: \.offset) { idx, card in
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(card.bg)
                    .frame(width: 140, height: 180)
                    .overlay(alignment: .bottomLeading) {
                        PlatformLogo(platform: card.platform, size: 26, color: .white)
                            .padding(12)
                    }
                    .shadow(color: .black.opacity(0.4), radius: 18, y: 12)
                    .rotationEffect(.degrees(card.rotation))
                    .offset(x: card.offsetX, y: CGFloat(idx) * -4)
                    .zIndex(Double(3 - Swift.abs(idx - 1)))
            }
        }
        .frame(width: 220, height: 220)
    }

    private struct DecorationCard {
        let platform: Platform
        let rotation: Double
        let offsetX: CGFloat
        let bg: AnyShapeStyle
    }

    private var decorationCards: [DecorationCard] {
        [
            .init(platform: .instagram, rotation: -10, offsetX: -24,
                  bg: AnyShapeStyle(LinearGradient(
                    colors: [Color(hex: 0x515BD4), Color(hex: 0xDD2A7B), Color(hex: 0xF58529)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                  ))),
            .init(platform: .linkedin, rotation: 0, offsetX: 0,
                  bg: AnyShapeStyle(LinearGradient(
                    colors: [Color(hex: 0x0A66C2), Color(hex: 0x004182)],
                    startPoint: .top, endPoint: .bottom
                  ))),
            .init(platform: .whatsapp, rotation: 12, offsetX: 24,
                  bg: AnyShapeStyle(LinearGradient(
                    colors: [Color(hex: 0x25D366), Color(hex: 0x128C7E)],
                    startPoint: .top, endPoint: .bottom
                  ))),
        ]
    }

    private var bottomControls: some View {
        VStack(spacing: 18) {
            HStack(spacing: 6) {
                ForEach(0..<slides.count, id: \.self) { i in
                    Capsule()
                        .frame(width: i == step ? 24 : 6, height: 6)
                        .foregroundStyle(i == step ? Color.white : Color.white.opacity(0.18))
                }
            }

            Button {
                if step == 1 {
                    if let url = URL(string: "App-Prefs:root=ACTION_BUTTON") {
                        openURL(url)
                    }
                }
                if step < slides.count - 1 {
                    step += 1
                } else {
                    onDone()
                }
            } label: {
                Text(primaryButtonTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)

            if step < slides.count - 1 {
                Button(action: onDone) {
                    Text("Skip")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var primaryButtonTitle: String {
        if step == 1 { return "Assign Rolodex →" }
        if step < slides.count - 1 { return "Continue" }
        return "Get started"
    }
}

#Preview {
    OnboardingView(onDone: {})
}
