import Foundation
import Observation

@Observable
final class CardStore {
    var cards: [Card]

    private let storageKey = "rlx.cards.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Card].self, from: data),
           !decoded.isEmpty {
            cards = decoded.sorted { $0.order < $1.order }
        } else {
            cards = Card.samples
        }
    }

    func persist() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func addCard(platform: Platform, handle: String) {
        let cleaned = handle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        let newCard = Card(
            platform: platform,
            handle: cleaned,
            scans: 0,
            favorite: false,
            order: (cards.map(\.order).max() ?? -1) + 1
        )
        cards.append(newCard)
        persist()
    }

    func removeCard(id: UUID) {
        cards.removeAll { $0.id == id }
        persist()
    }

    func toggleFavorite(id: UUID) {
        guard let idx = cards.firstIndex(where: { $0.id == id }) else { return }
        cards[idx].favorite.toggle()
        persist()
    }

    func incrementScan(cardID: UUID) {
        guard let idx = cards.firstIndex(where: { $0.id == cardID }) else { return }
        cards[idx].scans += 1
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
        for (idx, _) in cards.enumerated() {
            cards[idx].order = idx
        }
        persist()
    }

    var totalScans: Int { cards.map(\.scans).reduce(0, +) }

    /// Card used as the networking default — most-scanned favorite, else most-scanned overall.
    var defaultCardForCameraControl: Card? {
        cards.filter(\.favorite).max(by: { $0.scans < $1.scans })
            ?? cards.max(by: { $0.scans < $1.scans })
            ?? cards.first
    }
}
