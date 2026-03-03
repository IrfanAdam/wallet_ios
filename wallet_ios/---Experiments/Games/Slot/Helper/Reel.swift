import SwiftUI

struct ReelView: View {

	let symbols: [String]
	let currentIndex: Int
	let isSpinning: Bool
	let reelHeight: CGFloat
	
	@State private var wasSpinning = false
	private let sounds = SlotSoundEngine.shared

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
		.onChange(of: isSpinning) { _, spinning in
			if spinning {
				sounds.startSpinLoop()
			} else {
				// Delay stop to match reel settling
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
					sounds.stopSpinLoop()
				}
			}
		}
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
