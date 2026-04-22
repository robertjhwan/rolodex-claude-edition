import SwiftUI

struct AddCardView: View {
    var onCancel: () -> Void
    var onSave: (Platform, String) -> Void

    @State private var picked: Platform?
    @State private var handle: String = ""
    @FocusState private var handleFocused: Bool
    @Environment(\.themeColors) private var t

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        VStack(spacing: 0) {
            navBar

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("Pick a ")
                        .font(AppFont.serif(size: 36))
                    Text("platform")
                        .font(AppFont.serif(size: 36, italic: true))
                        .foregroundStyle(t.mutedSoft)
                }
                Text("Your QR is generated live from a deep link — rename freely.")
                    .font(.system(size: 13))
                    .foregroundStyle(t.muted)
            }
            .padding(.horizontal, 22)
            .padding(.top, 28)
            .padding(.bottom, 14)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Platform.allCases) { platform in
                        tile(for: platform)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

            if let picked {
                handleField(for: picked)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(t.background.ignoresSafeArea())
        .providingThemeColors()
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: picked)
    }

    private var navBar: some View {
        HStack {
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.system(size: 15))
                    .foregroundStyle(t.muted)
            }
            Spacer()
            Text("New Card")
                .font(.system(size: 15, weight: .semibold))
            Spacer()
            Button {
                if let picked, !handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    onSave(picked, handle)
                }
            } label: {
                Text("Add")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(canSave ? t.foreground : t.mutedSoft)
            }
            .disabled(!canSave)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private func tile(for platform: Platform) -> some View {
        let selected = picked == platform
        return Button {
            withAnimation {
                picked = platform
                handle = ""
            }
            handleFocused = true
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                PlatformLogo(platform: platform, size: 22, color: selected ? platform.textColor : t.foreground)
                Text(platform.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(selected ? platform.textColor : t.foreground)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selected ? AnyShapeStyle(platform.solidColor) : AnyShapeStyle(t.surface))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(selected ? Color.white.opacity(0.2) : t.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func handleField(for platform: Platform) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Handle")
                .font(AppFont.mono(size: 10))
                .kerning(1.5)
                .textCase(.uppercase)
                .foregroundStyle(t.mutedSoft)

            TextField(platform.placeholder, text: $handle)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($handleFocused)
                .font(.system(size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(t.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(t.border, lineWidth: 1)
                }

            if !handle.isEmpty {
                Text("→ \(platform.formatted(handle: handle))")
                    .font(AppFont.mono(size: 11))
                    .foregroundStyle(t.muted)
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .background(
            Rectangle()
                .fill(t.border)
                .frame(height: 1),
            alignment: .top
        )
    }

    private var canSave: Bool {
        picked != nil && !handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    AddCardView(onCancel: {}, onSave: { _, _ in })
        .preferredColorScheme(.dark)
}
