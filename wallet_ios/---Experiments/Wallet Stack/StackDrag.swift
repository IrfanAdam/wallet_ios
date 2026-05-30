import SwiftUI

// MARK: - Main View

enum PanelState {
	case compact
	case collapsed
	case dismissed
}

struct WalletDragRevealSample: View {
	@State private var dragY: CGFloat = 0
	@State private var cardDragY: CGFloat = 0
	@State private var panelState: PanelState = .collapsed
	@State private var screenHeight: CGFloat = 852
	@State private var frontWalletIndex = 0
	@State private var isCardSettling = false
	@State private var didSwitchCardDuringGesture = false
	
	private let compactPanelY: CGFloat = 150
	private let collapsedPanelY: CGFloat = 230
	private let cardForwardSwapDistance: CGFloat = 210
	private let cardBackwardSwapDistance: CGFloat = 150
	
	private let wallets: [Wallet] = [
		.init(currency: "USD", amount: "108.74", flag: "🇺🇸"),
		.init(currency: "CFA", amount: "43.59", flag: "🇿🇦"),
		.init(currency: "INR", amount: "62.13", flag: "🇮🇳")
	]
	
	var body: some View {
		NavigationStack {
			GeometryReader { outerProxy in
				let currentHeight = outerProxy.size.height > 0 ? outerProxy.size.height : 852
				
				ZStack(alignment: .top) {
					Color(red: 0.97, green: 0.95, blue: 0.92)
						.ignoresSafeArea()
						.contentShape(Rectangle())
						.gesture(
							DragGesture(minimumDistance: 8)
								.onChanged { value in
									guard panelState == .dismissed else { return }
									dragY = min(0, value.translation.height)
								}
								.onEnded { value in
									guard panelState == .dismissed else { return }
									let baseOffset = screenHeight
									let predictedOffset = baseOffset + value.predictedEndTranslation.height
									
									var targetState: PanelState = .dismissed
									if predictedOffset < screenHeight - 120 {
										if predictedOffset < collapsedPanelY + 40 {
											targetState = .compact
										} else {
											targetState = .collapsed
										}
									}
									
									withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
										panelState = targetState
										dragY = 0
									}
								}
						)
					
					VStack(spacing: 0) {
						WalletAddCurrencyButton()
							.padding(.top, 24 * addCurrencyProgress)
							.opacity(addCurrencyProgress)
							.scaleEffect(0.82 + (0.18 * addCurrencyProgress), anchor: .center)
						Spacer()
					}
					.zIndex(1)
					
					WalletCardStack(
						wallets: orderedWallets,
						progress: progress,
						overCollapseProgress: overCollapseProgress,
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
					
					if panelState == .dismissed {
						VStack {
							Spacer()
							Color.clear
								.frame(height: 80)
								.contentShape(Rectangle())
								.gesture(
									DragGesture(minimumDistance: 8)
										.onChanged { value in
											dragY = min(0, value.translation.height)
										}
										.onEnded { value in
											let baseOffset = screenHeight
											let predictedOffset = baseOffset + value.predictedEndTranslation.height
											
											var targetState: PanelState = .dismissed
											if predictedOffset < screenHeight - 120 {
												if predictedOffset < collapsedPanelY + 40 {
													targetState = .compact
												} else {
													targetState = .collapsed
												}
											}
											
											withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
												panelState = targetState
												dragY = 0
											}
										}
								)
						}
						.ignoresSafeArea()
						.zIndex(3)
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.navigationTitle("")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					WalletToolbarContent()
				}
				.onAppear {
					screenHeight = currentHeight
				}
				.onChange(of: currentHeight) { oldValue, newValue in
					screenHeight = newValue
				}
			}
		}
	}
	
	// MARK: - Computed
	
	private var progress: CGFloat {
		let base = stableOffset(for: panelState)
		let currentOffset = base + dragY
		let clampedOffset = max(collapsedPanelY, min(screenHeight, currentOffset))
		return (clampedOffset - collapsedPanelY) / (screenHeight - collapsedPanelY)
	}
	
	private var overCollapseProgress: CGFloat {
		let base = stableOffset(for: panelState)
		let currentOffset = base + dragY
		let overCollapseAmount = max(0, collapsedPanelY - currentOffset)
		return min(1, overCollapseAmount / (collapsedPanelY - compactPanelY))
	}
	
	private var panelOffsetY: CGFloat {
		let base = stableOffset(for: panelState)
		return max(compactPanelY, min(screenHeight, base + dragY))
	}

	private var cardStackTopPadding: CGFloat {
		let base = 32 + (40 * progress)
		return base - (12 * overCollapseProgress)
	}

	private var addCurrencyProgress: CGFloat {
		smoothstep(edge0: 0.32, edge1: 0.78, value: progress)
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
	
	private func stableOffset(for state: PanelState) -> CGFloat {
		switch state {
		case .compact:
			return compactPanelY
		case .collapsed:
			return collapsedPanelY
		case .dismissed:
			return screenHeight
		}
	}
	
	// MARK: - Gesture
	
	private var panelDrag: some Gesture {
		DragGesture(minimumDistance: 8)
			.onChanged { value in
				dragY = value.translation.height
			}
			.onEnded { value in
				let baseOffset = stableOffset(for: panelState)
				let predictedOffset = baseOffset + value.predictedEndTranslation.height
				
				var targetState: PanelState = panelState
				
				switch panelState {
				case .compact:
					if predictedOffset > (compactPanelY + collapsedPanelY) / 2 {
						if predictedOffset > (collapsedPanelY + screenHeight) * 0.45 {
							targetState = .dismissed
						} else {
							targetState = .collapsed
						}
					} else {
						targetState = .compact
					}
					
				case .collapsed:
					if predictedOffset < (compactPanelY + collapsedPanelY) / 2 {
						targetState = .compact
					} else if predictedOffset > (collapsedPanelY + screenHeight) * 0.45 {
						targetState = .dismissed
					} else {
						targetState = .collapsed
					}
					
				case .dismissed:
					if predictedOffset < screenHeight - 120 {
						if predictedOffset < collapsedPanelY + 40 {
							targetState = .compact
						} else {
							targetState = .collapsed
						}
					} else {
						targetState = .dismissed
					}
				}
				
				withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
					panelState = targetState
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
