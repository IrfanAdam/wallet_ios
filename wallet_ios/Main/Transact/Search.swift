import SwiftUI

struct SearchPage: View {
	@Binding var detent: PresentationDetent
	var namespace: Namespace.ID

	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
					Section {
						VStack(spacing: 16) {

							// card group
							LazyVStack(spacing: 0) {
								ForEach(0..<10, id: \.self) { index in
									let cardID = "card\(index)"

									NavigationLink {
										InitiatePayment(namespace: namespace)
											.navigationTransition(.zoom(sourceID: cardID, in: namespace))
									} label: {
										ContactCard(
											name: "Oluwaseun Oluwatoyin Ad...",
											maskedID: "we******qe",
											number: "7127128312912",
											imageURL: "https://source.unsplash.com/random/200x200?face,portrait"
										)
										.matchedTransitionSource(id: cardID, in: namespace)
										.padding(.horizontal, 0)
									}
									.buttonStyle(.plain)

									if index != 9 {
										Divider()
											.padding(.leading, 72)
									}
								}
							}
							.background(
								RoundedRectangle(cornerRadius: 24, style: .continuous)
									.fill(.white)
							)
							.padding(.horizontal, 16)
							.padding(.top, 16)
						}
					} header: {
						headerTabs
							.padding(.vertical, 8)
							.background(Color.clear)
					}
				}
			}
			.background(Color(.systemGroupedBackground))
			.navigationTitle("Send Money To")
			.navigationBarTitleDisplayMode(.large)
			.toolbar { toolbarContent }
			.toolbarBackground(.visible, for: .navigationBar)
		}
	}

	// MARK: Header Tabs

	private var headerTabs: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				SearchTab(
					title: "Primary",
					icon: "tray.fill",
					index: 0,
					selectedTab: $selectedTab
				)

				SearchTab(
					title: "Promos",
					icon: "tag.fill",
					index: 1,
					selectedTab: $selectedTab
				)

				SearchTab(
					title: "Updates",
					icon: "bell.badge.fill",
					index: 2,
					selectedTab: $selectedTab
				)

				SearchTab(
					title: "More",
					icon: "speaker.wave.2.fill",
					index: 3,
					selectedTab: $selectedTab
				)
			}
			.padding(.horizontal, 16)
			.animation(.easeOut(duration: 0.15), value: selectedTab)
		}
	}

	// MARK: Toolbar

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .cancellationAction) {
			Button("Cancel", systemImage: "chevron.down") {
				dismiss()
			}
		}

		ToolbarItemGroup(placement: .primaryAction) {
			Text("Help")
			Button("Help", systemImage: "questionmark") {

			}
		}

		ToolbarItem(placement: .confirmationAction) {
			Button("Scan", systemImage: "qrcode.viewfinder") { }
		}
	}
}

#Preview {
	PreviewContainer()
}

private struct PreviewContainer: View {
	@Namespace var ns

	var body: some View {
		SearchPage(
			detent: .constant(.large),
			namespace: ns
		)
	}
}
