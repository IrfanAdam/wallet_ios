import SwiftUI

struct AnimatedToolbarDemo: View {
	@State private var expanded = false

	var body: some View {
		NavigationStack {
			VStack {
				Text("Toolbar Width Animation Demo")
					.font(.title2)
					.padding()

				Spacer()
			}
			.navigationTitle("Home")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					AnimatedToolbarButton(expanded: expanded)
				}
			}
			.onAppear {
				// Animate after appear
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
					withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
						expanded = true
					}
				}
			}
		}
	}
}

struct AnimatedToolbarButton: View {
	let expanded: Bool

	var body: some View {
		HStack(spacing: 8) {
			Image(systemName: "star.fill")

			if expanded {
				Text("Review")
					.transition(.opacity.combined(with: .move(edge: .trailing)))
			}
		}
		.foregroundStyle(.white)
		.padding(.horizontal, expanded ? 14 : 10)
		.frame(height: 36)
		.background(
			Capsule()
				.fill(Color.blue)
		)
		.animation(.spring(response: 0.5, dampingFraction: 0.8), value: expanded)
	}
}

#Preview {
	AnimatedToolbarDemo()
}
