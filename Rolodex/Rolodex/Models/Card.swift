import Foundation

struct Card: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var platform: Platform
    var handle: String
    var scans: Int = 0
    var favorite: Bool = false
    var order: Int = 0
    var createdAt: Date = .now

    var displayHandle: String {
        platform.prefix + handle
    }
}

extension Card {
    static let samples: [Card] = [
        .init(platform: .instagram, handle: "rob.wan", scans: 47, favorite: true, order: 0),
        .init(platform: .linkedin, handle: "robwan-ai", scans: 124, favorite: true, order: 1),
        .init(platform: .twitter, handle: "robbthefobb", scans: 18, order: 2),
        .init(platform: .whatsapp, handle: "1-647-778-3778", scans: 31, favorite: true, order: 3),
        .init(platform: .telegram, handle: "robwan", scans: 9, order: 4),
        .init(platform: .tiktok, handle: "rob.wan", scans: 6, order: 5),
        .init(platform: .venmo, handle: "Robert-Wan", scans: 12, order: 6),
        .init(platform: .website, handle: "robwan.co", scans: 22, order: 7),
    ]
}
