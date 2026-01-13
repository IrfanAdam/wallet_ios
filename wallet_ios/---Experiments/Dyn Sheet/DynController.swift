import SwiftUI
import Observation

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

struct SheetGeometry {
	let size: CGSize
	let safeAreaInsets: EdgeInsets
}

@Observable
final class AuxiliarySheetState {

	var heightVariants: [HeightVariant]
	var activeIndex: Int
	var activeDetent: PresentationDetent
	var route: AuxiliaryRoute
	var geometry: SheetGeometry?

	init(
		heightVariants: [HeightVariant],
		activeIndex: Int,
		activeDetent: PresentationDetent,
		route: AuxiliaryRoute,
		geometry: SheetGeometry? = nil
	) {
		self.heightVariants = heightVariants
		self.activeIndex = activeIndex
		self.activeDetent = activeDetent
		self.route = route
		self.geometry = geometry
	}
}
