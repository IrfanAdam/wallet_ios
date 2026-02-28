import SwiftUI

struct SpinButton: View {

	let isSpinning: Bool
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(isSpinning ? "SPINNING..." : "SPIN")
				.font(.system(size: 24, weight: .bold, design: .rounded))
				.foregroundStyle(.white)
				.frame(width: 200, height: 60)
				.background {
					Capsule()
						.fill(
							LinearGradient(
								colors: isSpinning
								? [Color.gray, Color.gray.opacity(0.7)]
								: [Color.green, Color.green.opacity(0.7)],
								startPoint: .top,
								endPoint: .bottom
							)
						)
						.shadow(color: .black.opacity(0.3), radius: 8, y: 4)
				}
		}
		.disabled(isSpinning)
		.scaleEffect(isSpinning ? 0.95 : 1.0)
		.animation(.spring(response: 0.3), value: isSpinning)
	}
}
