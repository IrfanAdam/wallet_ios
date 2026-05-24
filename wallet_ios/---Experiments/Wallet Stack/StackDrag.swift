import SwiftUI

// MARK: - Main View

struct WalletDragRevealSample: View {
	@State private var dragY: CGFloat = 0
	@State private var isExpanded = false
	@State private var frontWalletIndex = 0
	@State private var shufflePhase: WalletShufflePhase = .idle
	
	private let collapsedPanelY: CGFloat = 120
	private let expandedPanelY: CGFloat = 402
	private let expandDistance: CGFloat = 224
	
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
					if isExpanded || progress > 0.35 {
						WalletAddCurrencyButton()
							.padding(.top, 26)
							.opacity(progress)
					}
					Spacer()
				}
				
				WalletCardStack(
					wallets: orderedWallets,
					progress: progress,
					frontIndex: frontWalletIndex,
					shufflePhase: shufflePhase,
					onSwap: swapWallet
				)
					.padding(.horizontal, 12)
					.padding(.top, 12)
					.zIndex(0)
					.gesture(panelDrag)
				
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
	
	private func swapWallet(_ direction: WalletSwapDirection) {
		guard !wallets.isEmpty, shufflePhase == .idle else { return }
		
		withAnimation(.easeInOut(duration: 0.16)) {
			shufflePhase = .departing(direction)
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
			switch direction {
			case .previous:
				frontWalletIndex = (frontWalletIndex - 1 + wallets.count) % wallets.count
			case .next:
				frontWalletIndex = (frontWalletIndex + 1) % wallets.count
			}
			
			var transaction = Transaction()
			transaction.disablesAnimations = true
			withTransaction(transaction) {
				shufflePhase = .arriving(direction)
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
				withAnimation(.easeOut(duration: 0.22)) {
					shufflePhase = .idle
				}
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
