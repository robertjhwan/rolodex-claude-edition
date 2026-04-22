import SwiftUI

struct CircleButton<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let content: () -> Content
    @Environment(\.themeColors) private var t

    var body: some View {
        Button(action: action) {
            content()
                .frame(width: 38, height: 38)
                .background(t.surface, in: Circle())
                .overlay {
                    Circle().strokeBorder(t.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}
