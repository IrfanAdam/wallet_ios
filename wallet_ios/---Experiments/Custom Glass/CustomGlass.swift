import SwiftUI

// MARK: - Custom Glass Button View
struct CustomGlass: View {
	var body: some View {
		ZStack(alignment: .center) {

			// Background glass panel
			RoundedRectangle(cornerRadius: 24)
				.glassEffect(
					.clear.tint(Color.blue.opacity(0.9)),
					in: .rect(cornerRadius: 24)
				)
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.frame(height: 100)

			// Base button background
			RoundedRectangle(cornerRadius: 16)
				.fill(Color.blue)
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color.white.opacity(0.3), lineWidth: 1)
				)
				.frame(width: 180, height: 60)

			// Interactive glass icon
			Image(systemName: "scribble.variable")
				.foregroundColor(.white)
				.frame(width: 42, height: 42)
				.background(
					NativeGlass(
						tintColor: UIColor(
							red: 0/255,
							green: 111/255,
							blue: 235/255,
							alpha: 0.8
						),
						interactive: true,
						cornerRadius: 16
					)
					.frame(width: 52, height: 52)
				)
		}
		.padding(60)
	}
}

struct CustomGlass2: View {
	@State private var isHovered = false

	var body: some View {
		ZStack(alignment: .center) {
			RoundedRectangle(cornerRadius: 24)
				.glassEffect(
					.clear.tint(Color.blue.opacity(0.9)),
					in: .rect(cornerRadius: 24)
				)
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.frame(height: 100)

			RoundedRectangle(cornerRadius: 16)
				.fill(Color.blue) // optional fill/tint
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(
							Color.white.opacity(0.6),
							lineWidth: 1
						)
				)
				.clipShape(RoundedRectangle(cornerRadius: 16))
				.frame(width: 180, height: 60)
			HStack {
				Image(systemName: "chevron.right.2")
					.foregroundStyle(Color.white)
					.frame(width: 42, height: 42)
					.background(
						RoundedRectangle(cornerRadius: 12)
							.glassEffect(
								.regular.tint(Color.blue).interactive(),
								in: .rect(cornerRadius: 12)
							)
					)
			}
		}
		.padding(60)
	}
}

struct CustomGlass_Previews: PreviewProvider {
	static var previews: some View {
		CustomGlass()
	}
}



// MARK: - Native UIKit Glass View (UIGlassEffect)
struct NativeGlass: UIViewRepresentable {
	var tintColor: UIColor
	var interactive: Bool
	var cornerRadius: CGFloat
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		let glass = UIGlassEffect(style: .clear) // native iOS 26+ glass style
		glass.tintColor = tintColor
		glass.isInteractive = interactive
		
		let view = UIVisualEffectView(effect: glass)
		view.layer.cornerRadius = cornerRadius
		view.clipsToBounds = true
		
		return view
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		// Update tint/interactive dynamically if needed
		if let glass = uiView.effect as? UIGlassEffect {
			glass.tintColor = tintColor
			glass.isInteractive = interactive
		}
	}
}
