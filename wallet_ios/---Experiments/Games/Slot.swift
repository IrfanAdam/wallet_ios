import SwiftUI

#Preview {
	SlotMachineDemo()
}

struct SlotMachineDemo: View {
	var body: some View {
		ZStack {
			LinearGradient(
				colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			SlotMachine()
		}
	}
}

struct SlotMachine: View {
	@State private var isSpinning = false
	@State private var reels: [Int] = [0, 0, 0]
	@State private var targetReels: [Int] = [0, 0, 0]

	private let symbols = ["🍒", "🍋", "🍊", "🍉", "⭐️", "💎", "7️⃣"]
	private let reelHeight: CGFloat = 80

	var body: some View {
		VStack(spacing: 40) {
			Text("Slot Machine")
				.font(.system(size: 36, weight: .bold, design: .rounded))
				.foregroundStyle(.white)

			// Slot machine body
			VStack(spacing: 0) {
				// Top decoration
				Rectangle()
					.fill(LinearGradient(
						colors: [Color.yellow, Color.orange],
						startPoint: .leading,
						endPoint: .trailing
					))
					.frame(height: 20)

				// Reels container
				HStack(spacing: 12) {
					ForEach(0..<3, id: \.self) { index in
						ReelView(
							symbols: symbols,
							currentIndex: reels[index],
							isSpinning: isSpinning,
							reelHeight: reelHeight
						)
					}
				}
				.padding(.horizontal, 20)
				.padding(.vertical, 30)
				.background {
					RoundedRectangle(cornerRadius: 0)
						.fill(Color.red.gradient)
				}

				// Bottom decoration
				Rectangle()
					.fill(LinearGradient(
						colors: [Color.orange, Color.yellow],
						startPoint: .leading,
						endPoint: .trailing
					))
					.frame(height: 20)
			}
			.background {
				RoundedRectangle(cornerRadius: 20)
					.fill(Color.red.opacity(0.3))
					.shadow(color: .black.opacity(0.3), radius: 20)
			}
			.overlay {
				RoundedRectangle(cornerRadius: 20)
					.strokeBorder(
						LinearGradient(
							colors: [.yellow, .orange, .yellow],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						),
						lineWidth: 4
					)
			}

			// Result message
			if !isSpinning && reels[0] == reels[1] && reels[1] == reels[2] {
				Text("🎉 WINNER! 🎉")
					.font(.system(size: 28, weight: .heavy, design: .rounded))
					.foregroundStyle(
						LinearGradient(
							colors: [.yellow, .orange],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.transition(.scale.combined(with: .opacity))
			}

			// Spin button
			Button {
				spin()
			} label: {
				Text(isSpinning ? "SPINNING..." : "SPIN")
					.font(.system(size: 24, weight: .bold, design: .rounded))
					.foregroundStyle(.white)
					.frame(width: 200, height: 60)
					.background {
						Capsule()
							.fill(
								LinearGradient(
									colors: isSpinning ?
									[Color.gray, Color.gray.opacity(0.7)] :
										[Color.green, Color.green.opacity(0.7)],
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
		.padding()
	}

	private func spin() {
		guard !isSpinning else { return }

		// Haptic feedback
		let impact = UIImpactFeedbackGenerator(style: .medium)
		impact.impactOccurred()

		isSpinning = true

		// Generate random targets
		targetReels = [
			Int.random(in: 0..<symbols.count),
			Int.random(in: 0..<symbols.count),
			Int.random(in: 0..<symbols.count)
		]

		// Animate each reel with staggered timing
		animateReel(index: 0, duration: 2.0)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			animateReel(index: 1, duration: 2.3)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			animateReel(index: 2, duration: 2.6)
		}

		// Check for win after all reels stop
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
			isSpinning = false

			if targetReels[0] == targetReels[1] && targetReels[1] == targetReels[2] {
				let success = UINotificationFeedbackGenerator()
				success.notificationOccurred(.success)
			}
		}
	}

	private func animateReel(index: Int, duration: Double) {
		let spinCount = 3 // Number of full rotations
		let totalSteps = symbols.count * spinCount + targetReels[index]

		for step in 1...totalSteps {
			let delay = duration * Double(step) / Double(totalSteps)

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(.linear(duration: 0.05)) {
					reels[index] = step % symbols.count
				}

				// Tick sound effect via haptic on each step
				if step % 2 == 0 {
					let impact = UIImpactFeedbackGenerator(style: .light)
					impact.impactOccurred()
				}
			}
		}
	}
}

struct ReelView: View {
	let symbols: [String]
	let currentIndex: Int
	let isSpinning: Bool
	let reelHeight: CGFloat

	var body: some View {
		ZStack {
			// Reel background
			RoundedRectangle(cornerRadius: 12)
				.fill(Color.white)
				.frame(width: 90, height: reelHeight)

			// Shadow inset effect
			RoundedRectangle(cornerRadius: 12)
				.strokeBorder(Color.black.opacity(0.2), lineWidth: 2)
				.frame(width: 90, height: reelHeight)

			// Symbol
			Text(symbols[currentIndex])
				.font(.system(size: 50))
				.id(currentIndex) // Force refresh
				.transition(.push(from: .top))
		}
	}
}
