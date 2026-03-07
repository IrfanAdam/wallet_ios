import SwiftUI

// MARK: - Animations

private let msg = MessagingConfig()
private let dismissAnimation = Animation.spring(response: msg.dismissSpringResponse, dampingFraction: msg.dismissSpringDamping)

// MARK: - View

struct RewardSpinnerMessagingView: View {

	let store: RewardSpinnerStore

	var body: some View {
		ZStack {
			if case .completed = store.spinnerState {
				panelContainer { completionContent }
					.transition(.scale(scale: msg.scaleTransition).combined(with: .opacity))
			} else if store.showToast {
				panelContainer { toastContent }
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
	}

	// MARK: - Shared Container

	private func panelContainer<Content: View>(
		@ViewBuilder content: () -> Content
	) -> some View {
		VStack(spacing: msg.vStackSpacing) { content() }
			.padding(.horizontal, msg.horizontalPadding)
			.offset(y: store.config.wheelSize / 2 + msg.yOffset)
	}

	// MARK: - Toast Content

	private var toastContent: some View {
		Text(store.toastMessage)
			.font(.subheadline.weight(.semibold))
			.multilineTextAlignment(.center)
			.frame(maxWidth: .infinity)
			.padding(.vertical, msg.toastVerticalPadding)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: msg.toastCornerRadius))
	}

	// MARK: - Completion Content

	private var completionContent: some View {
		HStack {
			Button {
				withAnimation(dismissAnimation) {
					store.selectedSegmentIndex = nil
					store.spinnerState = .idle
					store.toastMessage = ""
				}
			} label: {
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

	// MARK: - Actions

	private func revealPrize() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
	}
}
