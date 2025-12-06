import SwiftUI

struct MainTabView: View {
	@State private var selection = 0
	@EnvironmentObject var appState: AppState

	var body: some View {
		TabView(selection: $selection) {
			// Home Tab
			HomeTab()
				.tabItem {
					Label("Home", systemImage: "house.fill")
				}
				.tag(0)

			// Other Tabs (placeholders)
			Text("Discover View")
				.tabItem {
					Label("Discover", systemImage: "magnifyingglass")
				}
				.tag(1)

			Text("Settings View")
				.tabItem {
					Label("Settings", systemImage: "gear.circle.fill")
				}
				.tag(2)
		}
	}
}

// Sub-view within the Home Tab that initiates the action
struct HomeTab: View {
	@EnvironmentObject var appState: AppState

	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("Welcome to the Home Screen.")

				Button("Initiate Search & Payment Flow") {
					// This action flips the global state boolean
					appState.isShowingSendMoneyFlow = true
				}
				.padding()
				.background(Color.blue)
				.foregroundColor(.white)
				.cornerRadius(8)
			}
			.navigationTitle("App Home")
		}
	}
}
