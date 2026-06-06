import SwiftUI

// MARK: - Main View

enum PanelState {
	case compact
	case collapsed
	case dismissed
}

enum TransitionPhase: String {
	case group
	case fadingOutGroup
	case movingToHero
	case emergingCurrencies
	case expanded
	case collapsingCurrencies
	case movingToGroup
	case fadingInGroup
}

struct WalletDragRevealSample: View {
	@State private var dragY: CGFloat = 0
	@State private var cardDragY: CGFloat = 0
	@State private var panelState: PanelState = .collapsed
	@State private var screenHeight: CGFloat = 960
	@State private var screenWidth: CGFloat = 393
	@State private var frontWalletIndex = 0
	@State private var isCardSettling = false
	@State private var didSwitchCardDuringGesture = false
	@State private var selectedAccountIndex = 0
	@State private var isAccountExpanded = false
	@State private var toolbarTitle = "Main Group"
	@State private var toolbarSubtitle = "Total CFA 14,0008"
	@State private var isPanelLoading = false
	
	// Transition State Variables
	@State private var transitionPhase: TransitionPhase = .group
	@State private var tappedGroupIndex: Int? = nil
	@State private var tappedCardOffset: CGFloat = 0.0
	@State private var tappedCardScale: CGFloat = 1.0
	@State private var tappedCardOpacity: Double = 1.0
	@State private var otherCardsOpacity: Double = 1.0
	@State private var otherCardsOffsetShift: CGFloat = 0.0
	@State private var otherCardsDispersalProgress: CGFloat = 0.0
	@State private var currencyRevealProgress: CGFloat = 1.0
	@State private var transitionCarrierAccount: WalletAccount? = nil
	@State private var transitionCarrierOffset: CGFloat = 0.0
	@State private var transitionCarrierScale: CGFloat = 1.0
	@State private var transitionCarrierOpacity: Double = 0.0
	@State private var stackTopCardOpacity: Double = 1.0
	@State private var originalSelectedAccountIndex: Int = 0
	
	private let cardPadding: CGFloat = 16
	private let stackHorizontalPadding: CGFloat = 12
	private let cardForwardSwapDistance: CGFloat = 210
	private let cardBackwardSwapDistance: CGFloat = 150
	
	private var cardWidth: CGFloat {
		screenWidth - (stackHorizontalPadding * 2)
	}
	
	private var cardHeight: CGFloat {
		cardWidth / (85.60 / 53.98)
	}
	
	private var collapsedPanelY: CGFloat {
		cardStackBaseTopPadding + cardHeight - cardPadding - 60
	}
	
	private var compactPanelY: CGFloat {
		collapsedPanelY - 70
	}
	
	private var cardStackBaseTopPadding: CGFloat {
		32
	}
	
