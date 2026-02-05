import SwiftUI

struct EdgeAccessory: View {
	var body: some View {
		VStack {
			SwipeToUnlock(
				capSize: CGSize(width: 60, height: 56),
				trackHeight: 56
			) {
				print("Unlocked")
			}
			.padding(.horizontal, 24)
			.padding(.vertical, 12)

			HStack(spacing: 12) {
				Image(systemName: "waveform")
					.padding(10)
					.background(.white.opacity(0.25), in: .circle)

				Text("Recede")
					.foregroundStyle(.white)

				Spacer()
			}
			.padding()
		}
		.padding(12)
		.background(
			Color.clear
				.glassEffect(
					.clear.tint(Color.blue).interactive(),
					in: .containerRelative
				)
		)
	}
}

struct NativeGlass2: UIViewRepresentable {
	var tintColor: UIColor
	var interactive: Bool

	func makeUIView(context: Context) -> UIVisualEffectView {
		let glass = UIGlassEffect(style: .clear)
		glass.tintColor = tintColor
		glass.isInteractive = interactive

		return UIVisualEffectView(effect: glass)
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		if let glass = uiView.effect as? UIGlassEffect {
			glass.tintColor = tintColor
			glass.isInteractive = interactive
		}
	}
}
