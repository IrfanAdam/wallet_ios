import SwiftUI

struct ReelView: View {

	let symbols: [String]
	let currentIndex: Int
	let isSpinning: Bool
	let reelHeight: CGFloat

	var body: some View {
		ZStack {

			RoundedRectangle(cornerRadius: 24)
				.fill(Color.white)
				.frame(width: 90, height: reelHeight)

			RoundedRectangle(cornerRadius: 24)
				.strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
				.frame(width: 90, height: reelHeight)

			Text(symbols[currentIndex])
				.font(.system(size: 50))
				.id(currentIndex)
				.transition(.push(from: .top))
		}
		.clipped(antialiased: true)
	}
}

struct WinnerBanner: View {
	var body: some View {
		Text("🎉 WINNER! 🎉")
			.font(.system(size: 28, weight: .heavy, design: .rounded))
			.foregroundStyle(
				LinearGradient(
					colors: [.yellow, .orange],
					startPoint: .leading,
					endPoint: .trailing
				)
			)
	}
}
