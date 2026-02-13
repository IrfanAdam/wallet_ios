import SwiftUI
import Observation

@Observable
final class FullHeightCirclesContext {

	struct Model {
		let count: Int
		let overlap: CGFloat
		let padding: CGFloat
	}

	struct Layout {
		var height: CGFloat = 0
		var spacing: CGFloat = 0
		var totalWidth: CGFloat = 0
		var stackWidth: CGFloat = 0
	}

	struct Animation {
		var isExpanded: Bool = false
	}

	let model: Model
	var layout = Layout()
	var animation = Animation()

	init(
		count: Int = 3,
		overlap: CGFloat = 0.12,
		padding: CGFloat = 4
	) {
		self.model = Model(
			count: count,
			overlap: overlap,
			padding: padding
		)
	}

	func updateLayout(from proxy: GeometryProxy) {
		let height = max(proxy.size.height - model.padding * 2, 0)
		let spacing = -height * model.overlap
		let totalWidth =
		height * CGFloat(model.count) +
		spacing * CGFloat(model.count - 1) +
		model.padding * 2

		layout.height = height
		layout.spacing = spacing
		layout.totalWidth = totalWidth
	}

	func spread() {
		animation.isExpanded = false
		withAnimation(.spring(response: 0.36, dampingFraction: 0.8).delay(0.2)) {
			animation.isExpanded = true
		}
	}

//	func expand() {
//		stackWidth = Layout.height
//		withAnimation(.spring(response: 0.36, dampingFraction: 0.8).delay(0.2)) {
//			stackWidth = Layout.totalWidth
//		}
//	}
}
