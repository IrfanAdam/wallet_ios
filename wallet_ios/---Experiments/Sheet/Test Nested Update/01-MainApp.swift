import Foundation
import SwiftUI
import Combine // <-- Explicitly add this

class AppState: ObservableObject {
	// Controls global presentation of the sheet
	@Published var isShowingSendMoneyFlow = false
}


struct TestAppView: View {
	@EnvironmentObject var appState: AppState

	var body: some View {
		// The main view is a simple placeholder that shows the tab view
		MainTabView()
		.sheet(isPresented: $appState.isShowingSendMoneyFlow) {
			// This is the single, performant entry point for the flow
			SendMoneyFlowRootView()
		}

	}
}

#Preview {
	TestAppView().environmentObject(AppState())
}

