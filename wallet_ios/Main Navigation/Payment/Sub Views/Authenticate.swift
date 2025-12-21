import SwiftUI

struct PaymentAuthView: View {
	let amount: String
	var namespace: Namespace.ID
	var onDismiss: (() -> Void)? = nil   // <-- new
	
	var body: some View {
		let _ = Self._printChanges() 
		VStack(spacing: 20) {
			
			HStack {
				Button {
					onDismiss?()  // call closure when chevron is tapped
				} label: {
					Image(systemName: "chevron.down")
						.font(.title3)
						.padding(12)
						.background(.white.opacity(0.15))
						.clipShape(Circle())
						.foregroundColor(.white)
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Enter PIN to Pay")
						.font(.headline)
						.foregroundColor(.white)
						.matchedGeometryEffect(
							id: "action_title",
							in: namespace
						)
					
					Text(amount)
						.font(.subheadline)
						.foregroundColor(.white.opacity(0.9))
				}
				
				Spacer()
				
				HStack(spacing: 10) {
					Image(systemName: "circle.grid.3x3.fill")
					Image(systemName: "touchid")
				}
				.font(.title3)
				.foregroundColor(.white.opacity(0.9))
			}
			
			// PIN placeholders
			HStack(spacing: 16) {
				ForEach(0..<4) { index in
					RoundedRectangle(cornerRadius: 14)
						.stroke(.white.opacity(0.6), lineWidth: 1.5)
						.frame(width: 48, height: 48)
				}
			}
			
			HStack(spacing: 6) {
				Image(systemName: "checkmark.shield")
				Text("mobiquity encrypted")
			}
			.font(.footnote)
			.foregroundColor(.white.opacity(0.85))
			
			Spacer()
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.background(
			RoundedRectangle(cornerRadius: 48)
				.fill(Color.blue)
		)
		.matchedGeometryEffect(id: "payment_container", in: namespace)
	}
}

#Preview {
	PaymentAuthPreviewContainer()
}

private struct PaymentAuthPreviewContainer: View {
	@Namespace private var ns
	
	var body: some View {
		PaymentAuthView(
			amount: "Rp 10.000",
			namespace: ns
		)
		.ignoresSafeArea(.container, edges: .bottom)
		.padding(0)
	}
}
