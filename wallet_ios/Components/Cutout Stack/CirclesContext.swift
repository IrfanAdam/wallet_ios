import SwiftUI
import Observation

@Observable
final class FullHeightCirclesContext {
	
	// MARK: - Model
	
	struct Model {
		let count: Int
		let overlap: CGFloat
		let padding: CGFloat
//		let style: AvatarStyle
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
		overlap: CGFloat = 0.12,
		padding: CGFloat = 1.5,
//		style: AvatarStyle
	) {
		self.model = Model(
			count: count,
			overlap: overlap,
			padding: padding,
//			style: style
		)
	}
	
	// MARK: - Geometry Input
	
	/// Only updates raw bounds from GeometryReader
	func updateCircSize(from heightRead: CGFloat) {
		layout.circDia = max(heightRead - model.padding * 2, 0)
	}
	
	// MARK: - Layout Commit
	
	/// Commits layout using current bounds
	func resolveLayout() {
		
		let height = layout.circDia
		let spacing = -height * model.overlap
		let totalWidth =
		height * CGFloat(model.count)
		+ spacing * CGFloat(model.count - 1)
		+ model.padding * 2
		
		layout.height = height
		layout.spacing = spacing
		layout.totalWidth = totalWidth
	}
	
	// MARK: - Derived
	
	var stackWidth: CGFloat {
//		layout.totalWidth
		interaction.animatedWidth
	}

	// MARK: - Interaction
	
	func spread() {
		interaction.isExpanded = false
		interaction.animatedWidth = layout.height

		withAnimation(.easeOut(duration: 0.25)) {
			interaction.animatedWidth = layout.totalWidth
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
				self.interaction.isExpanded = true
			}
		}
	}
}


