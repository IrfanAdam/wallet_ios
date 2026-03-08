import SwiftUI

private let msg = MessagingConfig()

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
