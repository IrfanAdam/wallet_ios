import SwiftUI

struct AuxiliarySheetCoordinator {
	let state: AuxiliarySheetState
	func navigateBack() {
		withAnimation(.easeInOut(duration: 0.35)) {
			guard let previous = state.route.previous else { return }
			state.route = previous
		}
	}
	
	func syncGeometry(_ proxy: GeometryProxy) {
		let height = proxy.size.height
		print("📏 Sheet height:", height)

		state.geometry = SheetGeometry(
			size: proxy.size,
			safeAreaInsets: proxy.safeAreaInsets
		)
	}
	
	var detents: Set<PresentationDetent> {
		Set(state.heightVariants.map { .height($0.height) } /*+ [.large]*/)
	}
}
