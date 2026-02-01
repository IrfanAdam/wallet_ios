import SwiftUI

struct BottomActionAreaView: View {
	@Bindable var context: InitiatePaymentContext

	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool

	let namespace: Namespace.ID
//	let instantSpring: Animation
//	let snappySpring: Animation
//	let smoothSpring: Animation

	var body: some View {
		Group {
			if context.isAuthenticating {
				PaymentAuthView(
					amount: "\(context.selectedCurrency) \(context.fullAmount)",
					namespace: namespace,
					onDismiss: {
						withAnimation(Self.smoothSpring) {
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
							withAnimation(Self.smoothSpring) {
								context.showTags = true
							}

							DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
								withAnimation(Self.snappySpring) {
									context.hasContinued = true
								}
							}
						}
					},

					onPayNow: {
						focusInteger = false
						focusDecimal = false
						withAnimation(Self.snappySpring) {
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
			namespace: namespace
		)
		.background(Color(.systemBackground))
	}
}

private extension BottomActionAreaView {
	
	static let instantSpring = Animation.spring(
		response: 0.2,
		dampingFraction: 0.95
	)
	
	static let snappySpring = Animation.spring(
		response: 0.25,
		dampingFraction: 0.92
	)
	
	static let smoothSpring = Animation.spring(
		response: 0.3,
		dampingFraction: 0.88
	)
}

