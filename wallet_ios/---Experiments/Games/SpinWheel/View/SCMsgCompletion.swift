import SwiftUI

private let msg = MessagingConfig()

private let dismissAnimation = Animation.spring(
	response: msg.dismissSpringResponse,
	dampingFraction: msg.dismissSpringDamping
)


struct RewardSpinnerCompletionPanel: View {
	
	let store: RewardSpinnerStore
	
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
			store.selectedSegmentIndex = nil
			store.spinnerState = .idle
			store.toastMessage = ""
		}
	}
	
	private func revealPrize() {
		UINotificationFeedbackGenerator()
			.notificationOccurred(.success)
	}
}

