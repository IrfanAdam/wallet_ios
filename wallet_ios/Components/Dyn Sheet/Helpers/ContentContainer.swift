import SwiftUI

struct AuxiliaryPlaneContainer<Content: View>: View {
	@Environment(AuxiliarySheetState.self)
	private var state

	@State private var contentHeight: CGFloat = 0

	@ViewBuilder
	let routeContent: () -> Content

	var body: some View {
		routeContent()
			.padding()
			.background(
				AuxiliarySheetLayout.PlaneMeasurementLayer(
					state: state,
					updHeight: { contentHeight = $0 }
				)
			)
			.task(id: contentHeight) {
				AuxiliarySheetLayout.resizeToContent(
					contentHeight,
					state: state
				)
			}
			.frame(height: contentHeight, alignment: .top)
	}
}
