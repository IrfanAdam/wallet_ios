import SwiftUI

// MARK: - Preview

#Preview("Scratch Reveal") {
	ScratchRevealDemo()
}

// MARK: - Demo

struct ScratchRevealDemo: View {
	var body: some View {
		VStack(spacing: 32) {
			Spacer()
			
			ScratchRevealCard(revealThreshold: 0.6) {
				VStack(spacing: 12) {
					Text("🎉 You Won!")
						.font(.largeTitle.bold())
					
					Text("Scratch 50% to reveal")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
			}
			.frame(width: 300, height: 180)
			
			Spacer()
		}
		.padding()
		.background(
			LinearGradient(
				colors: [Color(white: 0.94), Color(white: 0.88)],
				startPoint: .top,
				endPoint: .bottom
			)
			.ignoresSafeArea()
		)
	}
}
