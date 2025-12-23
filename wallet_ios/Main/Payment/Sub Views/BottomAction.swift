import SwiftUI

struct BottomActionAreaView: View {
	@Bindable var context: InitiatePaymentContext

	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool

	let namespace: Namespace.ID
	let instantSpring: Animation
	let snappySpring: Animation
	let smoothSpring: Animation

	var body: some View {
		Group {
			if context.isAuthenticating {
				PaymentAuthView(
					amount: "\(context.selectedCurrency) \(context.fullAmount)",
					namespace: namespace,
					onDismiss: {
						withAnimation(smoothSpring) {
							context.isAuthenticating = false
						}
					}
				)
				.ignoresSafeArea(edges: .bottom)

			} else {
				PaymentCTAView(
					hasContinued: context.hasContinued,
					isAuthenticating: context.isAuthenticating,
					namespace: namespace,

					onContinue: {
						Task { @MainActor in
							withAnimation(smoothSpring) {
								context.showTags = true
							}

							DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
								withAnimation(snappySpring) {
									context.hasContinued = true
								}
							}
						}
					},

					onPayNow: {
						focusInteger = false
						focusDecimal = false
						withAnimation(snappySpring) {
							context.isAuthenticating = true
						}
					},

					onPayLater: {}
				)
				.padding()
			}
		}
	}
}

#Preview("Bottom Action Area") {
	BottomActionAreaPreviewWrapper()
}


struct BottomActionAreaPreviewWrapper: View {
	@State private var context = InitiatePaymentContext()
	@Namespace private var namespace

	var body: some View {
		BottomActionAreaView(
			context: context,
			namespace: namespace,
			instantSpring: .interactiveSpring(response: 0.2, dampingFraction: 0.9),
			snappySpring: .spring(response: 0.35, dampingFraction: 0.85),
			smoothSpring: .spring(response: 0.55, dampingFraction: 0.9)
		)
		.background(Color(.systemBackground))
	}
}

