import SwiftUI
import Observation

@Observable
final class FullHeightCirclesContext {
	
	// MARK: - Model
	
	struct Model {
		let count: Int
		let style: AvatarStyle
	}
	
	// MARK: - Layout
	
	struct Layout {
		/// heightRead
		var height: CGFloat = 0
		/// height defined for circle
		var circDia: CGFloat = 0
		var spacing: CGFloat = 0
		var totalWidth: CGFloat = 0
	}
	
	// MARK: - Interaction
	
	struct Interaction {
		var isExpanded: Bool = false
		var animatedWidth: CGFloat = 0
	}
	
	// MARK: - Animation
	
	struct Animation {
		var hasAppeared: Bool = false
	}
	
	// MARK: - Stored Sections
	
	let model: Model
	var layout = Layout()
	var interaction = Interaction()
	var animation = Animation()
	
	// MARK: - Init
	
	init(
		count: Int = 4,
		style: AvatarStyle
	) {
		self.model = Model(
			count: count,
			style: style
		)
	}
}
