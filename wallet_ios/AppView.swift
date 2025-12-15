import SwiftUI

struct AppView: View {
	@State private var selectedTab = 0
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	var body: some View {
			HStack(alignment: .bottom) {
				TabView {
					Tab {HomeView()} label: {
							Image(systemName: "house.fill")
							Text("Home")

					}

					Tab {RoundedDonut_Chart()} label: {

							Image(systemName: "chart.bar.fill")
							Text("Analytics")

					}

					Tab {SeamlessPageNavDemo()} label: {

							Image(systemName: "person.fill")
							Text("Profile")

					}

					Tab {FABCheck()} label: {

						Image(systemName: "wrench.and.screwdriver.fill")
						Text("Test")

					}
				}
			}
	}
}

#Preview {
    AppView()
}