	private let accounts: [WalletAccount] = [
		.init(
			name: "Main Account",
			badge: "Default",
			totalCurrency: "CFA",
			totalAmount: "13,0008.74",
			tint: Color(red: 0.02, green: 0.29, blue: 0.62),
			rewardsCount: 3,
			pendingCount: 2,
			upcomingCount: 12,
			wallets: [
				.init(currency: "USD", amount: "108.74", flag: "🇺🇸"),
				.init(currency: "CFA", amount: "43.59", flag: "🇿🇦"),
				.init(currency: "INR", amount: "62.13", flag: "🇮🇳")
			],
			transactions: [
				.init(title: "Split Payment Recieved", subtitle: "from Dilip Kumar", date: "7 Dec, 04:00pm", amount: "+ INR 65", icon: "arrow.down.left", avatar: "DK"),
				.init(title: "Added Money", subtitle: "to Main Account INR wallet", date: "7 Dec, 03:18pm", amount: "+ INR 330", icon: "plus", avatar: "IN"),
				.init(title: "Transfered to Bank", subtitle: "from CFA balance", date: "7 Dec, 01:42pm", amount: "- CFA 10,310", icon: "building.columns", avatar: "CF"),
				.init(title: "Mobile Top Up", subtitle: "Airtel Africa from USD wallet", date: "7 Dec, 12:10pm", amount: "- USD 3.12", icon: "iphone", avatar: "AT")
			]
		),
		.init(
			name: "Travel Account",
			badge: "Shared",
			totalCurrency: "USD",
			totalAmount: "2,840.12",
			tint: Color(red: 0.10, green: 0.58, blue: 0.16),
			rewardsCount: 1,
			pendingCount: 1,
			upcomingCount: 4,
			wallets: [
				.init(currency: "USD", amount: "840.12", flag: "🇺🇸"),
				.init(currency: "EUR", amount: "430.00", flag: "🇪🇺"),
				.init(currency: "CFA", amount: "91.42", flag: "🇿🇦")
			],
			transactions: [
				.init(title: "Hotel Hold Released", subtitle: "Blue Orchid Suites", date: "8 Dec, 11:24am", amount: "+ USD 180", icon: "bed.double", avatar: "HO"),
				.init(title: "Currency Exchange", subtitle: "Travel USD to EUR", date: "8 Dec, 09:12am", amount: "- USD 250", icon: "shuffle", avatar: "FX"),
				.init(title: "Dinner Split", subtitle: "from Ama Mensah", date: "7 Dec, 09:40pm", amount: "+ EUR 48", icon: "fork.knife", avatar: "AM"),
				.init(title: "Taxi Payment", subtitle: "Airport transfer", date: "7 Dec, 06:25pm", amount: "- USD 18", icon: "car", avatar: "TX")
			]
		),
		.init(
			name: "Savings Pot",
			badge: "Locked",
			totalCurrency: "INR",
			totalAmount: "98,400.00",
			tint: Color(red: 0.55, green: 0.34, blue: 0.14),
			rewardsCount: 0,
			pendingCount: 1,
			upcomingCount: 3,
			wallets: [
				.init(currency: "INR", amount: "98,400.00", flag: "🇮🇳"),
				.init(currency: "USD", amount: "240.18", flag: "🇺🇸"),
				.init(currency: "CFA", amount: "63.40", flag: "🇿🇦")
			],
			transactions: [
				.init(title: "Monthly Save", subtitle: "from Main Account", date: "5 Dec, 08:00am", amount: "+ INR 8,000", icon: "plus", avatar: "MS"),
				.init(title: "Goal Boost", subtitle: "round-up transfer", date: "3 Dec, 06:18pm", amount: "+ INR 420", icon: "sparkles", avatar: "GB"),
				.init(title: "Interest Added", subtitle: "monthly earnings", date: "1 Dec, 12:00am", amount: "+ INR 310", icon: "percent", avatar: "IA"),
				.init(title: "Locked Transfer", subtitle: "scheduled savings rule", date: "30 Nov, 08:00am", amount: "+ INR 2,500", icon: "lock", avatar: "LT")
			]
		)
	]
	
	private let groupTransactions: [WalletTransaction] = [
		.init(title: "Travel Account Spend", subtitle: "Taxi Payment from USD wallet", date: "8 Dec, 06:25pm", amount: "- USD 18", icon: "car", avatar: "TR"),
		.init(title: "Savings Pot Deposit", subtitle: "monthly save from Main Account", date: "8 Dec, 08:00am", amount: "+ INR 8,000", icon: "lock", avatar: "SV"),
		.init(title: "Main Account Received", subtitle: "split payment from Dilip Kumar", date: "7 Dec, 04:00pm", amount: "+ INR 65", icon: "arrow.down.left", avatar: "MA"),
		.init(title: "Currency Exchange", subtitle: "Travel Account USD to EUR", date: "7 Dec, 09:12am", amount: "- USD 250", icon: "shuffle", avatar: "FX"),
		.init(title: "Bank Transfer", subtitle: "Main Account CFA balance", date: "6 Dec, 01:42pm", amount: "- CFA 10,310", icon: "building.columns", avatar: "BK"),
		.init(title: "Interest Added", subtitle: "Savings Pot monthly earnings", date: "1 Dec, 12:00am", amount: "+ INR 310", icon: "percent", avatar: "IA")
	]
	
