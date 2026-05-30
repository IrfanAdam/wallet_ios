import SwiftUI

struct WalletCardStack: View {
	let wallets: [Wallet]
	let progress: CGFloat
	let overCollapseProgress: CGFloat
	let cardDragY: CGFloat
	let cardSwitchProgress: CGFloat
	let onCardDragChanged: (DragGesture.Value) -> Void
	let onCardDragEnded: (DragGesture.Value) -> Void
	
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
						overCollapseProgress: overCollapseProgress,
						cardHeight: cardHeight,
						borderOpacity: borderOpacity(index)
					)
						.offset(
							x: cardX(index),
							y: cardY(index, cardHeight: cardHeight)
						)
						.scaleEffect(cardScale(index), anchor: .center)
						.rotation3DEffect(
							.degrees(cardRotation(index)),
							axis: (x: 1, y: 0, z: 0),
							anchor: .center,
							perspective: 0.65
						)
						.shadow(color: .black.opacity(cardShadow(index)), radius: 18, y: 10)
						.zIndex(cardZ(index))
						.allowsHitTesting(true)
						.highPriorityGesture(cardDrag)
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
		let current = slotY(index, cardHeight: cardHeight)
		let target = slotY(targetIndex(for: index), cardHeight: cardHeight)
		
		if dragDirection > 0, index == 0 {
			let repositionProgress = smoothstep(edge0: 0.58, edge1: 1, value: cardSwitchProgress)
			let visibleDragY = current + cardDragAmount
			return visibleDragY + (target - visibleDragY) * repositionProgress
		}

		if dragDirection < 0, index == wallets.count - 1 {
			let disappearProgress = smoothstep(edge0: 0.08, edge1: 0.52, value: cardSwitchProgress)
			let emergeProgress = smoothstep(edge0: 0.64, edge1: 1, value: cardSwitchProgress)
			let hiddenY = reverseHiddenY(cardHeight: cardHeight)
			let dippedY = current + (hiddenY - current) * disappearProgress
			return dippedY + (target - dippedY) * emergeProgress
		}
		
		let interpolated = current + (target - current) * slotTransitionProgress(for: index)
		return interpolated
	}
	
	private func slotY(_ index: Int, cardHeight: CGFloat) -> CGFloat {
		let collapsed = [0, -12, -24]
		let revealStep = cardHeight * WalletCardMetrics.revealStepRatio
		let expanded = wallets.indices.map { CGFloat(wallets.count - 1 - $0) * revealStep }
		let collapsedY = CGFloat(collapsed[index])
		return collapsedY + (expanded[index] - collapsedY) * progress
	}
	
	private func cardScale(_ index: Int) -> CGFloat {
		let current = slotScale(index)
		let target = slotScale(targetIndex(for: index))
		let base = current + (target - current) * slotTransitionProgress(for: index)
		
		if dragDirection < 0, index == wallets.count - 1 {
			let shrinkProgress = smoothstep(edge0: 0.08, edge1: 0.52, value: cardSwitchProgress)
			let emergeProgress = smoothstep(edge0: 0.64, edge1: 1, value: cardSwitchProgress)
			let hiddenScale = current * 0.88
			let dippedScale = current + (hiddenScale - current) * shrinkProgress
			return dippedScale + (target - dippedScale) * emergeProgress
		}
		
		if index == activeCardIndex {
			return base + 0.018 * (1 - abs((cardSwitchProgress * 2) - 1))
		}
		
		return base
	}
	
	private func slotScale(_ index: Int) -> CGFloat {
		let collapsed = [1.0, 0.96, 0.92]
		let expanded  = [1.0, 1.0,  1.0]
		return collapsed[index] + (expanded[index] - collapsed[index]) * progress
	}
	
	private func maxExpandedOffset(cardHeight: CGFloat) -> CGFloat {
		CGFloat(max(wallets.count - 1, 0)) * cardHeight * WalletCardMetrics.revealStepRatio
	}
	
	private func cardX(_ index: Int) -> CGFloat {
		guard index == activeCardIndex else { return 0 }
		return 3 * dragDirection * (1 - abs((cardSwitchProgress * 2) - 1))
	}
	
	private func cardRotation(_ index: Int) -> Double {
		guard index == activeCardIndex else {
			return Double(0.5 * cardSwitchProgress)
		}
		
		return Double(-3.5 * dragDirection * (1 - abs((cardSwitchProgress * 2) - 1)))
	}
	
	private func cardShadow(_ index: Int) -> Double {
		index == activeCardIndex ? Double(0.10 * (1 - cardSwitchProgress)) : Double(0.025 * cardSwitchProgress)
	}
	
	private func borderOpacity(_ index: Int) -> Double {
		if dragDirection < 0, index == wallets.count - 1 {
			return 1
		}
		
		return index == activeCardIndex ? 1 - Double(cardSwitchProgress * 0.58) : 1
	}
	
	private func cardZ(_ index: Int) -> Double {
		if dragDirection > 0, index == 0 {
			let isBehindPanel = cardSwitchProgress > 0.58
			return isBehindPanel ? 0 : Double(wallets.count + 1)
		}

		if dragDirection < 0, index == wallets.count - 1 {
			let isEmerging = cardSwitchProgress > 0.64
			return isEmerging ? Double(wallets.count + 1) : 0
		}
		
		return Double(wallets.count - targetIndex(for: index))
	}
	
	private func targetIndex(for index: Int) -> Int {
		if dragDirection < 0 {
			return index == wallets.count - 1 ? 0 : index + 1
		}
		
		return index == 0 ? wallets.count - 1 : index - 1
	}
	
	private func smoothstep(edge0: CGFloat, edge1: CGFloat, value: CGFloat) -> CGFloat {
		let x = max(0, min(1, (value - edge0) / (edge1 - edge0)))
		return x * x * (3 - 2 * x)
	}
	
	private var cardDrag: some Gesture {
		DragGesture(minimumDistance: 6)
			.onChanged(onCardDragChanged)
			.onEnded(onCardDragEnded)
	}

	private var cardDragAmount: CGFloat {
		abs(cardDragY)
	}

	private var dragDirection: CGFloat {
		cardDragY < 0 ? -1 : 1
	}

	private var activeCardIndex: Int {
		dragDirection < 0 ? wallets.count - 1 : 0
	}

	private func slotTransitionProgress(for index: Int) -> CGFloat {
		guard dragDirection < 0 else { return cardSwitchProgress }
		
		if index == 0 {
			return smoothstep(edge0: 0.18, edge1: 0.78, value: cardSwitchProgress)
		}
		
		if index == 1 {
			return smoothstep(edge0: 0.02, edge1: 0.64, value: cardSwitchProgress)
		}
		
		return smoothstep(edge0: 0.64, edge1: 1, value: cardSwitchProgress)
	}

	private func reverseHiddenY(cardHeight: CGFloat) -> CGFloat {
		let frontSlotY = slotY(0, cardHeight: cardHeight)
		let hiddenDepth = cardHeight * (0.72 + 0.18 * progress)
		return frontSlotY + hiddenDepth
	}
}

private enum WalletCardMetrics {
	static let aspectRatio: CGFloat = 85.60 / 53.98
	static let revealStepRatio: CGFloat = 0.30
	static let maxReferenceHeight: CGFloat = 345
}
