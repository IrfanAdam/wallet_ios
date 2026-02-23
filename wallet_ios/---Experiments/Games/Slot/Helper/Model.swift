import SwiftUI
import Combine

final class SlotMachineViewModel: ObservableObject {

	@Published var isSpinning = false
	@Published var reels: [Int] = [0, 0, 0]

	private(set) var targetReels: [Int] = [0, 0, 0]

	let symbols = ["🍒", "🍋", "🍊", "🍉", "⭐️", "💎", "7️⃣"]
	let reelHeight: CGFloat = 120

	var isWinner: Bool {
		!isSpinning &&
		reels[0] == reels[1] &&
		reels[1] == reels[2]
	}

	func spin() {
		guard !isSpinning else { return }

		UIImpactFeedbackGenerator(style: .medium).impactOccurred()
		isSpinning = true

		let shouldWin = Int.random(in: 0..<4) == 0  // 25% chance

		if shouldWin {
			let winningIndex = Int.random(in: 0..<symbols.count)
			targetReels = [winningIndex, winningIndex, winningIndex]
		} else {
			targetReels = [
				Int.random(in: 0..<symbols.count),
				Int.random(in: 0..<symbols.count),
				Int.random(in: 0..<symbols.count)
			]
		}

		animateReel(index: 0, duration: 4.0)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.animateReel(index: 1, duration: 3.9)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.animateReel(index: 2, duration: 4.3)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
			self.isSpinning = false

			if self.isWinner {
				UINotificationFeedbackGenerator()
					.notificationOccurred(.success)
			}
		}
	}

	private func animateReel(index: Int, duration: Double) {
		let spinCount = 3
		let totalSteps = symbols.count * spinCount + targetReels[index]

		for step in 1...totalSteps {
			let delay = duration * Double(step) / Double(totalSteps)

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.05)) {
					self.reels[index] = step % self.symbols.count
				}

				if step % 2 == 0 {
					UIImpactFeedbackGenerator(style: .light)
						.impactOccurred()
				}
			}
		}
	}
}
