import SwiftUI

struct PaymentAction: Identifiable {
	let id = UUID()
	let title: String
	let icon: String
	let action: () -> Void
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


// Alternative: Grid Layout (non-scrollable, wraps to multiple rows)
struct PaymentActionsGridWrap: View {
	let columns = [
		GridItem(.flexible(), spacing: 12),
		GridItem(.flexible(), spacing: 12),
		GridItem(.flexible(), spacing: 12)
	]

	let actions: [PaymentAction] = [
		PaymentAction(title: "Pay", icon: "arrow.up") { print("Pay tapped") },
		PaymentAction(title: "Request", icon: "arrow.down.to.line") { print("Request tapped") },
		PaymentAction(title: "Withdraw", icon: "arrow.down.left.hand.draw") { print("Withdraw tapped") },
		PaymentAction(title: "Deposit", icon: "arrow.up.right.hand.draw") { print("Deposit tapped") },
		PaymentAction(title: "Split", icon: "arrow.triangle.branch") { print("Split tapped") }
	]

	var body: some View {
		LazyVGrid(columns: columns, spacing: 12) {
			ForEach(actions) { action in
				PaymentActionCard(
					title: action.title,
					icon: action.icon,
					action: action.action
				)
			}
		}
		.padding(.horizontal, 20)
	}
}

// Preview with both layouts
struct PaymentActionsPreview: View {
	var body: some View {
		VStack(spacing: 32) {
			VStack(alignment: .leading, spacing: 12) {
				Text("Horizontal Scroll")
					.font(.headline)
					.padding(.horizontal, 20)

				PaymentActionsGrid()
			}

			VStack(alignment: .leading, spacing: 12) {
				Text("Grid Layout")
					.font(.headline)
					.padding(.horizontal, 20)

				PaymentActionsGridWrap()
			}

			Spacer()
		}
		.padding(.top, 20)
	}
}

#Preview {
	PaymentActionsPreview()
}
