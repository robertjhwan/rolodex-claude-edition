import WidgetKit
import SwiftUI

// MARK: - Shared constants

enum WidgetShared {
    static let appGroupID  = "group.co.robwan.Rolodex"
    static let cardsKey    = "rlx.cards.v1"
    static let urlScheme   = "rolodex"
}

// MARK: - Timeline entry

struct RolodexEntry: TimelineEntry {
    let date: Date
    let card: Card?
    let cardCount: Int

    static let placeholder = RolodexEntry(
        date: .now,
        card: Card.samples[0],
        cardCount: Card.samples.count
    )
}

// MARK: - Timeline provider

struct RolodexProvider: TimelineProvider {
    typealias Entry = RolodexEntry

    func placeholder(in context: Context) -> RolodexEntry { .placeholder }

    func getSnapshot(in context: Context, completion: @escaping (RolodexEntry) -> Void) {
        completion(context.isPreview ? .placeholder : loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RolodexEntry>) -> Void) {
        // Reload is driven by WidgetCenter.reloadAllTimelines() in the app.
        completion(Timeline(entries: [loadEntry()], policy: .never))
    }

    // MARK: Private

    private func loadEntry() -> RolodexEntry {
        let ud = UserDefaults(suiteName: WidgetShared.appGroupID) ?? .standard
        guard
            let data  = ud.data(forKey: WidgetShared.cardsKey),
            let cards = try? JSONDecoder().decode([Card].self, from: data),
            !cards.isEmpty
        else {
            return .init(date: .now, card: nil, cardCount: 0)
        }
        let sorted = cards.sorted { $0.order < $1.order }
        let card   = sorted.filter(\.favorite).max(by: { $0.scans < $1.scans })
                  ?? sorted.max(by: { $0.scans < $1.scans })
                  ?? sorted.first
        return .init(date: .now, card: card, cardCount: sorted.count)
    }
}

// MARK: - Widget configuration

struct RolodexWidget: Widget {
    let kind = "RolodexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RolodexProvider()) { entry in
            WidgetEntryView(entry: entry)
                .widgetURL(deepLinkURL(for: entry.card))
        }
        .configurationDisplayName("qard")
        .description("Your default social card, always ready to scan.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
        ])
        .contentMarginsDisabled()
    }

    private func deepLinkURL(for card: Card?) -> URL? {
        guard let id = card?.id else { return URL(string: "\(WidgetShared.urlScheme)://") }
        return URL(string: "\(WidgetShared.urlScheme)://card/\(id.uuidString)")
    }
}
