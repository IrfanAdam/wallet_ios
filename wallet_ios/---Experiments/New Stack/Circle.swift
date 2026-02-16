import SwiftUI

//struct FullHeightCutoutCircle: View {
//	@Environment(FullHeightCirclesContext.self)
//	private var context
//	
//	let index: Int
//	
//	var body: some View {
//		let height = context.layout.height
//		let count = context.model.count
//		let padding = context.model.padding
//		let overlap = context.model.overlap
//		let isExpanded = context.interaction.isExpanded
//		let circleDia = context.layout.circDia
//
//		let circleOffX = (context.stackWidth * CGFloat(index)) * 0.9
//		let cutoutOffX = (height - padding) * (1 - overlap)
//		
//		Circle()
//			.fill(Color.white) // background for the icon
//			.overlay {
//				Image(systemName: "person.fill") // or your custom icon
//					.resizable()
//					.scaledToFit()
//					.padding(height * 0.25) // keeps icon proportional
//					.foregroundStyle(.blue)
//			}
//		
//		Image("LargeDP")
//			.resizable()
//			.scaledToFill()
//
//			.frame(width: height, height: height)
//			.clipShape(Circle())
//			.clipShape(
//				CutoutCircleShape(
//					cutoutOffset: cutoutOffX,
//					cutoutDiameter: circleDia,
//					shouldCutout: index < count - 1
//				),
//				style: FillStyle(eoFill: true)
//			)
//			.opacity(isExpanded ? 1 : 0)
//			.offset(x: isExpanded ? 0 : -circleOffX)
//	}
//}

struct FullHeightCutoutCircle: View {
	@Environment(FullHeightCirclesContext.self)
	private var context

	let index: Int
	let avatar: AvatarData
	let totalCount: Int

	var body: some View {

		let height = context.layout.height
		let padding = context.model.padding
		let overlap = context.model.overlap
		let isExpanded = context.interaction.isExpanded
		let circleDia = context.layout.circDia

		let circleOffX = (context.stackWidth * CGFloat(index)) * 0.9
		let cutoutOffX = (height - padding) * (1 - overlap)

		let shouldCutout = avatar.isCutout ?? (index < totalCount - 1)

		Group {
			switch avatar.content {

			case .image(let image):
				image
					.resizable()
					.scaledToFill()

			case .icon(let icon):
				Circle()
					.fill(Color.white)
					.overlay {
						icon
							.resizable()
							.scaledToFit()
							.padding(height * 0.25)
					}
			}
		}
		.frame(width: height, height: height)
		.clipShape(Circle())

		// Optional border per avatar
//		.overlay {
//			if avatar.hasBorder {
//				Circle()
//					.stroke(Color.blue, lineWidth: 1.5)
//			}
//		}

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

