import SwiftUI
import Observation

// MARK: - Height Variant Model

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
