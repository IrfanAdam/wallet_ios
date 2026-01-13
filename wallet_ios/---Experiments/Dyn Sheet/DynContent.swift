import SwiftUI
import Observation

struct LevelOneView: View {
	@Environment(AuxiliarySheetState.self)
	private var state

	var body: some View {
		AuxiliaryPlaneContainer {
			Button("Go L2") {
				withAnimation(.easeInOut(duration: 0.35)) {
					state.route = .levelTwo
				}
			}
			.buttonStyle(.glassProminent)
		}
	}
}

struct LevelTwoView: View {
	@Environment(AuxiliarySheetState.self)
	private var state

	var body: some View {
		AuxiliaryPlaneContainer {
			VStack(spacing: 12) {
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
			}
		}
	}
}
