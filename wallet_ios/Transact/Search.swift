import SwiftUI


struct SearchPage: View {
	@Binding var detent: PresentationDetent
	var namespace: Namespace.ID
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			List {
				Section {
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
							.contentShape(Rectangle())
							.overlay(
								RoundedRectangle(cornerRadius: 16)
									.fill(Color.clear)
							)
							.matchedTransitionSource(id: cardID, in: namespace)
						}
						.navigationLinkIndicatorVisibility(.hidden)
						.listRowSeparator(.hidden)
						.listRowBackground(Color.clear)
						.listRowInsets(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
					}

				} header: {
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 10) {
							SearchTab(title: "Primary", icon: "tray.fill", index: 0, selectedTab: $selectedTab)
							SearchTab(title: "Promos", icon: "tag.fill", index: 1, selectedTab: $selectedTab)
							SearchTab(title: "Updates", icon: "bell.badge.fill", index: 2, selectedTab: $selectedTab)
							SearchTab(title: "More", icon: "speaker.wave.2.fill", index: 3, selectedTab: $selectedTab)
						}
						.padding(.horizontal, 0)
						.padding(.top, 0)
					}
					.scrollTargetBehavior(.paging)
					.headerProminence(.standard)
					.animation(.easeOut(duration: 0.15), value: selectedTab)
				}
				.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 16, trailing: 16))
			}
			.listSectionMargins(.vertical, 0)
			.listSectionSpacing(0)
			.listStyle(.plain)
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			)
			.navigationTitle("Send Money To")

			.toolbar { toolbarContent }

			.toolbar(.visible, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
		}
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .cancellationAction) {
			Button("Cancel", systemImage: "chevron.down") {dismiss()}
		}
		

		ToolbarItemGroup(placement: .primaryAction) {
			Text("Help")
			Button("Help", systemImage: "questionmark") {

			}
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .confirmationAction) {
			Button("Scan", systemImage: "qrcode.viewfinder") {}
		}
	}
}

#Preview {
	PreviewContainer()
}

private struct PreviewContainer: View {
	@Namespace var ns

	var body: some View {
		SearchPage(detent: .constant(.large), namespace: ns)
	}
}
