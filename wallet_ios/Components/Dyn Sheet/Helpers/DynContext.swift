import SwiftUI
import Observation

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

struct SheetGeometry: Equatable {
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
		heightVariants: [HeightVariant] = [
			.init(id: "A", height: 140),
			.init(id: "B", height: 320),
			.init(id: "C", height: 720)
		],
		activeIndex: Int = 1,
		activeDetent: PresentationDetent = .height(320),
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


@Observable
final class AuxiliaryContentState {
	var route: AuxiliaryRoute

	init(
		route: AuxiliaryRoute
	) {
		self.route = route
	}
}
