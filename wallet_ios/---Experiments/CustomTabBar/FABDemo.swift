//import FabBar
import SwiftUI

enum FabAppTab: Hashable {
	case home
	case explore
	case profile
	case activity
}

@available(iOS 26.0, *)
struct FavContentView: View {
	@State private var selectedTab: FabAppTab = .home
	@State private var showingSheet = false
	@State private var showingSettings = false
	@State private var tabCount = 3
	@State private var useNativeTabBar = false
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass

	@Environment(\.dismiss) private var dismiss

	private var tabBarVisibility: Visibility {
		if useNativeTabBar {
			return .visible
		}
		return horizontalSizeClass == .compact ? .hidden : .visible
	}

	private var visibleTabs: [FabBarTab<FabAppTab>] {
		let allTabs: [FabBarTab<FabAppTab>] = [
			FabBarTab(value: .home, title: "Home", systemImage: "house", onReselect: {
				print("Reselected: home")
			}),
			FabBarTab(value: .explore, title: "Explore", systemImage: "map", onReselect: {
				print("Reselected: explore")
			}),
			FabBarTab(value: .profile, title: "Profile", systemImage: "person", onReselect: {
				print("Reselected: profile")
			}),
			FabBarTab(value: .activity, title: "Activity", systemImage: "bell", onReselect: {
				print("Reselected: activity")
			}),
		]
		return Array(allTabs.prefix(tabCount))
	}

	var body: some View {
		TabView(selection: $selectedTab) {
			Tab("Home", systemImage: "house.fill", value: FabAppTab.home) {
				NavigationStack {
					TabContentPlaceholder(title: "Home", systemImage: "house.fill")
						.navigationTitle("Home")
						.toolbar {
							ToolbarItem(placement: .topBarTrailing) {
								Button {
									showingSettings = true
								} label: {
									Image(systemName: "gearshape")
								}
							}

							ToolbarItem(placement: .topBarTrailing) {
								Button {
									dismiss()
								} label: {
									Image(systemName: "xmark")
								}
							}
						}
				}
				.fabBarSafeAreaPadding()
				.toolbarVisibility(tabBarVisibility, for: .tabBar)
			}

			Tab("Explore", systemImage: "map.fill", value: FabAppTab.explore) {
				ExploreTabView()
					.toolbarVisibility(tabBarVisibility, for: .tabBar)
			}

			Tab("Profile", systemImage: "person.fill", value: FabAppTab.profile) {
				TabContentView(title: "Profile", systemImage: "person.fill")
					.fabBarSafeAreaPadding()
					.toolbarVisibility(tabBarVisibility, for: .tabBar)
			}

			Tab("Activity", systemImage: "bell.fill", value: FabAppTab.activity) {
				TabContentView(title: "Activity", systemImage: "bell.fill")
					.fabBarSafeAreaPadding()
					.toolbarVisibility(tabBarVisibility, for: .tabBar)
			}
		}
		.fabBar(
			selection: $selectedTab,
			tabs: visibleTabs,
			action: FabBarAction(
				systemImage: "plus",
				accessibilityLabel: "Add"
			) {
				showingSheet = true
			},
			isVisible: !useNativeTabBar
		)
		.sheet(isPresented: $showingSheet) {
			Text("Sheet content")
				.presentationDetents([.medium])
		}
		.sheet(isPresented: $showingSettings) {
			SettingsView(tabCount: $tabCount, useNativeTabBar: $useNativeTabBar)
				.presentationDetents([.medium])
		}
		.onChange(of: tabCount) {
			// Reset to home if the selected tab is no longer visible
			if !visibleTabs.contains(where: { $0.value == selectedTab }) {
				selectedTab = .home
			}
		}
	}
}

@available(iOS 26.0, *)
struct SettingsView: View {
	@Binding var tabCount: Int
	@Binding var useNativeTabBar: Bool

	var body: some View {
		NavigationStack {
			Form {
				Section("Tab Bar") {
					Toggle("Use Native Tab Bar", isOn: $useNativeTabBar)
				}

				if !useNativeTabBar {
					Section("Number of Tabs") {
						Picker("Number of Tabs", selection: $tabCount) {
							Text("2").tag(2)
							Text("3").tag(3)
							Text("4").tag(4)
						}
						.pickerStyle(.segmented)
					}
				}
			}
			.navigationTitle("Settings")
		}
	}
}

struct TabContentPlaceholder: View {
	let title: String
	let systemImage: String

	var body: some View {
		VStack {
			Spacer()
			Image(systemName: systemImage)
				.font(.system(size: 48))
				.foregroundStyle(.tertiary)
			Text(title)
				.font(.title2)
				.foregroundStyle(.secondary)
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.accessibilityHidden(true)
		.background(Color(uiColor: .systemGroupedBackground))
	}
}

struct TabContentView: View {
	let title: String
	let systemImage: String

	var body: some View {
		NavigationStack {
			TabContentPlaceholder(title: title, systemImage: systemImage)
				.navigationTitle(title)
		}
	}
}

struct ExploreTabView: View {
	private let places = [
		("San Francisco", "Golden Gate Bridge and tech hub"),
		("New York", "The city that never sleeps"),
		("Tokyo", "Ancient traditions meet modern innovation"),
		("Paris", "City of lights and romance"),
		("London", "Historic capital with royal heritage"),
		("Sydney", "Harbor city with iconic opera house"),
		("Rome", "Eternal city of ancient wonders"),
		("Barcelona", "Gaudí's architectural playground"),
		("Amsterdam", "Canals, bikes, and Dutch charm"),
		("Singapore", "Garden city of the future"),
		("Dubai", "Modern marvels in the desert"),
		("Cape Town", "Mountains meet the sea"),
		("Rio de Janeiro", "Carnival spirit and beaches"),
		("Vancouver", "Nature at your doorstep"),
		("Melbourne", "Coffee culture capital"),
	]

	var body: some View {
		NavigationStack {
			List(places, id: \.0) { place in
				VStack(alignment: .leading) {
					Text(place.0)
						.font(.headline)
					Text(place.1)
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
			}
			.fabBarSafeAreaPadding()
			.navigationTitle("Explore")
		}
	}
}

#Preview {
	if #available(iOS 26.0, *) {
		FavContentView()
	} else {
		Text("Requires iOS 26")
	}
}
