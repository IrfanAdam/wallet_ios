import SwiftUI

struct BottomActionAreaView: View {
	@Binding var isAuthenticating: Bool
	@Binding var hasContinued: Bool
	@FocusState var focusInteger: Bool
	@FocusState var focusDecimal: Bool
	let namespace: Namespace.ID
	let fullAmount: String
	let selectedCurrency: String
	let instantSpring: Animation
	let snappySpring: Animation
	let smoothSpring: Animation
	
	var body: some View {
			if isAuthenticating {
				PaymentAuthView(
					amount: "\(selectedCurrency) \(fullAmount)",
					namespace: namespace,
					onDismiss: { withAnimation(smoothSpring) { isAuthenticating = false } }
				)
				.animation(snappySpring, value: isAuthenticating)
				.ignoresSafeArea(edges: .bottom)
			} else {
				PaymentCTAView(
					hasContinued: hasContinued,
					isAuthenticating: isAuthenticating,
					namespace: namespace,
					onContinue: { withAnimation(smoothSpring) { hasContinued = true } },
					onPayNow: {
						focusInteger = false
						focusDecimal = false
						withAnimation(snappySpring) { isAuthenticating = true }
					},
					onPayLater: {}
				)
				.padding()
				.animation(snappySpring, value: isAuthenticating)
			}
	}
}
