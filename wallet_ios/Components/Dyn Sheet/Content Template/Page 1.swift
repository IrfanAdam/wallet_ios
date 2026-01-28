import SwiftUI

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
