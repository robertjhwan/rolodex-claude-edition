import SwiftUI

struct ThemeColors {
    let background: Color
    let backgroundGlow: Color
    let foreground: Color
    let muted: Color
    let mutedSoft: Color
    let border: Color
    let surface: Color
    let surfaceHigh: Color

    static let light = ThemeColors(
        background: Color(hex: 0xF2F0EB),
        backgroundGlow: Color(red: 1.0, green: 220/255, blue: 180/255).opacity(0.5),
        foreground: Color(hex: 0x0A0A0B),
        muted: Color(hex: 0x0A0A0B).opacity(0.6),
        mutedSoft: Color(hex: 0x0A0A0B).opacity(0.45),
        border: Color(hex: 0x0A0A0B).opacity(0.08),
        surface: Color(hex: 0x0A0A0B).opacity(0.04),
        surfaceHigh: Color(hex: 0x0A0A0B).opacity(0.08)
    )

    static let dark = ThemeColors(
        background: .black,
        backgroundGlow: Color(red: 255/255, green: 200/255, blue: 150/255).opacity(0.04),
        foreground: .white,
        muted: Color.white.opacity(0.6),
        mutedSoft: Color.white.opacity(0.4),
        border: Color.white.opacity(0.06),
        surface: Color.white.opacity(0.06),
        surfaceHigh: Color.white.opacity(0.1)
    )
}

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue = ThemeColors.dark
}

extension EnvironmentValues {
    var themeColors: ThemeColors {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }
}

struct ThemeColorsProvider: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.environment(\.themeColors, colorScheme == .dark ? .dark : .light)
    }
}

extension View {
    func providingThemeColors() -> some View {
        modifier(ThemeColorsProvider())
    }
}
