import SwiftUI

struct FullHeightCutoutCircle: View {
	@Environment(FullHeightCirclesContext.self)
	private var context

	let index: Int
	let avatar: AvatarData
	let totalCount: Int

	var body: some View {

		let height = context.layout.height
		let padding = context.model.style.strokeWidth
		let overlap = context.model.style.overlapRatio
		let isExpanded = context.interaction.isExpanded
		let circleDia = context.layout.circDia

		let circleOffX = (context.stackWidth * CGFloat(index)) * 0.9
		let cutoutOffX = (circleDia + padding * 0.5) * (1 - overlap) 
		let shouldCutout = avatar.isCutout ?? (index < totalCount - 1)

		Group {
			switch avatar.content {

			case .image(let image):
				image
					.resizable()
					.scaledToFill()

			case .icon(let icon):
				Circle()
					.fill(context.model.style.iconBackgroundColor)
					.overlay {
						icon
							.resizable()
							.scaledToFit()
							.foregroundStyle(context.model.style.strokeColor)
							.padding(height * 0.18)
					}
					.compositingGroup()
			}
		}
		.frame(width: height - padding * 2, height: height - padding * 2)
		.clipShape(Circle())
		.padding(padding * 2)
		.overlay {
			if avatar.hasBorder {
				Circle()
					.strokeBorder(
						context.model.style.strokeColor,
						lineWidth: context.model.style.strokeWidth
					)
			}
		}
		.clipShape(
			CutoutCircleShape(
				cutoutOffset: cutoutOffX,
				cutoutDiameter: circleDia,
				shouldCutout: shouldCutout
			),
			style: FillStyle(eoFill: true)
		)
		.opacity(isExpanded ? 1 : 0)
		.offset(x: isExpanded ? 0 : -circleOffX)
	}
}



struct CutoutCircleShape: Shape {

	var cutoutOffset: CGFloat
	var cutoutDiameter: CGFloat
	var shouldCutout: Bool

	func path(in rect: CGRect) -> Path {
		var path = Path()

		// Main circle
		path.addEllipse(in: rect)

		if shouldCutout {
			let cutoutRect = CGRect(
				x: rect.width - cutoutDiameter + cutoutOffset,
				y: (rect.height - cutoutDiameter) / 2,
				width: cutoutDiameter,
				height: cutoutDiameter
			)

			path.addEllipse(in: cutoutRect)
		}

		return path
	}
}
