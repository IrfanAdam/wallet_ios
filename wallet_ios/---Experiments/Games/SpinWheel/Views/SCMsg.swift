import SwiftUI

// MARK: - Animations

private let msg = MessagingConfig()

struct RewardSpinnerMessagingView: View {
	
	let store: RewardSpinnerStore
	
	var body: some View {
		ZStack {
			if case .completed = store.engine.model.phase {
				RewardSpinnerCompletionPanel(store: store)
					.transition(.scale(scale: msg.scaleTransition).combined(with: .opacity))
			}
			else if store.engine.model.showToast {
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
		.offset(y: store.geometry.spinWheel.wheelSize / 2 + msg.yOffset)
	}
}

struct RewardSpinnerToastPanel: View {
	
	let store: RewardSpinnerStore
	
	var body: some View {
		RewardSpinnerPanelContainer(store: store) {
			Text(store.engine.model.toastMessage)
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
	
	var dismissAnimation: Animation {store.engine.anim.spinSmooth.animation}
	
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
			store.engine.model.selectedIndex = nil
			store.engine.model.phase = .idle
			store.engine.model.toastMessage = ""
		}
	}
	
	private func revealPrize() {
		UINotificationFeedbackGenerator()
			.notificationOccurred(.success)
	}
}


