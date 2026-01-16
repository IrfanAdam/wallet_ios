import SwiftUI

// MARK: - Auxiliary Plane Container

struct AuxiliaryPlaneContainer<Content: View>: View {

	@Environment(AuxiliarySheetState.self)
	private var state

	@State private var contentHeight: CGFloat = 0

	@ViewBuilder
	let content: () -> Content

	var body: some View {
		VStack(spacing: 16) {
			content()
		}
		.padding()
		.background(measurementLayer)
		.task(id: contentHeight) {
			AuxiliaryPlaneLogic.resizeToContent(
				contentHeight,
				state: state
			)
		}
	}
}

// MARK: - Measurement

private extension AuxiliaryPlaneContainer {

	var measurementLayer: some View {
		GeometryReader { proxy in
			Color.clear
				.onAppear { measure(proxy) }
				.onChange(of: state.geometry) { measure(proxy) }
		}
	}

	func measure(_ proxy: GeometryProxy) {
		contentHeight = AuxiliaryPlaneLogic.contentHeight(
			proxy: proxy,
			geometry: state.geometry
		)
	}
}
