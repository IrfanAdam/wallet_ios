import SwiftUI

import UIKit

enum AppTab: Hashable {
	case home
	case rewards
	case wallet
	case profile
}

struct AppView: View {
	@State private var selectedTab: AppTab = .home
	@State private var showScan = false
	@State private var searchText = ""
	@State private var isSearchActive = false

	@State private var sheetController = AppSheetController()
	@State private var screenHeight: CGFloat = 0

	private var visibleTabs: [FabBarTab<AppTab>] {
		[
			FabBarTab(
				value: .home,
				title: "Home",
				customIcon: "ph_house",
				onReselect: { print("Reselected: home") }
			),
			FabBarTab(
				value: .rewards,
				title: "Rewards",
				customIcon: "ph_trophy",
				onReselect: { print("Reselected: rewards") }
			),
			FabBarTab(
				value: .wallet,
				title: "Wallet",
				customIcon: "ph_cardholder",
				onReselect: { print("Reselected: wallet") }
			),
			FabBarTab(
				value: .profile,
				title: "Profile",
				customIcon: "LargeDP",
				rendering: .original,
				onReselect: { print("Reselected: profile") }
			)
		]
	}

	var body: some View {
		@Bindable var controller = sheetController
		ZStack {
			Group {
				HomeView(sheetController: sheetController)
					.fabBarSafeAreaPadding()
			}
			.opacity(selectedTab == .home ? 1 : 0)
			.disabled(selectedTab != .home)

			Group {
				RoundedDonut_Chart()
					.fabBarSafeAreaPadding()
			}
			.opacity(selectedTab == .rewards ? 1 : 0)
			.disabled(selectedTab != .rewards)

			Group {
				WalletDragRevealSample()
					.fabBarSafeAreaPadding()
			}
			.opacity(selectedTab == .wallet ? 1 : 0)
			.disabled(selectedTab != .wallet)

			Group {
				PeripheralLaunchSurface()
					.fabBarSafeAreaPadding()
			}
			.opacity(selectedTab == .profile ? 1 : 0)
			.disabled(selectedTab != .profile)
		}
		.fabBar(
			selection: $selectedTab,
			tabs: visibleTabs,
			action: FabBarAction(
				image: "ph_custom-transfer-duotone",
				accessibilityLabel: "Scan"
			) {
				showScan = true
			},
			isVisible: true
		)
		.background(
			WindowReader { screen in
				screenHeight = screen.bounds.height
				sheetController.updateScreenHeight(screen.bounds.height)
			}
		)
		.sheet(isPresented: sheetController.isPresentedBinding) {
			PageSheetDemo()
		}
		.fullScreenCover(isPresented: $showScan) {
			transactOpts().ignoresSafeArea()
		}
	}
}

#Preview {
    AppView()
}
