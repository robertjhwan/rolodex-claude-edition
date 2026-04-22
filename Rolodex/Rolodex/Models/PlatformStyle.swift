import SwiftUI

extension Platform {
    var textColor: Color {
        switch self {
        case .snapchat, .cashapp: .black
        default: .white
        }
    }

    var qrColor: Color {
        switch self {
        case .instagram: Color(hex: 0xC13584)
        case .tiktok: Color(hex: 0xFE2C55)
        case .twitter: .black
        case .linkedin: Color(hex: 0x0A66C2)
        case .whatsapp: Color(hex: 0x128C7E)
        case .facebook: Color(hex: 0x1877F2)
        case .snapchat: .black
        case .discord: Color(hex: 0x5865F2)
        case .telegram: Color(hex: 0x229ED9)
        case .venmo: Color(hex: 0x008CFF)
        case .cashapp: Color(hex: 0x00D632)
        case .website: Color(hex: 0x1A1A1A)
        }
    }

    var solidColor: Color {
        switch self {
        case .instagram: Color(hex: 0xE1306C)
        case .tiktok: .black
        case .twitter: .black
        case .linkedin: Color(hex: 0x0A66C2)
        case .whatsapp: Color(hex: 0x25D366)
        case .facebook: Color(hex: 0x1877F2)
        case .snapchat: Color(hex: 0xFFFC00)
        case .discord: Color(hex: 0x5865F2)
        case .telegram: Color(hex: 0x229ED9)
        case .venmo: Color(hex: 0x3D95CE)
        case .cashapp: Color(hex: 0x00D632)
        case .website: Color(hex: 0x1A1A1A)
        }
    }

    /// Brand background — either a gradient or a solid color, as a View.
    @ViewBuilder
    var background: some View {
        switch self {
        case .instagram:
            LinearGradient(
                stops: [
                    .init(color: Color(hex: 0x515BD4), location: 0.00),
                    .init(color: Color(hex: 0x8134AF), location: 0.25),
                    .init(color: Color(hex: 0xDD2A7B), location: 0.50),
                    .init(color: Color(hex: 0xFEDA77), location: 0.90),
                    .init(color: Color(hex: 0xF58529), location: 1.00),
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .tiktok:
            LinearGradient(
                colors: [Color(hex: 0x010101), Color(hex: 0x161616)],
                startPoint: .top, endPoint: .bottom
            )
        case .twitter:
            Color.black
        case .linkedin:
            LinearGradient(
                colors: [Color(hex: 0x0A66C2), Color(hex: 0x004182)],
                startPoint: .top, endPoint: .bottom
            )
        case .whatsapp:
            LinearGradient(
                colors: [Color(hex: 0x25D366), Color(hex: 0x128C7E)],
                startPoint: .top, endPoint: .bottom
            )
        case .facebook:
            LinearGradient(
                colors: [Color(hex: 0x1877F2), Color(hex: 0x0A4DB0)],
                startPoint: .top, endPoint: .bottom
            )
        case .snapchat:
            Color(hex: 0xFFFC00)
        case .discord:
            LinearGradient(
                colors: [Color(hex: 0x5865F2), Color(hex: 0x404AB8)],
                startPoint: .top, endPoint: .bottom
            )
        case .telegram:
            LinearGradient(
                colors: [Color(hex: 0x2AABEE), Color(hex: 0x229ED9)],
                startPoint: .top, endPoint: .bottom
            )
        case .venmo:
            LinearGradient(
                colors: [Color(hex: 0x3D95CE), Color(hex: 0x1E5E8A)],
                startPoint: .top, endPoint: .bottom
            )
        case .cashapp:
            Color(hex: 0x00D632)
        case .website:
            LinearGradient(
                colors: [Color(hex: 0x1A1A1A), Color(hex: 0x3A3A3A)],
                startPoint: .top, endPoint: .bottom
            )
        }
    }

    /// Font family name (first fallback that's commonly available).
    /// Proprietary brand fonts (Instagram Sans, Cash Sans, etc.) aren't shipped —
    /// the open-source fallback picks up if bundled; else system font substitutes.
    var handleFontName: String {
        switch self {
        case .instagram: "Rubik"
        case .tiktok: "Montserrat"
        case .twitter: "Inter"
        case .linkedin: "SourceSans3"
        case .whatsapp: "HelveticaNeue"
        case .facebook: "Inter"
        case .snapchat: "AvenirNext-Bold"
        case .discord: "NotoSans"
        case .telegram: "Roboto"
        case .venmo: "Figtree"
        case .cashapp: "Manrope"
        case .website: "InstrumentSerif-Regular"
        }
    }

    var handleWeight: Font.Weight {
        switch self {
        case .instagram, .tiktok, .twitter, .facebook, .snapchat, .cashapp: .bold
        case .linkedin, .discord, .venmo: .semibold
        case .whatsapp, .telegram: .medium
        case .website: .regular
        }
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
