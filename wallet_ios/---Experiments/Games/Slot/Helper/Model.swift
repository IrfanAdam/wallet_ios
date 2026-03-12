import SwiftUI
import Combine
import AudioToolbox

final class SlotMachineViewModel: ObservableObject {

	@Published var isSpinning = false
	@Published var reels: [Int] = [0, 0, 0]

	private(set) var targetReels: [Int] = [0, 0, 0]

	let symbols = ["🍒", "🍋", "🍊", "🍉", "⭐️", "💎", "7️⃣"]
	let reelHeight: CGFloat = 120

	init() {
		// Start in a random non-winning state
		var initial: [Int]
		repeat {
			initial = [
				Int.random(in: 0..<symbols.count),
				Int.random(in: 0..<symbols.count),
				Int.random(in: 0..<symbols.count)
			]
		} while initial[0] == initial[1] && initial[1] == initial[2]

		self.reels = initial
		self.targetReels = initial
	}

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
		let reel1Duration = 4.0
		let reel2Duration = 3.9
		let reel3Duration = 4.3

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

		animateReel(index: 0, duration: reel1Duration)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.animateReel(index: 1, duration: reel2Duration)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.animateReel(index: 2, duration: reel3Duration)
		}

		let finalCompletion = 0.6 + reel3Duration

		DispatchQueue.main.asyncAfter(deadline: .now() + finalCompletion + 0.05) {
			self.isSpinning = false

			if self.isWinner {
				UINotificationFeedbackGenerator()
					.notificationOccurred(.success)

				AudioServicesPlaySystemSound(1025)
			} else {

				UIImpactFeedbackGenerator(style: .light)
					.impactOccurred(intensity: 0.6)

				AudioServicesPlaySystemSound(1026)
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

	func runIntro() {
		// 1. Pre-existing initial/target logic
		let start = [0, 0, 0]
		let target = reels

		// 2. Start aligned and spin ruffle sound
		reels = start
		SlotSoundEngine.shared.startSpinLoop()

		let introDuration = 0.42

		for index in 0..<3 {
			let steps = (target[index] - start[index] + symbols.count) % symbols.count
			guard steps > 0 else { continue }

			for step in 1...steps {
				let delay = introDuration * Double(step) / Double(steps)
				DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
					withAnimation(.linear(duration: 0.05)) {
						self.reels[index] = (start[index] + step) % self.symbols.count
					}
					if step % 2 == 0 {
						// light mechanical tick
						UIImpactFeedbackGenerator(style: .light).impactOccurred()
					}
				}
			}
		}

		// 3. Stop ruffle after intro settles
		DispatchQueue.main.asyncAfter(deadline: .now() + introDuration + 0.1) {
			SlotSoundEngine.shared.stopSpinLoop()
		}
	}
}
