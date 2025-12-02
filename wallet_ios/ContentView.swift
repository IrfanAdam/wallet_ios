import SwiftUI

struct AppView: View {
	@State private var showDetails = false
	@State private var selectedTab = 0
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	var body: some View {
		TabView {
			Tab("Home", systemImage: "house.fill") {
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

			Tab("Analytics", systemImage: "chart.bar.fill") {
				Text("Tab 2")
			}

			Tab("Profile", systemImage: "person.fill") {
				Text("Tab 3")
			}

			Tab("Pay", systemImage: "qrcode.viewfinder", role: .search) {
				NavigationStack {
					List {
						Text("Start typing to scan…")
					}
					.navigationTitle("Scan")
					.searchable(text: $searchText, isPresented: $isSearchActive)
					.onAppear {
						// When user taps "Scan", auto-expand search
						DispatchQueue.main.async {
							isSearchActive = true
						}
					}
				}
			}
		}

	}
}

#Preview {
    AppView()
}

