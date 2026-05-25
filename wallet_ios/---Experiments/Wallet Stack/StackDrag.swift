import SwiftUI

// MARK: - Main View

struct WalletDragRevealSample: View {
	@State private var dragY: CGFloat = 0
	@State private var cardDragY: CGFloat = 0
	@State private var isExpanded = false
	@State private var frontWalletIndex = 0
	@State private var isCardSettling = false
	@State private var didSwitchCardDuringGesture = false
	
	private let collapsedPanelY: CGFloat = 120
	private let expandedPanelY: CGFloat = 342
	private let expandDistance: CGFloat = 176
	private let cardForwardSwapDistance: CGFloat = 210
	private let cardBackwardSwapDistance: CGFloat = 150
	
	private let wallets: [Wallet] = [
		.init(currency: "USD", amount: "108.74", flag: "🇺🇸"),
		.init(currency: "CFA", amount: "43.59", flag: "🇿🇦"),
		.init(currency: "INR", amount: "62.13", flag: "🇮🇳")
	]
	
	var body: some View {
		NavigationStack {
			ZStack(alignment: .top) {
				Color(red: 0.97, green: 0.95, blue: 0.92)
					.ignoresSafeArea()
				
				VStack(spacing: 0) {
					WalletAddCurrencyButton()
						.padding(.top, 12 * addCurrencyProgress)
						.opacity(addCurrencyProgress)
						.scaleEffect(0.82 + (0.18 * addCurrencyProgress), anchor: .center)
					Spacer()
				}
				.zIndex(1)
				
				WalletCardStack(
					wallets: orderedWallets,
					progress: progress,
					cardDragY: cardDragY,
					cardSwitchProgress: cardSwitchProgress,
					onCardDragChanged: updateCardDrag,
					onCardDragEnded: finishCardDrag
				)
					.padding(.horizontal, 12)
					.padding(.top, cardStackTopPadding)
					.zIndex(0)
				
				WalletContentPanel(progress: progress)
					.offset(y: panelOffsetY)
					.zIndex(2)
					.gesture(panelDrag)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.navigationTitle("")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				WalletToolbarContent()
			}
		}
	}
	
	// MARK: - Computed
	
	private var progress: CGFloat {
		let base = isExpanded ? expandDistance : 0
		let openAmount = base + dragY
		return max(0, min(1, openAmount / expandDistance))
	}
	
	private var panelOffsetY: CGFloat {
		collapsedPanelY + (expandedPanelY - collapsedPanelY) * progress
	}

	private var cardStackTopPadding: CGFloat {
		12 + (46 * progress)
	}

	private var addCurrencyProgress: CGFloat {
		smoothstep(edge0: 0.28, edge1: 0.78, value: progress)
	}

	private var cardSwitchProgress: CGFloat {
		max(0, min(1, abs(cardDragY) / cardSwapDistance))
	}

	private var cardSwapDistance: CGFloat {
		cardDragY < 0 ? effectiveBackwardSwapDistance : effectiveForwardSwapDistance
	}

	private var effectiveForwardSwapDistance: CGFloat {
		cardForwardSwapDistance - (48 * progress)
	}

	private var effectiveBackwardSwapDistance: CGFloat {
		cardBackwardSwapDistance - (32 * progress)
	}

	private func smoothstep(edge0: CGFloat, edge1: CGFloat, value: CGFloat) -> CGFloat {
		let x = max(0, min(1, (value - edge0) / (edge1 - edge0)))
		return x * x * (3 - 2 * x)
	}
	
	private var orderedWallets: [Wallet] {
		guard wallets.indices.contains(frontWalletIndex) else { return wallets }
		return Array(wallets[frontWalletIndex...] + wallets[..<frontWalletIndex])
	}
	
	// MARK: - Gesture
	
	private var panelDrag: some Gesture {
		DragGesture(minimumDistance: 8)
			.onChanged { value in
				let base = isExpanded ? expandDistance : 0
				let openAmount = max(0, min(expandDistance, base + value.translation.height))
				dragY = openAmount - base
			}
			.onEnded { value in
				let base = isExpanded ? expandDistance : 0
				let openAmount = max(0, min(expandDistance, base + value.translation.height))
				let predicted = max(0, min(expandDistance, base + value.predictedEndTranslation.height))
				let shouldExpand = openAmount > expandDistance * 0.45 || predicted > expandDistance * 0.7
				withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
					isExpanded = shouldExpand
					dragY = 0
				}
			}
	}
	
	private func updateCardDrag(_ value: DragGesture.Value) {
		guard wallets.count > 1, !isCardSettling, !didSwitchCardDuringGesture else { return }
		cardDragY = max(-effectiveBackwardSwapDistance, min(effectiveForwardSwapDistance, value.translation.height))
		
		let direction: CGFloat = cardDragY < 0 ? -1 : 1
		let distance = direction < 0 ? effectiveBackwardSwapDistance : effectiveForwardSwapDistance
		if abs(cardDragY) > distance * 0.62 {
			completeCardSwitch(direction: direction, distance: distance)
		}
	}
	
	private func finishCardDrag(_ value: DragGesture.Value) {
		if didSwitchCardDuringGesture {
			didSwitchCardDuringGesture = false
			return
		}
		
		guard wallets.count > 1, !isCardSettling else { return }
		
		let direction: CGFloat = cardDragY < 0 ? -1 : 1
		let distance = direction < 0 ? effectiveBackwardSwapDistance : effectiveForwardSwapDistance
		let predicted = max(-effectiveBackwardSwapDistance, min(effectiveForwardSwapDistance, value.predictedEndTranslation.height))
		let shouldSwitch = abs(cardDragY) > cardSwapDistance * 0.42 || abs(predicted) > cardSwapDistance * 0.66
		
		if shouldSwitch {
			completeCardSwitch(direction: direction, distance: distance)
		} else {
			withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
				cardDragY = 0
			}
		}
	}
	
	private func completeCardSwitch(direction: CGFloat, distance: CGFloat) {
		guard !isCardSettling else { return }
		isCardSettling = true
		didSwitchCardDuringGesture = true
		
		withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
			cardDragY = direction * distance
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
			var transaction = Transaction()
			transaction.disablesAnimations = true
			withTransaction(transaction) {
				if direction < 0 {
					frontWalletIndex = (frontWalletIndex - 1 + wallets.count) % wallets.count
				} else {
					frontWalletIndex = (frontWalletIndex + 1) % wallets.count
				}
				cardDragY = 0
				isCardSettling = false
			}
		}
	}
}

// MARK: - Preview

struct WalletDragRevealSample_Previews: PreviewProvider {
	static var previews: some View {
		WalletDragRevealSample()
			.previewDevice("iPhone 15 Pro")
	}
}
