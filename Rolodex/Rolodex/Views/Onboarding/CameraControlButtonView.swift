import SwiftUI

/// Side-view illustration of an iPhone 16 Pro edge showing the Camera Control button.
/// A pulse ring animates to draw the eye.
struct CameraControlButtonView: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            // phone body edge — horizontal slab
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0x4A4A4C), location: 0.0),
                            .init(color: Color(hex: 0x2A2A2C), location: 0.3),
                            .init(color: Color(hex: 0x1A1A1C), location: 0.7),
                            .init(color: Color(hex: 0x3A3A3C), location: 1.0),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 30, y: 20)
                .padding(.vertical, 30)

            // glossy highlight strip
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.14), .clear],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(height: 20)
                .blur(radius: 4)
                .padding(.horizontal, 16)
                .offset(y: -34)

            // Pulse ring
            RoundedRectangle(cornerRadius: 27, style: .continuous)
                .strokeBorder(Color(red: 1, green: 200/255, blue: 150/255).opacity(0.35), lineWidth: 1.5)
                .frame(width: 110, height: 54)
                .scaleEffect(pulse ? 1.5 : 0.95)
                .opacity(pulse ? 0 : 1)
                .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: pulse)

            // Camera Control button — recessed oval with sapphire inset
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0x151517), location: 0.0),
                            .init(color: Color(hex: 0x0A0A0C), location: 0.45),
                            .init(color: Color(hex: 0x1F1F21), location: 1.0),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: 90, height: 36)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.04), lineWidth: 1.5)
                }
                .overlay {
                    // shutter glyph — subtle circle
                    Circle()
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 12, height: 12)
                        .shadow(color: Color(red: 1, green: 180/255, blue: 100/255).opacity(0.15), radius: 4)
                }
                .shadow(color: .black.opacity(0.8), radius: 2, y: 2)
        }
        .frame(width: 280, height: 140)
        .onAppear { pulse = true }
    }
}
