import AVKit
import SwiftUI
import UIKit

/// Listens for iPhone 16's Camera Control button press via AVCaptureEventInteraction.
/// Posts a notification when pressed so the root view can jump straight to Present mode.
///
/// iOS 17.2+ on hardware with Camera Control (iPhone 16 family). Older hardware skips this.
enum CameraControlService {
    static let pressed = Notification.Name("co.robwan.rolodex.cameraControlPressed")

    @MainActor
    static func attach(to view: UIView) {
        guard #available(iOS 17.2, *) else { return }
        let interaction = AVCaptureEventInteraction(
            primary: { event in
                if event.phase == .began {
                    NotificationCenter.default.post(name: pressed, object: nil)
                }
            },
            secondary: { _ in }
        )
        interaction.isEnabled = true
        view.addInteraction(interaction)
    }
}

/// Silently attaches AVCaptureEventInteraction to a host UIView behind SwiftUI content.
struct CameraControlAttacher: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        CameraControlService.attach(to: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
