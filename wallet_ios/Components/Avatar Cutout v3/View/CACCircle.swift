import SwiftUI

struct CutoutAvatarCircle: View {
	
	@Environment(CutoutAvatarStackContext.self)
	private var context
	
	let avatar: CutoutAvatarData
	let style: CutoutAvatarStyle
	let isCutout: Bool
	let diameter: CGFloat
	
	private var cutoutDiameter: CGFloat {
		diameter + (style.strokeWidth * 2)
	}
	
	private var cutoutOffset: CGFloat {
		(diameter - style.strokeWidth * 2) * (1 - style.overlapRatio)
	}
	
	private var iconPadding: CGFloat {
		diameter * 0.2
	}
	
	var body: some View {
		content.overlay {
			if isCutout {
				cutoutShape
			}
		}
		.offset(
			x: context.animation.animateIn ? 0 : -(context.layout.avatarDiameter)
		)
		.opacity(context.animation.animateIn ? 1 : 0)
		.clipShape(Circle())
		.frame(width: diameter, height: diameter)
		.compositingGroup()
	}
	
	@ViewBuilder
	private var content: some View {
		
		switch avatar.content {
			
		case .image(let image):
			image
				.resizable()
				.scaledToFill()
			
		case .icon(let icon):
			Circle()
				.fill(style.iconBackgroundColor)
				.overlay(
					icon
						.renderingMode(.template)
						.resizable()
						.scaledToFit()
						.padding(iconPadding)
						.foregroundColor(style.strokeColor)
				)
		}
	}
	
	private var cutoutShape: some View {
		
		Circle()
			.frame(width: cutoutDiameter, height: cutoutDiameter)
			.offset(x: cutoutOffset)
			.blendMode(.destinationOut)
//			.padding(-style.strokeWidth * 2)
	}
}
