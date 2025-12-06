import SwiftUI

struct InitiatePayment: View {
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			Section {
				// All contacts scroll under pinned header

			}
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			)
		}.navigationTitle("Payment To")
		.navigationBarTitleDisplayMode(.large)
		.toolbar { toolbarContent }
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .cancellationAction) {
			Button("Cancel", systemImage: "xmark") {dismiss()}
		}


		ToolbarItemGroup(placement: .primaryAction) {
			Text("Help")
			Button("Help", systemImage: "questionmark") {

			}.background(Color.blue.opacity(0.8)) // background color
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 12) // border stroke
				)
				.cornerRadius(10)
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .confirmationAction) {
			Button("Scan", systemImage: "qrcode.viewfinder") {}
		}
	}

	func inboxTab(_ title: String, index: Int, icon: String) -> some View {
		Button {
			selectedTab = index
		} label: {
			HStack(spacing: 6) {
				Image(systemName: icon)
				if selectedTab == index {
					Text(title)
				}

			}
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(selectedTab == index ? Color.blue : Color.gray)
			)
			.foregroundStyle(selectedTab == index ? .white : .primary)
			.animation(.easeInOut(duration: 0.2), value: selectedTab)
		}
	}
}

#Preview {
	InitiatePayment()
}
