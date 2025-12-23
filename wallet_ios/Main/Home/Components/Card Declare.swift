import SwiftUI

struct PaymentAction: Identifiable {
	let id = UUID()
	let title: String
	let icon: String
}

struct PaymentActionCard: View {
	let title: String
	let icon: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			VStack(spacing: 16) {
				Image(systemName: icon)
					.font(.system(size: 32, weight: .medium))
					.foregroundColor(.primary)

				Text(title)
					.font(.system(size: 17, weight: .semibold))
					.foregroundColor(.primary)
			}
			.frame(maxWidth: .infinity)
			.frame(height: 140)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(Color(.systemBackground))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 20)
					.stroke(Color(.systemGray5), lineWidth: 1)
			)
		}
		.buttonStyle(.plain)
	}
}
