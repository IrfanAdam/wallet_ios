import SwiftUI

struct SlotMachineView: View {
	
	@StateObject private var viewModel = SlotMachineViewModel()
	
	var body: some View {
		VStack(spacing: 40) {
			SlotMachineBody(
				reels: viewModel.reels,
				symbols: viewModel.symbols,
				isSpinning: viewModel.isSpinning,
				reelHeight: viewModel.reelHeight,
				onLeverPulled: viewModel.spin
			)
			
			if viewModel.isWinner {
				WinnerBanner()
					.transition(.scale.combined(with: .opacity))
			}
			
			//			SpinButton(
			//				isSpinning: viewModel.isSpinning,
			//				action: viewModel.spin
			//			)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}
