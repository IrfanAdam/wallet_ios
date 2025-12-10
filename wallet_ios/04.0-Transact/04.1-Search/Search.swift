import SwiftUI

struct SearchPage: View {
	@Binding var detent: PresentationDetent
	@State private var selectedTab: Int = 0
	@State private var showPaymentView = false
	@Environment(\.dismiss) private var dismiss
	@Namespace private var namespace

	var body: some View {
		NavigationStack {
			List {
				Section {
						// All contacts scroll under pinned header
						ForEach(0..<10) { _ in
							ContactCard(
								name: "Oluwaseun Oluwatoyin Ad...",
								maskedID: "we******qe",
								number: "7127128312912",
								imageURL: "https://source.unsplash.com/random/200x200?face,portrait"
							)
							.listRowSeparator(.hidden)       // no separators
							.listRowBackground(Color.clear)
							.padding(.horizontal, 0)
							.padding(.vertical, 0)
							.listRowInsets(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
							.onTapGesture {
								detent = .medium
								withAnimation(.easeInOut(duration: 0.28)) {
									showPaymentView = true
								}
							}
						}

				} header: {
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 10) {
							inboxTab("Primary", index: 0, icon: "tray.fill")
							inboxTab("Promos", index: 1, icon: "tag.fill")
							inboxTab("Updates", index: 2, icon: "bell.badge.fill")
							inboxTab("More", index: 3, icon: "speaker.wave.2.fill")
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
			.matchedGeometryEffect(id: "search_page", in: namespace)
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			)
			.navigationTitle("Send Money To")

			.toolbar { toolbarContent }
			.toolbar(.visible, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.navigationDestination(isPresented: $showPaymentView) {
				InitiatePayment().navigationTransition(.zoom(sourceID: "search_page", in: namespace))
			}
		}
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
	SearchPage(detent: .constant(.large))
}
