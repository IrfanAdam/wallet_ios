import SwiftUI

// MARK: - Animations

private let msg = MessagingConfig()

struct RewardSpinnerMessagingView: View {
	
	let store: RewardSpinnerStore
	
	var body: some View {
		ZStack {
			if case .completed = store.anim.spinnerState {
				RewardSpinnerCompletionPanel(store: store)
					.transition(.scale(scale: msg.scaleTransition).combined(with: .opacity))
			}
			else if store.anim.showToast {
				RewardSpinnerToastPanel(store: store)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
	}
}

struct RewardSpinnerPanelContainer<Content: View>: View {
	
	let store: RewardSpinnerStore
	let content: Content
	
	init(
		store: RewardSpinnerStore,
		@ViewBuilder content: () -> Content
	) {
		self.store = store
		self.content = content()
	}
	
	var body: some View {
		VStack(spacing: msg.vStackSpacing) {
			content
		}
		.padding(.horizontal, msg.horizontalPadding)
		.offset(y: store.config.wheelSize / 2 + msg.yOffset)
	}
}
