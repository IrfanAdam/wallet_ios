import SwiftUI

extension FullHeightCirclesContext {

	func updateCircSize(from heightRead: CGFloat) {
		layout.circDia = max(heightRead - model.style.strokeWidth * 2, 0)
	}

	func resolveLayout() {

		let height = layout.circDia
		let spacing = -height * model.style.overlapRatio

		let totalWidth = (height + model.style.strokeWidth * 2) * CGFloat(model.count) + spacing * CGFloat(model.count - 1)

		layout.height = height
		layout.spacing = spacing
		layout.totalWidth = totalWidth
	}

	var stackWidth: CGFloat {
		//		layout.totalWidth
		interaction.animatedWidth
	}

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
