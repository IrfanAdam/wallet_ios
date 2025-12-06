import SwiftUI

struct CustomTab: View {
	@State private var selectedTab = 0
	@State private var searchText = ""
	@State private var isSearchActive = false

	var body: some View {
		NavigationStack {
			ZStack {
				// Main content
				switch selectedTab {
				case 0:
					HomeView()
				case 1:
					RoundedDonut_Chart()
				case 2:
					Text("Profile")
				case 3:
					NavigationStack {
						List {
							Text("Start typing to scan…")
						}
						.navigationTitle("Scan")
						.searchable(text: $searchText, isPresented: $isSearchActive)
						.onAppear {
							DispatchQueue.main.async { isSearchActive = true }
						}
					}
				default:
					HomeView()
				}
			}.toolbar {
				ToolbarItemGroup(placement: .bottomBar) {
					HStack(spacing: 14) {   // optional spacing for cleaner layout
						tabButton(title: "Home", systemImage: "house.fill", tag: 0)
						tabButton(title: "Analytics", systemImage: "chart.bar.fill", tag: 1)
						tabButton(title: "Profile", systemImage: "person.fill", tag: 2)
					}
					.padding(.horizontal, 16)
					.padding(.vertical, 4)
					.background(
						RoundedRectangle(cornerRadius: 42)
							.fill(Color.white)
							.stroke(Color.blue, lineWidth: 2.25)
					)
					Spacer()
				}.sharedBackgroundVisibility(.hidden)

				ToolbarItem(placement: .bottomBar) {
					Button(action: { selectedTab = 3 }) {
						VStack(spacing: 0) {
							Image(systemName: "qrcode.viewfinder")
								.font(.system(size: 20, weight: .bold))
								.scaleEffect(1)
						}
						.padding(0)
						.foregroundColor(.white)
					}
					.padding(4)
					.buttonStyle(.borderedProminent)
				}
			}
		}
	}

	// MARK: - Helper function for toolbar buttons
	@ViewBuilder
	func tabButton(title: String, systemImage: String, tag: Int, isScan: Bool = false) -> some View {
		Button(action: { selectedTab = tag }) {
			ZStack() {
				/// 🫧 Animated capsule bubble behind selected tab

				Image(systemName: systemImage)
					.font(.system(size: 16, weight: .bold))
					.scaleEffect(selectedTab == tag ? 1.2 : 1.0)
			}
			.padding(.horizontal, 2)
			.padding(.vertical, 8)
			.foregroundColor(selectedTab == tag ? (isScan ? .accentColor : .blue) : .gray)
		}
		.padding(.horizontal, 4)
		.padding(.vertical, 8)
		.background(
				RoundedRectangle(cornerRadius: 32)
					.fill(Color.blue.opacity(selectedTab == tag ? 0.18 : 0))
					.frame(width: 80, height: 54)
					.transition(.scale.combined(with: .opacity)).glassEffect()
		)
	}
}

#Preview {
	CustomTab()
}

