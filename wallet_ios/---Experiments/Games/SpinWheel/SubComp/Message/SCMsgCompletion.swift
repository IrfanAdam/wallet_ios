import SwiftUI

//private let msg = MessagingConfig()
//
//private let dismissAnimation = Animation.spring(
//	response: msg.dismissSpringResponse,
//	dampingFraction: msg.dismissSpringDamping
//)
//


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

