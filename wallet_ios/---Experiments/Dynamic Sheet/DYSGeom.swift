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
final class SheetMetrics {
	var height: CGFloat = 0
	var size: CGSize = .zero
	var safeAreaInsets: EdgeInsets = .init()
}

// MARK: - Routing

enum AuxiliaryRoute {
	case levelOne
	case levelTwo
}

struct BlurModifier: ViewModifier {
	let radius: CGFloat
	func body(content: Content) -> some View {
		content.blur(radius: radius)
	}
}

@Observable
final class DetentController {

	var heightVariants: [HeightVariant]
	var activeIndex: Int
	var activeDetent: PresentationDetent

	init(
		heightVariants: [HeightVariant],
		activeIndex: Int,
		activeDetent: PresentationDetent
	) {
		self.heightVariants = heightVariants
		self.activeIndex = activeIndex
		self.activeDetent = activeDetent
	}

	// MARK: - Actions

	func select(index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
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
