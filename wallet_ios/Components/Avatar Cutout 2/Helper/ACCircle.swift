import SwiftUI

struct CutoutV2AvatarCircle: View {
	let avatar: CutoutV2AvatarData
	let style: CutoutV2AvatarStyle
	let isCutout: Bool
	let diameter: CGFloat

	private var cutoutDiameter: CGFloat {
		diameter + (style.strokeWidth * 2)
	}

	private var cutoutOffset: CGFloat {
		(diameter - style.strokeWidth * 2) * (1 - style.overlapRatio)
	}

	var body: some View {
		ZStack {
			content
			if isCutout {
				cutoutShape
			}
		}
		.drawingGroup()
		.frame(width: diameter, height: diameter)
		.compositingGroup()
		.clipShape(Circle())
//		.overlay(border)
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
						.resizable()
						.scaledToFit()
						.padding(diameter * 0.2)
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

	@ViewBuilder
	private var border: some View {
		if avatar.hasBorder && !isCutout {
			Circle()
				.inset(by: -style.strokeWidth)
				.stroke(style.strokeColor, lineWidth: style.strokeWidth)
		}
	}
}
