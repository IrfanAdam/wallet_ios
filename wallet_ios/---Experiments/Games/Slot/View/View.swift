import SwiftUI

struct SlotMachineView: View {

	@StateObject private var viewModel = SlotMachineViewModel()

	var body: some View {
		VStack(spacing: 40) {

			Text("Slot Machine")
				.font(.system(size: 36, weight: .bold, design: .rounded))
				.foregroundStyle(.black)

			SlotMachineBody(
				reels: viewModel.reels,
				symbols: viewModel.symbols,
				isSpinning: viewModel.isSpinning,
				reelHeight: viewModel.reelHeight
			)

			if viewModel.isWinner {
				WinnerBanner()
					.transition(.scale.combined(with: .opacity))
			}

			SpinButton(
				isSpinning: viewModel.isSpinning,
				action: viewModel.spin
			)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

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
