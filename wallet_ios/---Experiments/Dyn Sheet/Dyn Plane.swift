import SwiftUI

// MARK: - Auxiliary Plane Container

struct AuxiliaryPlaneContainer<Content: View>: View {

	@Environment(AuxiliarySheetState.self)
	private var state

	@State private var contentHeight: CGFloat = 0

	@ViewBuilder
	let content: (_ resize: @escaping (CGFloat) -> Void) -> Content

	// MARK: - Body

	var body: some View {
		VStack(spacing: 16) {
			detentRow
			content(resize)
		}
		.padding()
		.background(measurementLayer)
		.task(id: contentHeight) {
			AuxiliaryPlaneLogic.handleContentHeightChange(
				contentHeight: contentHeight,
				state: state,
				resize: resize
			)
		}
	}
}

// MARK: - UI Components

private extension AuxiliaryPlaneContainer {

	var detentRow: some View {
		HStack(spacing: 12) {
			Button("Large") {
				AuxiliaryPlaneLogic.selectLarge(state: state)
			}
			.buttonStyle(.bordered)

			Button("Content") {
				AuxiliaryPlaneLogic.resizeToContent(
					contentHeight: contentHeight,
					state: state,
					resize: resize
				)
			}
			.buttonStyle(.borderedProminent)
		}
	}

	var measurementLayer: some View {
		GeometryReader { proxy in
			Color.clear
				.onAppear {
					contentHeight =
					AuxiliaryPlaneLogic.measureContentHeight(
						proxy: proxy,
						geometry: state.geometry
					)
				}
		}
	}
}

// MARK: - Resize Bridge

private extension AuxiliaryPlaneContainer {

	func resize(_ newHeight: CGFloat) {
		AuxiliaryPlaneLogic.resize(
			to: newHeight,
			state: state
		)
	}
}

