import SwiftUI

struct FooterTile: View {
    let systemImage: String
    let label: String
    let sub: String
    var action: (() -> Void)?
    @Environment(\.themeColors) private var t

    var body: some View {
        Button(action: { action?() }) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(t.foreground)
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(t.foreground)
                    .padding(.top, 8)
                Text(sub)
                    .font(AppFont.mono(size: 9))
                    .kerning(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(t.mutedSoft)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(t.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(t.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
