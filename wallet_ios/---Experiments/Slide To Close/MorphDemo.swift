import SwiftUI

// MARK: - Example Morphing HStack
struct MorphingGlassHStack: View {
	var body: some View {
		NativeGlassHost(
			tintColor: UIColor(
				red: 0 / 255,
				green: 111 / 255,
				blue: 235 / 255,
				alpha: 0.9
			),
			interactive: true,
			cornerRadius: 20
		) {
			HStack(spacing: 12) {
				Image(systemName: "sparkles")
					.font(.title2)
					.foregroundStyle(.white)

				//				Text("Native Morphing Glass")
				//					.font(.headline)
				//
				//				Spacer()
				//
				//				Text("Hold")
				//					.font(.caption)
				//					.padding(.horizontal, 10)
				//					.padding(.vertical, 4)
				//					.background(.ultraThinMaterial, in: Capsule())
			}
			//			.padding(.horizontal, 16)
			//			.padding(.vertical, 14)
		}
		.frame(width: 60, height: 48)
		.padding()
	}
}

// MARK: - Preview
#Preview {
	ZStack {
		LinearGradient(
			colors: [.black, .purple, .blue],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()

		MorphingGlassHStack()
	}
}
