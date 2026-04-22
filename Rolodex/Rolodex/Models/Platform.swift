import SwiftUI

enum Platform: String, CaseIterable, Codable, Identifiable {
    case instagram
    case tiktok
    case twitter
    case linkedin
    case whatsapp
    case facebook
    case snapchat
    case discord
    case telegram
    case venmo
    case cashapp
    case website

    var id: String { rawValue }

    var name: String {
        switch self {
        case .instagram: "Instagram"
        case .tiktok: "TikTok"
        case .twitter: "X"
        case .linkedin: "LinkedIn"
        case .whatsapp: "WhatsApp"
        case .facebook: "Facebook"
        case .snapchat: "Snapchat"
        case .discord: "Discord"
        case .telegram: "Telegram"
        case .venmo: "Venmo"
        case .cashapp: "Cash App"
        case .website: "Website"
        }
    }

    var prefix: String {
        switch self {
        case .instagram, .tiktok, .twitter, .telegram, .venmo: "@"
        case .linkedin: "in/"
        case .cashapp: "$"
        case .whatsapp, .facebook, .snapchat, .discord, .website: ""
        }
    }

    var placeholder: String {
        switch self {
        case .instagram: "rob.wan"
        case .tiktok: "rob.wan"
        case .twitter: "robbthefobb"
        case .linkedin: "robwan-ai"
        case .whatsapp: "1-647-778-3778"
        case .facebook: "rob.wan"
        case .snapchat: "rob.wan"
        case .discord: "robwan"
        case .telegram: "robwan"
        case .venmo: "Robert-Wan"
        case .cashapp: "robwan"
        case .website: "robwan.co"
        }
    }

    func formatted(handle: String) -> String {
        switch self {
        case .instagram: "instagram.com/\(strippedAt(handle))"
        case .tiktok: "tiktok.com/@\(strippedAt(handle))"
        case .twitter: "x.com/\(strippedAt(handle))"
        case .linkedin: "linkedin.com/in/\(handle)"
        case .whatsapp: "wa.me/\(digitsOnly(handle))"
        case .facebook: "facebook.com/\(handle)"
        case .snapchat: "snapchat.com/add/\(handle)"
        case .discord: "discord.com/users/\(handle)"
        case .telegram: "t.me/\(strippedAt(handle))"
        case .venmo: "venmo.com/\(handle)"
        case .cashapp: "cash.app/$\(handle)"
        case .website: handle
        }
    }

    func deepLink(handle: String) -> URL? {
        let urlString: String = switch self {
        case .instagram: "https://instagram.com/\(strippedAt(handle))"
        case .tiktok: "https://tiktok.com/@\(strippedAt(handle))"
        case .twitter: "https://x.com/\(strippedAt(handle))"
        case .linkedin: "https://linkedin.com/in/\(handle)"
        case .whatsapp: "https://wa.me/\(digitsOnly(handle))"
        case .facebook: "https://facebook.com/\(handle)"
        case .snapchat: "https://snapchat.com/add/\(handle)"
        case .discord: "https://discord.com/users/\(handle)"
        case .telegram: "https://t.me/\(strippedAt(handle))"
        case .venmo: "https://venmo.com/\(handle)"
        case .cashapp: "https://cash.app/$\(handle)"
        case .website: handle.hasPrefix("http") ? handle : "https://\(handle)"
        }
        return URL(string: urlString)
    }

    private func strippedAt(_ s: String) -> String {
        s.hasPrefix("@") ? String(s.dropFirst()) : s
    }

    private func digitsOnly(_ s: String) -> String {
        s.filter(\.isNumber)
    }
}
