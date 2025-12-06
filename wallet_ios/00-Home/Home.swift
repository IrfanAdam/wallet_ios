import SwiftUI

struct HomeView: View {

	@State private var showDetails = false
	var body: some View {
		// First tab
		NavigationStack {
			VStack {
				DataWidget()
					.frame(maxWidth: 200, maxHeight: 220)
					.onTapGesture {
						showDetails = true
					}
					.sheet(isPresented: $showDetails) {
						AnalyticsSheet()
					}

				VStack(alignment: .leading, spacing: 12) {
					Text("Horizontal Scroll")
						.font(.headline)
						.padding(.horizontal, 20)

					PaymentActionsGrid()
				}
			}
			.navigationTitle("Home")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {
						print("Menu tapped")
					}) {
						Image(systemName: "line.horizontal.3")
							.font(.title2)
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						print("Notifications tapped")
					}) {
						Image(systemName: "bell.fill")
							.font(.title2)
					}
				}
			}
		}
	}
}

struct PaymentActionsGrid: View {
	@State private var showPageSheet = false
	let actions: [PaymentAction] = [
		PaymentAction(title: "Pay", icon: "arrow.up") { print("Pay tapped") },
		PaymentAction(title: "International", icon: "globe") { print("Pay tapped") },
		PaymentAction(title: "Request", icon: "arrow.down.to.line") { print("Request tapped") },
		PaymentAction(title: "Withdraw", icon: "arrow.down.left.hand.draw") { print("Withdraw tapped") },
		PaymentAction(title: "Deposit", icon: "arrow.up.right.hand.draw") { print("Deposit tapped") },
		PaymentAction(title: "Split", icon: "arrow.triangle.branch") { print("Split tapped") }
	]

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(actions) { action in
					PaymentActionCard(
						title: action.title,
						icon: action.icon,
						action: {
							showPageSheet = true
						}
					)
					.frame(width: 140)
				}
			}
			.padding(.horizontal, 20)
		}
		.sheet(isPresented: $showPageSheet) {
			SearchPage()
				.presentationSizing(.page)
				.presentationDragIndicator(.visible)
		}
	}
}

#Preview {
	HomeView()
}

