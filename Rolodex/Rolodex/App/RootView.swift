import SwiftUI

enum AppScreen: Hashable {
    case home
    case present(cardID: UUID)
    case add
}

struct RootView: View {
    @Environment(CardStore.self) private var store
    @State private var activeIndex: Int = 0
    @State private var screen: AppScreen = .home
    @State private var showAdd = false
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            CameraControlAttacher()
                .frame(width: 1, height: 1)
                .allowsHitTesting(false)

            HomeView(
                activeIndex: $activeIndex,
                onPresent: { idx in
                    activeIndex = idx
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                        screen = .present(cardID: store.cards[idx].id)
                    }
                },
                onAdd: { showAdd = true },
                onSettings: { showOnboarding = true }
            )

            if case .present = screen, let card = currentCard {
                PresentView(
                    card: card,
                    onClose: {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                            screen = .home
                        }
                    },
                    onPrev: { step(-1) },
                    onNext: { step(1) }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.94)))
                .zIndex(10)
            }
        }
        .sheet(isPresented: $showAdd) {
            AddCardView(onCancel: { showAdd = false }, onSave: { platform, handle in
                store.addCard(platform: platform, handle: handle)
                showAdd = false
            })
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(onDone: { showOnboarding = false })
        }
        .onAppear {
            if activeIndex >= store.cards.count {
                activeIndex = max(0, store.cards.count - 1)
            }
            handleLaunchArgs()
        }
        .onReceive(NotificationCenter.default.publisher(for: CameraControlService.pressed)) { _ in
            guard let defaultCard = store.defaultCardForCameraControl,
                  let idx = store.cards.firstIndex(where: { $0.id == defaultCard.id }) else { return }
            activeIndex = idx
            withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                screen = .present(cardID: defaultCard.id)
            }
        }
        // rolodex://card/<UUID>  — deep link from the home-screen widget
        .onOpenURL { url in
            guard url.scheme == "rolodex",
                  url.host == "card",
                  let uuidString = url.pathComponents.last,
                  let cardID = UUID(uuidString: uuidString),
                  let idx = store.cards.firstIndex(where: { $0.id == cardID })
            else { return }
            activeIndex = idx
            withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                screen = .present(cardID: cardID)
            }
        }
    }

    private func handleLaunchArgs() {
        #if DEBUG
        if CommandLine.arguments.contains("-save-wallpaper") {
            guard let card = store.cards.first else { return }
            Task { @MainActor in
                _ = await WallpaperExporter.saveToPhotos(card: card)
            }
            return
        }
        guard let idx = CommandLine.arguments.firstIndex(of: "-screen"),
              idx + 1 < CommandLine.arguments.count else { return }
        let target = CommandLine.arguments[idx + 1]
        switch target {
        case "present":
            if !store.cards.isEmpty {
                screen = .present(cardID: store.cards[activeIndex].id)
            }
        case "add":
            showAdd = true
        default:
            screen = .home
        }
        #endif
    }

    private var currentCard: Card? {
        guard store.cards.indices.contains(activeIndex) else { return nil }
        return store.cards[activeIndex]
    }

    private func step(_ delta: Int) {
        guard !store.cards.isEmpty else { return }
        let count = store.cards.count
        let next = ((activeIndex + delta) % count + count) % count
        withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) {
            activeIndex = next
        }
        if case .present = screen {
            screen = .present(cardID: store.cards[next].id)
        }
        store.incrementScan(cardID: store.cards[next].id)
    }
}
