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

#Preview {
	ZStack(alignment: .bottom) {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				ForEach(0..<40, id: \.self) { i in
					Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Line \(i)")
						.font(.system(size: 18, weight: .medium))
				}
			}
			.padding(24)
		}.background(.white)

		EdgeAccessory()
	}
	.padding(.horizontal, 4)
	.padding(.vertical, 4)
	.ignoresSafeArea()
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
