import SwiftUI

struct AppView: View {
	@State private var selectedTab = 0
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	var body: some View {
		ZStack(alignment: .bottom) {
			HStack(alignment: .bottom) {
				TabView {
					Tab("", systemImage: "house.fill") {
						HomeView()
					}

					Tab("", systemImage: "chart.bar.fill") {
						RoundedDonut_Chart()
					}

					Tab("", systemImage: "person.fill") {
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
	}
}

#Preview {
    AppView()
}

