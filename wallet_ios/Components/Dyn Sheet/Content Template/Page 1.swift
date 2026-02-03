import SwiftUI

struct LevelOneView: View {
	@Environment(AuxiliaryContentState.self)
	private var routeState

	var body: some View {
		AuxiliaryPlaneContainer {
			VStack(spacing: 12) {
				Button("Go L2") {
					withAnimation(.easeInOut(duration: 0.35)) {
						routeState.route = .levelTwo
					}
				}
				.buttonStyle(.glassProminent)

				CustomGlass()
			}
		}
	}
}
