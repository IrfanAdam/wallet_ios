import SwiftUI

enum AuxiliaryPlaneLogic {

	static func contentHeight(
		proxy: GeometryProxy,
		geometry: SheetGeometry?
	) -> CGFloat {
		guard let geometry else { return 0 }

		return proxy.size.height
		+ geometry.safeAreaInsets.top
		+ geometry.safeAreaInsets.bottom
	}

	static func resizeToContent(
		_ height: CGFloat,
		state: AuxiliarySheetState
	) {
		guard height > 0 else { return }
		resize(to: height, state: state)
	}
	
	static func resize(
		to newHeight: CGFloat,
		state: AuxiliarySheetState
	) {
		let nextIndex =
		(state.activeIndex + 1) % state.heightVariants.count

		withAnimation(.easeInOut(duration: 0.35)) {
			state.heightVariants[nextIndex].height = newHeight
			state.activeIndex = nextIndex
			state.activeDetent = .height(newHeight)
		}
	}

	static func selectLarge(
		state: AuxiliarySheetState
	) {
		state.activeDetent = .large
	}
}
