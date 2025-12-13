import SwiftUI

struct Message: Identifiable {
	let id = UUID()
	var name: String
	var message: String
	var avatar: String // image URL or asset
	var category: String = "Primary"
	var isPriority: Bool = false
}

struct AppleMailInboxView: View {
	@State private var selectedTab: Int = 0
	@State private var searchText: String = ""
	@State private var messages: [Message] = sampleMessages

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {

				// MARK: Top Segmented Tabs
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 10) {
						inboxTab("Primary", index: 0, icon: "tray.fill")
						inboxTab("Promos", index: 1, icon: "tag.fill")
						inboxTab("Updates", index: 2, icon: "bell.badge.fill")
						inboxTab("More", index: 3, icon: "speaker.wave.2.fill")
					}
					.padding(.horizontal)
					.padding(.top, 6)
				}
				.scrollTargetBehavior(.paging)

				// MARK: Search + Toolbar row
				HStack(spacing: 10) {
					searchField
					toolButton(icon: "ellipsis.circle")
					toolButton(icon: "square.and.pencil")
				}
				.padding(.horizontal)
				.padding(.vertical, 8)
				.background(.ultraThinMaterial)

				ScrollView {
					VStack(alignment: .leading, spacing: 20) {

						// MARK: Priority Section - Apple Mail style card
						if hasPriority {
							VStack(alignment: .leading, spacing: 8) {
								Text("PRIORITY")
									.font(.caption)
									.fontWeight(.semibold)
									.foregroundStyle(.secondary)

								VStack(spacing: 12) {
									ForEach(priorityMessages) { msg in
										messageRow(msg)
									}
								}
								.padding()
								.background(
									RoundedRectangle(cornerRadius: 20)
										.fill(
											.linearGradient(
												colors: [.pink.opacity(0.18), .blue.opacity(0.12)],
												startPoint: .topLeading,
												endPoint: .bottomTrailing
											)
										)
								)
							}
							.padding(.horizontal)
						}

						// MARK: Inbox messages
						VStack(spacing: 0) {
							ForEach(messages.filter { !$0.isPriority }) { msg in
								messageRow(msg)
								Divider().padding(.leading, 64)
							}
						}
						.padding(.horizontal)

					}.padding(.top, 8)
				}
			}
			.navigationTitle("Inbox")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				// Nav leading + trailing just like Mail
				ToolbarItem(placement: .topBarLeading) {
					Image(systemName: "line.3.horizontal")
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("Select") {}
				}
			}
		}
	}
}

// MARK: UI Components

extension AppleMailInboxView {

	var hasPriority: Bool {
		messages.contains(where: { $0.isPriority })
	}

	var priorityMessages: [Message] {
		messages.filter { $0.isPriority }
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
			.padding(.horizontal, 14)
			.padding(.vertical, 7)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(selectedTab == index ? Color.blue : .clear)
			)
			.foregroundStyle(selectedTab == index ? .white : .primary)
			.animation(.easeInOut(duration: 0.2), value: selectedTab)
		}
	}

	var searchField: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(.secondary)

			TextField("Search", text: $searchText)
				.font(.body)
		}
		.padding(.vertical, 6)
		.padding(.horizontal, 10)
		.background(.thinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}

	func toolButton(icon: String) -> some View {
		Button { } label: {
			Image(systemName: icon)
				.font(.title3)
				.padding(8)
				.background(.thinMaterial)
				.clipShape(Circle())
		}
	}

	func messageRow(_ msg: Message) -> some View {
		HStack(alignment: .top, spacing: 14) {
			Image(msg.avatar)
				.resizable()
				.frame(width: 42, height: 42)
				.clipShape(Circle())

			VStack(alignment: .leading, spacing: 4) {
				Text(msg.name)
					.font(.headline)

				Text(msg.message)
					.lineLimit(1)
					.foregroundStyle(.secondary)
			}
			Spacer()
		}
	}

	
}


// MARK: Sample data

let sampleMessages: [Message] = [
	.init(name: "Florence", message: "Invited to soft opening tonight.", avatar: "avatar1", isPriority: true),
	.init(name: "United", message: "Flight check-in reminder.", avatar: "avatar2", isPriority: true),
	.init(name: "Magico", message: "Lunch & Coffee order.", avatar: "avatar3", isPriority: false),
	.init(name: "Katie", message: "Contract needs signing.", avatar: "avatar4", isPriority: false)
]


#Preview {
	AppleMailInboxView()
}
