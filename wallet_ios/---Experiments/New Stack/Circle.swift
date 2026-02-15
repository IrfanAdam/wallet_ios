import SwiftUI

struct FullHeightCutoutCircle: View {
	@Environment(FullHeightCirclesContext.self)
	private var context
	
	let index: Int
	
	var body: some View {
		let height = context.layout.height
//		let spacing = context.layout.spacing
		let count = context.model.count
		let padding = context.model.padding
		let overlap = context.model.overlap
		let isExpanded = context.interaction.isExpanded
		
//		let circleDia = height + padding / 2
		let circleDia = context.layout.circDia
		
//		let circleOffX = -collapseStep * CGFloat(index) * 0.5
		let circleOffX = (context.stackWidth * CGFloat(index)) * 0.9
		let cutoutOffX = (height - padding) * (1 - overlap)
		
		Circle()
			.fill(Color.white) // background for the icon
			.overlay {
				Image(systemName: "person.fill") // or your custom icon
					.resizable()
					.scaledToFit()
					.padding(height * 0.25) // keeps icon proportional
					.foregroundStyle(.blue)
			}
			.frame(width: height, height: height)
			.overlay {
				if index < count - 1 {
					Circle()
						.frame(width: circleDia, height: circleDia)
						.offset(x: cutoutOffX)
						.blendMode(.destinationOut)
				}
			}
			.opacity(isExpanded ? 1 : 0)
			.offset(x: isExpanded ? 0 : -circleOffX)
			.compositingGroup()
	}
}
