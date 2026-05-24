import SwiftUI

struct WalletCardStack: View {
	let wallets: [Wallet]
	let progress: CGFloat
	let frontIndex: Int
	let shufflePhase: WalletShufflePhase
	let onSwap: (WalletSwapDirection) -> Void
	
	var body: some View {
		GeometryReader { proxy in
			let cardWidth = proxy.size.width
			let cardHeight = cardWidth / WalletCardMetrics.aspectRatio
			let stackHeight = cardHeight + maxExpandedOffset(cardHeight: cardHeight)
			
			ZStack(alignment: .top) {
				ForEach(Array(wallets.enumerated()), id: \.element.id) { index, wallet in
					WalletCardView(
						wallet: wallet,
						isTopCard: index == 0,
						progress: progress,
						cardHeight: cardHeight,
						swapPosition: frontIndex + 1,
						swapCount: wallets.count,
						borderOpacity: borderOpacity(index),
						onSwap: onSwap
					)
						.offset(
							x: shuffleX(index),
							y: cardY(index, cardHeight: cardHeight) + shuffleY(index, cardHeight: cardHeight)
						)
						.scaleEffect(cardScale(index) * shuffleScale(index), anchor: .center)
						.rotation3DEffect(
							.degrees(shuffleRotation(index)),
							axis: (x: 1, y: 0, z: 0),
							anchor: .center,
							perspective: 0.65
						)
						.shadow(color: .black.opacity(shuffleShadow(index)), radius: 18, y: 10)
						.zIndex(shuffleZ(index))
				}
			}
			.frame(width: cardWidth, height: stackHeight, alignment: .top)
		}
		.frame(height: stackHeight, alignment: .top)
	}
	
	private var stackHeight: CGFloat {
		WalletCardMetrics.maxReferenceHeight
	}
	
	private func cardY(_ index: Int, cardHeight: CGFloat) -> CGFloat {
		let collapsed = [0, -12, -24]
		let revealStep = cardHeight * WalletCardMetrics.revealStepRatio
		let expanded = wallets.indices.map { CGFloat(wallets.count - 1 - $0) * revealStep }
		let collapsedY = CGFloat(collapsed[index])
		return collapsedY + (expanded[index] - collapsedY) * progress
	}
	
	private func cardScale(_ index: Int) -> CGFloat {
		let collapsed = [1.0, 0.96, 0.92]
		let expanded  = [1.0, 1.0,  1.0]
		return collapsed[index] + (expanded[index] - collapsed[index]) * progress
	}
	
	private func maxExpandedOffset(cardHeight: CGFloat) -> CGFloat {
		CGFloat(max(wallets.count - 1, 0)) * cardHeight * WalletCardMetrics.revealStepRatio
	}
	
	private func shuffleX(_ index: Int) -> CGFloat {
		guard case .departing = shufflePhase, index == 0 else { return 0 }
		return 2
	}
	
	private func shuffleY(_ index: Int, cardHeight: CGFloat) -> CGFloat {
		switch shufflePhase {
		case .idle:
			return 0
		case .departing:
			if index == 0 {
				return cardHeight * 0.075
			}
			return CGFloat(index) * -4
		case .arriving:
			if index == 0 {
				return -cardHeight * 0.055
			}
			return CGFloat(index) * 3
		}
	}
	
	private func shuffleScale(_ index: Int) -> CGFloat {
		switch shufflePhase {
		case .idle:
			return 1
		case .departing:
			return index == 0 ? 1.018 : 0.99
		case .arriving:
			return index == 0 ? 0.985 : 1.005
		}
	}
	
	private func shuffleRotation(_ index: Int) -> Double {
		switch shufflePhase {
		case .idle:
			return 0
		case .departing:
			return index == 0 ? -2.5 : 0.6
		case .arriving:
			return index == 0 ? 1.5 : 0
		}
	}
	
	private func shuffleShadow(_ index: Int) -> Double {
		switch shufflePhase {
		case .departing:
			return index == 0 ? 0.10 : 0.03
		case .arriving:
			return index == 0 ? 0.07 : 0.02
		case .idle:
			return 0
		}
	}
	
	private func borderOpacity(_ index: Int) -> Double {
		switch shufflePhase {
		case .idle:
			return 1
		case .departing, .arriving:
			return index == 0 ? 0.42 : 0.28
		}
	}
	
	private func shuffleZ(_ index: Int) -> Double {
		let base = Double(wallets.count - index)
		
		switch shufflePhase {
		case .departing:
			return index == 0 ? base + 10 : base
		case .arriving:
			return index == 0 ? base + 8 : base
		case .idle:
			return base
		}
	}
}

private enum WalletCardMetrics {
	static let aspectRatio: CGFloat = 85.60 / 53.98
	static let revealStepRatio: CGFloat = 0.45
	static let maxReferenceHeight: CGFloat = 345
}
