import SwiftUI
import Observation

struct LevelOneView: View {
	@Environment(AuxiliarySheetState.self)
	private var state

	var body: some View {
		AuxiliaryPlaneContainer { resize in
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
		AuxiliaryPlaneContainer { resize in
			VStack(spacing: 12) {
				Text("You can test any content style here")

				Button("Resize → 420") {
					resize(420)
				}

				Button("Resize → 480") {
					resize(480)
				}
			}
		}
	}
}
