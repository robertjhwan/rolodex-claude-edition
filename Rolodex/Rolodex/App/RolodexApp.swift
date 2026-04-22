import SwiftUI

@main
struct RolodexApp: App {
    @State private var store = CardStore()
    @AppStorage("rlx.theme") private var themeRaw: String = ThemePreference.system.rawValue
    @AppStorage("rlx.onboarded") private var hasOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(\.themePreference, ThemePreference(rawValue: themeRaw) ?? .system)
                .preferredColorScheme(ThemePreference(rawValue: themeRaw)?.colorScheme)
                .fullScreenCover(isPresented: .init(
                    get: { !hasOnboarded },
                    set: { if !$0 { hasOnboarded = true } }
                )) {
                    OnboardingView(onDone: { hasOnboarded = true })
                }
        }
    }
}

enum ThemePreference: String, CaseIterable {
    case system, light, dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }

    func cycled() -> ThemePreference {
        switch self {
        case .system: .light
        case .light: .dark
        case .dark: .system
        }
    }
}

private struct ThemePreferenceKey: EnvironmentKey {
    static let defaultValue: ThemePreference = .system
}

extension EnvironmentValues {
    var themePreference: ThemePreference {
        get { self[ThemePreferenceKey.self] }
        set { self[ThemePreferenceKey.self] = newValue }
    }
}
