import SwiftUI

enum AppFont {
    /// Instrument Serif for display headings. Falls back to system serif.
    static func serif(size: CGFloat, italic: Bool = false) -> Font {
        let name = italic ? "InstrumentSerif-Italic" : "InstrumentSerif-Regular"
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        let base = Font.system(size: size, weight: .regular, design: .serif)
        return italic ? base.italic() : base
    }

    /// Monospace label font (JetBrains Mono aesthetic).
    static func mono(size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    static func platformHandle(_ platform: Platform, size: CGFloat) -> Font {
        if UIFont(name: platform.handleFontName, size: size) != nil {
            return .custom(platform.handleFontName, size: size)
                .weight(platform.handleWeight)
        }
        return .system(size: size, weight: platform.handleWeight, design: designFor(platform))
    }

    private static func designFor(_ platform: Platform) -> Font.Design {
        switch platform {
        case .website: .serif
        default: .default
        }
    }
}
