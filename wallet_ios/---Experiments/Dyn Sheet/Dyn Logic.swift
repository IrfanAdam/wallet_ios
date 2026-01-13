import SwiftUI

enum AuxiliaryPlaneLogic {

	static func handleContentHeightChange(
		contentHeight: CGFloat,
		state: AuxiliarySheetState,
		resize: (CGFloat) -> Void
	) {
		guard contentHeight > 0 else { return }
		resize(contentHeight)
	}

	static func selectLarge(state: AuxiliarySheetState) {
		state.activeDetent = .large
	}

	static func resizeToContent(
		contentHeight: CGFloat,
		state: AuxiliarySheetState,
		resize: (CGFloat) -> Void
	) {
		guard contentHeight > 0 else { return }
		resize(contentHeight)
	}

	static func resize(
		to newHeight: CGFloat,
		state: AuxiliarySheetState
	) {
		let next = (state.activeIndex + 1) % state.heightVariants.count

		withAnimation(.easeInOut(duration: 0.35)) {
			state.heightVariants[next].height = newHeight
			state.activeIndex = next
			state.activeDetent = .height(newHeight)
		}
	}

	static func measureContentHeight(
		proxy: GeometryProxy,
		geometry: SheetGeometry?
	) -> CGFloat {
		guard let geometry else { return 0 }

		return proxy.size.height
		+ geometry.safeAreaInsets.top
		+ geometry.safeAreaInsets.bottom
	}
}