	var body: some View {
		NavigationStack {
			GeometryReader { outerProxy in
				let currentHeight = outerProxy.size.height > 0 ? outerProxy.size.height : 852
				let currentWidth = outerProxy.size.width > 0 ? outerProxy.size.width : 393
				let liveCardWidth = currentWidth - (stackHorizontalPadding * 2)
				let liveCardHeight = liveCardWidth / (85.60 / 53.98)
				
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
					.opacity(isAccountExpanded ? 1 : 0)
					.zIndex(1)
					
					ZStack(alignment: .top) {
						WalletAccountGroupView(
							accounts: orderedAccounts,
							selectedAccountID: selectedAccount.id,
							onSelect: selectAccount,
							tappedIndex: tappedGroupIndex,
							tappedCardOffset: tappedCardOffset,
							tappedCardScale: tappedCardScale,
							otherCardsOpacity: otherCardsOpacity,
							otherCardsOffsetShift: otherCardsOffsetShift
						)
						.opacity(isAccountExpanded ? 0 : 1)
						.animation(nil, value: isAccountExpanded)
						.allowsHitTesting(!isAccountExpanded)
						
						WalletCardStack(
							wallets: orderedWallets,
							progress: progress,
							overCollapseProgress: overCollapseProgress,
							cardDragY: cardDragY,
							cardSwitchProgress: cardSwitchProgress,
							onCardDragChanged: updateCardDrag,
							onCardDragEnded: finishCardDrag,
							tintColor: selectedAccount.tint,
							revealProgress: (transitionPhase == .emergingCurrencies || transitionPhase == .collapsingCurrencies) ? currencyRevealProgress : 1.0,
							topCardOpacity: stackTopCardOpacity
						)
						.opacity(isAccountExpanded ? 1 : 0)
						.animation(nil, value: isAccountExpanded)
						.allowsHitTesting(isAccountExpanded)
						
						if let transitionCarrierAccount {
							WalletAccountGroupCard(account: transitionCarrierAccount, cardHeight: liveCardHeight)
								.offset(y: transitionCarrierOffset)
								.scaleEffect(transitionCarrierScale, anchor: .top)
								.opacity(transitionCarrierOpacity)
								.allowsHitTesting(false)
								.zIndex(200)
						}
					}
					.padding(.horizontal, 12)
					.padding(.top, cardStackTopPadding)
					.zIndex(1)
					
					WalletContentPanel(progress: progress, panelData: panelData, isLoading: isPanelLoading)
						.offset(y: panelOffsetY)
						.zIndex(2)
						.simultaneousGesture(panelDrag)
						.scrollDisabled(dragY > 4)
					
					
					if panelState == .dismissed {
						VStack {
							Spacer()
							Color.clear
								.frame(height: 80)
								.contentShape(Rectangle())
								.simultaneousGesture(
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
					WalletToolbarContent(
						title: toolbarTitle,
						subtitle: toolbarSubtitle,
						onBack: handleBack
					)
				}
				.onAppear {
					screenHeight = currentHeight
					screenWidth = currentWidth
				}
				.onChange(of: currentHeight) { oldValue, newValue in
					screenHeight = newValue
				}
				.onChange(of: currentWidth) { oldValue, newValue in
					screenWidth = newValue
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
		let base = cardStackBaseTopPadding + (40 * progress)
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

	private func groupCardY(_ index: Int) -> CGFloat {
		let collapsed = [0, -12, -24]
		guard collapsed.indices.contains(index) else { return 0 }
		return CGFloat(collapsed[index])
	}
	
	private func groupCardScale(_ index: Int) -> CGFloat {
		let collapsed = [1.0, 0.96, 0.92]
		guard collapsed.indices.contains(index) else { return 1.0 }
		return collapsed[index]
	}
	
	private var orderedWallets: [Wallet] {
		let wallets = selectedAccount.wallets
		guard wallets.indices.contains(frontWalletIndex) else { return wallets }
		return Array(wallets[frontWalletIndex...] + wallets[..<frontWalletIndex])
	}
	
	private var selectedAccount: WalletAccount {
		accounts[selectedAccountIndex]
	}
	
	private var panelData: WalletPanelData {
		if isAccountExpanded {
			return WalletPanelData(
				rewardsCount: selectedAccount.rewardsCount,
				pendingCount: selectedAccount.pendingCount,
				upcomingCount: selectedAccount.upcomingCount,
				transactions: selectedAccount.transactions
			)
		}
		
		return WalletPanelData(
			rewardsCount: accounts.reduce(0) { $0 + $1.rewardsCount },
			pendingCount: accounts.reduce(0) { $0 + $1.pendingCount },
			upcomingCount: accounts.reduce(0) { $0 + $1.upcomingCount },
			transactions: groupTransactions
		)
	}
	
	private var orderedAccounts: [WalletAccount] {
		guard accounts.indices.contains(selectedAccountIndex) else { return accounts }
		return Array(accounts[selectedAccountIndex...] + accounts[..<selectedAccountIndex])
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
				let dragDistance = value.translation.height
				
				var targetState: PanelState = panelState
				
				switch panelState {
				case .compact:
					// Must drag down a meaningful amount to leave compact
					if dragDistance > 40 {
						// Only dismiss if flung very hard past collapsed
						if predictedOffset > collapsedPanelY + 120 {
							targetState = .dismissed
						} else {
							targetState = .collapsed
						}
					} else {
						targetState = .compact
					}
					
				case .collapsed:
					if predictedOffset < compactPanelY + 60 {
						// Only go compact if dragged meaningfully upward
						targetState = .compact
					} else if predictedOffset > collapsedPanelY + 160 {
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
		guard selectedAccount.wallets.count > 1, !isCardSettling, !didSwitchCardDuringGesture else { return }
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
		
		guard selectedAccount.wallets.count > 1, !isCardSettling else { return }
		
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
					frontWalletIndex = (frontWalletIndex - 1 + selectedAccount.wallets.count) % selectedAccount.wallets.count
				} else {
					frontWalletIndex = (frontWalletIndex + 1) % selectedAccount.wallets.count
				}
				cardDragY = 0
				isCardSettling = false
			}
		}
	}
	
	private func selectAccount(_ index: Int) {
		guard orderedAccounts.indices.contains(index) else { return }
		guard let sourceIndex = accounts.firstIndex(where: { $0.id == orderedAccounts[index].id }) else { return }
		let nextAccount = accounts[sourceIndex]
		
		tappedGroupIndex = index
		tappedCardOffset = groupCardY(index)
		tappedCardScale = groupCardScale(index)
		otherCardsOpacity = 1.0
		otherCardsOffsetShift = 0.0
		transitionPhase = .fadingOutGroup
		
		// Phase 1: Selected card moves to hero, other cards move up and fade away
		withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
			tappedCardOffset = 0.0
			tappedCardScale = 1.0
			otherCardsOpacity = 0.0
			otherCardsOffsetShift = -45.0
		}
		
		// Phase 2: Overlap/Emerge the currency stack (triggered halfway through Phase 1)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
			guard tappedGroupIndex == index else { return }
			transitionPhase = .emergingCurrencies
			
			originalSelectedAccountIndex = selectedAccountIndex
			selectedAccountIndex = sourceIndex
			frontWalletIndex = 0
			panelState = .collapsed
			dragY = 0
			cardDragY = 0
			
			currencyRevealProgress = 0.0
			
			withAnimation(.spring(response: 0.38, dampingFraction: 0.70)) {
				isAccountExpanded = true
				currencyRevealProgress = 1.0
			}
			
			showPanelLoading()
			setToolbar(title: nextAccount.name, subtitle: "Total \(nextAccount.totalCurrency) 14,0008")
			
			// Phase 3: Finalize expansion
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
				guard transitionPhase == .emergingCurrencies else { return }
				transitionPhase = .expanded
			}
		}
	}
	
	private func handleBack() {
		guard isAccountExpanded else { return }
		
		// Set transition phase to collapsing currencies
		transitionPhase = .collapsingCurrencies
		
		selectedAccountIndex = originalSelectedAccountIndex
		
		let targetOffset = groupCardY(tappedGroupIndex ?? 0)
		let targetScale = groupCardScale(tappedGroupIndex ?? 0)
		
		// Run all animations simultaneously and instinctively with a bouncy spring!
		withAnimation(.spring(response: 0.38, dampingFraction: 0.74)) {
			// 1. Collapse currency cards back behind the foremost card
			currencyRevealProgress = 0.0
			
			// 2. Cross-fade group view back in
			isAccountExpanded = false
			
			// 3. Translate foremost card back to its group slot
			tappedCardOffset = targetOffset
			tappedCardScale = targetScale
			
			// 4. Reset other card offsets and fade them in
			otherCardsOffsetShift = 0.0
			otherCardsOpacity = 1.0
		}
		
		showPanelLoading()
		setToolbar(title: "Main Group", subtitle: "Total \(selectedAccount.totalCurrency) 14,0008")
		
		// End the transition phase after the animation duration (0.38s)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
			transitionPhase = .group
			tappedGroupIndex = nil
		}
	}
	
	private func setToolbar(title: String, subtitle: String) {
		var transaction = Transaction()
		transaction.disablesAnimations = true
		
		withTransaction(transaction) {
			toolbarTitle = title
			toolbarSubtitle = subtitle
		}
	}
	
	private func setAccountExpanded(_ expanded: Bool) {
		var transaction = Transaction()
		transaction.disablesAnimations = true
		
		withTransaction(transaction) {
			isAccountExpanded = expanded
		}
	}
	
	private func showPanelLoading() {
		isPanelLoading = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
			withAnimation(.easeOut(duration: 0.18)) {
				isPanelLoading = false
			}
		}
	}
}

// MARK: - Preview

struct WalletDragRevealSample_Previews: PreviewProvider {
	static var previews: some View {
		WalletDragRevealSample()
	}
}
