import SwiftUI

struct HomeView: View {
    @Environment(CardStore.self) private var store
    @Binding var activeIndex: Int
    var onPresent: (Int) -> Void
    var onAdd: () -> Void
    var onSettings: () -> Void

    @AppStorage("rlx.theme") private var themeRaw: String = ThemePreference.system.rawValue

    private var theme: ThemePreference {
        ThemePreference(rawValue: themeRaw) ?? .system
    }

    var body: some View {
        ZStack {
            backgroundLayer

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 22)
                    .padding(.top, 12)

                Spacer(minLength: 0)

                CardStackView(
                    cards: store.cards,
                    activeIndex: $activeIndex,
                    onSelect: { activeIndex = $0 },
                    onPresent: onPresent,
                    width: 320
                )

                Spacer(minLength: 0)

                bottomSection
                    .padding(.horizontal, 22)
                    .padding(.bottom, 18)
            }
        }
        .providingThemeColors()
        .preferredColorScheme(theme.colorScheme)
    }

    private var backgroundLayer: some View {
        GeometryReader { _ in
            ZStack {
                EnvironmentBackground()
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 200/255, blue: 150/255).opacity(0.08),
                        .clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0),
                    startRadius: 0, endRadius: 500
                )
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var topBar: some View {
        HStack {
            topBarTitle
            Spacer()
            topBarActions
        }
    }

    @ViewBuilder
    private var topBarTitle: some View {
        ThemedVStack(spacing: 4) {
            ThemedMonoLabel("Rolodex · Robert Wan")
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(store.cards.count)")
                    .font(AppFont.serif(size: 36))
                Text("cards")
                    .font(AppFont.serif(size: 36, italic: true))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var topBarActions: some View {
        HStack(spacing: 8) {
            CircleButton(action: cycleTheme) {
                Image(systemName: theme == .dark ? "moon.fill" : (theme == .light ? "sun.max.fill" : "circle.lefthalf.filled"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
            }
            CircleButton(action: onSettings) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            CircleButton(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
    }

    private var bottomSection: some View {
        VStack(spacing: 20) {
            pagination
            HStack(spacing: 10) {
                FooterTile(systemImage: "arrow.right", label: "Present", sub: "Full screen") {
                    onPresent(activeIndex)
                }
                FooterTile(systemImage: "square.and.arrow.up", label: "Share", sub: "AirDrop · vCard", action: nil)
                FooterTile(
                    systemImage: "calendar",
                    label: "Stats",
                    sub: "\(currentScans) scans"
                )
            }
            ThemedMonoLabel("tap card to present · swipe · hold camera control")
                .multilineTextAlignment(.center)
        }
    }

    private var pagination: some View {
        HStack(spacing: 6) {
            ForEach(Array(store.cards.enumerated()), id: \.element.id) { idx, _ in
                Capsule()
                    .frame(width: idx == activeIndex ? 28 : 6, height: 6)
                    .foregroundStyle(idx == activeIndex ? Color.primary : Color.primary.opacity(0.18))
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: activeIndex)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            activeIndex = idx
                        }
                    }
            }
        }
    }

    private var currentScans: Int {
        store.cards.indices.contains(activeIndex) ? store.cards[activeIndex].scans : 0
    }

    private func cycleTheme() {
        themeRaw = theme.cycled().rawValue
    }
}

private struct EnvironmentBackground: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        (scheme == .dark ? Color.black : Color(hex: 0xF2F0EB))
            .ignoresSafeArea()
    }
}

private struct ThemedVStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: spacing, content: content)
    }
}

struct ThemedMonoLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    @Environment(\.themeColors) private var t
    var body: some View {
        Text(text)
            .font(AppFont.mono(size: 10))
            .kerning(1.8)
            .textCase(.uppercase)
            .foregroundStyle(t.mutedSoft)
    }
}
