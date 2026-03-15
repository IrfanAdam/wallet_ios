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

struct RewardSpinnerToastPanel: View {
	
	let store: RewardSpinnerStore
	
	var body: some View {
		RewardSpinnerPanelContainer(store: store) {
			Text(store.anim.toastMessage)
				.font(.subheadline.weight(.semibold))
				.multilineTextAlignment(.center)
				.frame(maxWidth: .infinity)
				.padding(.vertical, msg.toastVerticalPadding)
				.background(.ultraThinMaterial)
				.clipShape(
					RoundedRectangle(cornerRadius: msg.toastCornerRadius)
				)
		}
	}
}

struct RewardSpinnerCompletionPanel: View {
	
	let store: RewardSpinnerStore
	
	var anim: RewardSpinnerAnimationConfig.Messaging { store.animations.messaging }
	
	var dismissAnimation: Animation {
		.spring(
			response:       anim.dismissResponse,
			dampingFraction: anim.dismissDamping
		)
	}
	
	var body: some View {
		RewardSpinnerPanelContainer(store: store) {
			HStack {
				
				Button { resetSpinner() } label: {
					Label("Spin Again", systemImage: "arrow.clockwise")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.bordered)
				
				Button { revealPrize() } label: {
					Label("Rewards", systemImage: "dollarsign.circle.fill")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)
				.tint(.blue)
			}
		}
	}
	
	private func resetSpinner() {
		withAnimation(dismissAnimation) {
			store.anim.selectedSegmentIndex = nil
			store.anim.spinnerState = .idle
			store.anim.toastMessage = ""
		}
	}
	
	private func revealPrize() {
		UINotificationFeedbackGenerator()
			.notificationOccurred(.success)
	}
}


