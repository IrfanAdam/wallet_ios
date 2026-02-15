import SwiftUI

struct CutoutAvatarCircle: View {
	
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
		
		ZStack {
			content
			
			if isCutout {
				cutoutShape
			}
		}
		.frame(width: diameter, height: diameter)
		.compositingGroup()
		.clipShape(Circle())
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
			.padding(-style.strokeWidth * 2)
	}
}
