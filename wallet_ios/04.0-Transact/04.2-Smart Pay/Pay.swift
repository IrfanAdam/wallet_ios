import SwiftUI

struct InitiatePayment: View {
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("Payment Screen")
					.font(.title)
					.foregroundColor(.primary)

				// Add UI here later
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			)
		}.navigationTitle("Payment To")
		.navigationBarTitleDisplayMode(.large)
		.toolbar { toolbarContent }
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		// Remove default back Chevron
		ToolbarItem(placement: .topBarLeading) {
			Button(action: { dismiss() }) {
				HStack(spacing: -8) {
					ProfileImage(url: "https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
					Image(systemName: "chevron.left")
						.font(.headline)
				}
				.padding(.horizontal, 0)
				.padding(.vertical, 0)
			}
			.background(.ultraThinMaterial)         // glass-like look
			.clipShape(Capsule())
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .topBarTrailing) {
			Button("Scan", systemImage: "qrcode.viewfinder") {}
		}
	}

	struct ProfileImage: View {
		let url: String
		let size: CGFloat = 34

		var body: some View {
			AsyncImage(url: URL(string: url)) { image in
				image
					.resizable()
					.scaledToFill()
			} placeholder: {
				Color.gray.opacity(0.2)    // simple placeholder
			}
			.frame(width: size, height: size)
			.clipShape(Circle())
		}
	}

}

#Preview {
	InitiatePayment()
}
