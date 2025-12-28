import SwiftUI

struct AppView: View {
	@State private var selectedTab = 0
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	@State private var sheetController = AppSheetController()

	var body: some View {
		@Bindable var controller = sheetController
		TabView {
			Tab {HomeView(sheetController: sheetController)} label: {
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

			Tab(role: .search) {SeamlessPageNavDemo()} label: {
				Image(systemName: "wrench.and.screwdriver.fill")
				Text("Test")
			}
		}
		.sheet(isPresented: sheetController.isPresentedBinding) {
//			DragResizableSheetRootView(
//				detents: sheetController.availableDetents,
//				selection: sheetController.detentSelectionBinding,
//				setDetent: sheetController.setDetent,
//				dismiss: sheetController.dismiss
//			)
		}
	}
}

#Preview {
    AppView()
}

