import SwiftUI
import UIKit

// MARK: - Native Morphing Glass Host
struct NativeGlassHost<Content: View>: UIViewRepresentable {

	var tintColor: UIColor
	var interactive: Bool
	var cornerRadius: CGFloat
	let content: Content

	init(
		tintColor: UIColor,
		interactive: Bool = true,
		cornerRadius: CGFloat = 20,
		@ViewBuilder content: () -> Content
	) {
		self.tintColor = tintColor
		self.interactive = interactive
		self.cornerRadius = cornerRadius
		self.content = content()
	}

	func makeUIView(context: Context) -> UIVisualEffectView {
		// Native glass (iOS 26+)
		let glass = UIGlassEffect(style: .clear)
		glass.tintColor = tintColor
		glass.isInteractive = interactive

		let effectView = UIVisualEffectView(effect: glass)
		effectView.layer.cornerRadius = cornerRadius
		effectView.clipsToBounds = true

		// Host SwiftUI INSIDE the glass
		let hosting = UIHostingController(rootView: content)
		hosting.view.backgroundColor = .clear
		hosting.view.translatesAutoresizingMaskIntoConstraints = false

		effectView.contentView.addSubview(hosting.view)

		NSLayoutConstraint.activate([
			hosting.view.leadingAnchor.constraint(equalTo: effectView.contentView.leadingAnchor),
			hosting.view.trailingAnchor.constraint(equalTo: effectView.contentView.trailingAnchor),
			hosting.view.topAnchor.constraint(equalTo: effectView.contentView.topAnchor),
			hosting.view.bottomAnchor.constraint(equalTo: effectView.contentView.bottomAnchor)
		])

		context.coordinator.hostingController = hosting
		return effectView
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		if let glass = uiView.effect as? UIGlassEffect {
			glass.tintColor = tintColor
			glass.isInteractive = interactive
		}

		context.coordinator.hostingController?.rootView = content
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	class Coordinator {
		var hostingController: UIHostingController<Content>?
	}
}
