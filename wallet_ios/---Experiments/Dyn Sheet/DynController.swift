import SwiftUI
import Observation

@Observable
final class SheetGeometryController {

	// mirrors existing state — no behavior change
	var heightVariants: [HeightVariant]
	var activeIndex: Int
	var activeDetent: PresentationDetent
	var sheetMetrics: SheetMetrics

	init(
		heightVariants: [HeightVariant],
		activeIndex: Int,
		activeDetent: PresentationDetent,
		sheetMetrics: SheetMetrics
	) {
		self.heightVariants = heightVariants
		self.activeIndex = activeIndex
		self.activeDetent = activeDetent
		self.sheetMetrics = sheetMetrics
	}

	var detents: Set<PresentationDetent> {
		Set(heightVariants.map { .height($0.height) } + [.large])
	}

	// 🔴 IMPORTANT: native detent change only
	func selectVariant(_ index: Int) {
		guard heightVariants.indices.contains(index) else { return }
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	func selectLarge() {
		activeDetent = .large
	}
}
