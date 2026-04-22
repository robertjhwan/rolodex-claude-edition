import SwiftUI
import UIKit
import Photos

/// Rasterizes a `WallpaperView` to a `UIImage` at device-pixel resolution,
/// then saves it directly to the user's photo library.
enum WallpaperExporter {
    static let defaultLogicalSize = CGSize(width: 393, height: 852)

    enum SaveResult {
        case saved, denied, failed(Error)
    }

    @MainActor
    static func render(card: Card, size: CGSize = defaultLogicalSize, scale: CGFloat = 3) -> UIImage? {
        let view = WallpaperView(card: card, size: size)
            .frame(width: size.width, height: size.height)
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(size)
        renderer.isOpaque = true
        return renderer.uiImage
    }

    @MainActor
    static func saveToPhotos(card: Card) async -> SaveResult {
        guard let image = render(card: card) else { return .failed(RenderError()) }

        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else { return .denied }

        return await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                if success {
                    continuation.resume(returning: .saved)
                } else if let error {
                    continuation.resume(returning: .failed(error))
                } else {
                    continuation.resume(returning: .failed(RenderError()))
                }
            })
        }
    }

    private struct RenderError: Error {}
}
