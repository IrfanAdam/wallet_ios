import SwiftUI

struct SlotMachineBody: View {

	let reels: [Int]
	let symbols: [String]
	let isSpinning: Bool
	let reelHeight: CGFloat
	let onLeverPulled: () -> Void

	var body: some View {
		VStack(spacing: 0) {
			HStack(alignment: .center, spacing: 12) {

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

				SlotLever(
					reelHeight: reelHeight,
					isSpinning: isSpinning,
					onPulled: onLeverPulled
				)
			}
			.padding(.horizontal, 20)
			.padding(.vertical, 30)
		}
		
	}
}
