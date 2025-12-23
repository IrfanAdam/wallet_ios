import SwiftUI

struct PaymentCTAView: View {
	
	let hasContinued: Bool
	let isAuthenticating: Bool
	var namespace: Namespace.ID
	
	let onContinue: () -> Void
	let onPayNow: () -> Void
	let onPayLater: () -> Void
	
	var body: some View {
		VStack {
			if isAuthenticating {
				EmptyView()
			} else {
				buttonRow
			}
		}
	}
	
	private var buttonRow: some View {
		HStack(spacing: 12) {
			
			// Pay Later
			if hasContinued {
				Button(action: onPayLater) {
					Label("Pay Later", systemImage: "calendar")
						.frame(maxWidth: .infinity)
						.padding(.vertical, 14)
				}
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(.blue)
				.background(
					RoundedRectangle(cornerRadius: 28)
						.stroke(Color.blue, lineWidth: 1.5)
						.fill(Color.blue.opacity(0.08))
				)
			}
			
			// Primary
			Button(action: hasContinued ? onPayNow : onContinue) {
				Text(hasContinued ? "Pay Now" : "Continue")
					.frame(maxWidth: .infinity)
					.padding(.vertical, 14)
					.matchedGeometryEffect(
						id: "action_title",
						in: namespace
					)
			}
			.font(.system(size: 16, weight: .semibold))
			.foregroundColor(.white)
			.background(
				RoundedRectangle(cornerRadius: 28)
					.fill(Color.blue)
					.matchedGeometryEffect(
						id: "payment_bg",
						in: namespace
					)
			)
			.matchedGeometryEffect(id: "payment_container", in: namespace)
		}
	}
}

#Preview {
	PaymentCTAPreview()
}

private struct PaymentCTAPreview: View {
	@Namespace private var ns
	@State private var continued = false
	
	var body: some View {
		VStack {
			Spacer()
			
			PaymentCTAView(
				hasContinued: continued,
				isAuthenticating: false,
				namespace: ns,
				onContinue: { continued = true },
				onPayNow: {},
				onPayLater: {}
			)
			.padding()
		}
	}
}
