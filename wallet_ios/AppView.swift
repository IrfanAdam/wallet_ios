import SwiftUI

import UIKit

struct AppView: View {
	@State private var selectedTab = 0
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	@State private var sheetController = AppSheetController()
	@State private var screenHeight: CGFloat = 0

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
				Image(systemName: "wallet.bifold.fill")
				Text("Wallet")
			}
			
			Tab {PeripheralLaunchSurface()} label: {
				Image(systemName: "wrench.fill")
				Text("Test")
			}

			Tab(role: .search) {SeamlessPageNavDemo()} label: {
				if let uiImage = UIImage(named: "LargeDP")?.circularImage(size: 48) {
					Image(uiImage: uiImage)
				}
				Text("Profile")
			}
		}
		.background(
			WindowReader { screen in
				screenHeight = screen.bounds.height
				sheetController.updateScreenHeight(screen.bounds.height)
			}
		)
		.sheet(isPresented: sheetController.isPresentedBinding) {
			DragResizableSheetRootView(
				controller: sheetController
			)
		}
	}
}

#Preview {
    AppView()
}

