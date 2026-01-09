import SwiftUI

// MARK: - Auxiliary Plane Container

struct AuxiliaryPlaneContainer<Content: View>: View {

	// MARK: - Bindings

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent
	@Binding var route: AuxiliaryRoute

	// MARK: - Environment

	@Environment(SheetMetrics.self) private var sheetMetrics

	// MARK: - State

	@State private var contentHeight: CGFloat = 0

	// MARK: - Configuration

	let sheetGeometry: SheetGeometry
	@ViewBuilder let content: (_ resize: @escaping (CGFloat) -> Void) -> Content

	// MARK: - Body

	var body: some View {
		VStack(spacing: 16) {
			detentRow
			content(resize)
		}
		.padding()
		.background(measurementLayer)
		.task(id: contentHeight, handleContentHeightChange)
	}
}

// MARK: - UI Components
private extension AuxiliaryPlaneContainer {

	var detentRow: some View {
		HStack(spacing: 12) {
			ForEach(heightVariants.indices, id: \.self) { index in
				Button(heightVariants[index].id.capitalized) {
					select(index)
				}
				.buttonStyle(.borderedProminent)
			}

			Button("Native Large", action: selectLarge)
			Button("Content Size", action: resizeToContent)
		}
	}

	var measurementLayer: some View {
		GeometryReader { proxy in
			Color.clear.onAppear {
				updateMeasuredHeight(from: proxy)
			}
		}
	}
}

// MARK: - Intent & Logic
private extension AuxiliaryPlaneContainer {

	func handleContentHeightChange() {
		guard contentHeight > 0 else { return }
		resize(to: contentHeight)
	}

	func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	func selectLarge() {
		activeDetent = .large
	}

	func resizeToContent() {
		resize(to: contentHeight)
	}

	func resize(to newHeight: CGFloat) {
		let next = (activeIndex + 1) % heightVariants.count
		withAnimation(.easeInOut(duration: 0.35)) {
			heightVariants[next].height = newHeight
			activeIndex = next
			activeDetent = .height(newHeight)
		}
	}
}

// MARK: - Measurement Helpers
private extension AuxiliaryPlaneContainer {
	func updateMeasuredHeight(from proxy: GeometryProxy) {
		let measured =
		proxy.size.height
		+ sheetGeometry.safeAreaInsets.top
		+ sheetGeometry.safeAreaInsets.bottom

		contentHeight = measured
		sheetMetrics.height = measured
	}
}
