import SwiftUI

struct PlatformLogo: View {
    let platform: Platform
    var size: CGFloat = 24
    var color: Color = .white

    var body: some View {
        Group {
            if platform == .website {
                Image(systemName: "globe")
                    .font(.system(size: size * 0.85, weight: .semibold))
            } else {
                Image(assetName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .foregroundStyle(color)
        .frame(width: size, height: size)
    }

    private var assetName: String {
        "Logo-\(platform.rawValue)"
    }
}

#Preview {
    HStack(spacing: 12) {
        ForEach(Platform.allCases) { p in
            PlatformLogo(platform: p, size: 28, color: .white)
        }
    }
    .padding()
    .background(Color.black)
}
