import SwiftUI

enum AvatarContent {
	case image(Image)
	case icon(Image)
}

struct AvatarCircle: View {
	let size: CGFloat
	let image: Image?
	let icon: Image?
	let isCutout: Bool
	let hasBorder: Bool
	let style: AvatarStyle

	init(
		size: CGFloat,
		image: Image? = nil,
		icon: Image? = nil,
		isCutout: Bool = false,
		hasBorder: Bool = true,
		style: AvatarStyle = .default
	) {
		self.size = size
		self.image = image
		self.icon = icon
		self.isCutout = isCutout
		self.hasBorder = hasBorder
		self.style = style
	}

	var body: some View {
		let diameter = size
		let strokeWidth = style.strokeWidth
		let overlap = style.overlapRatio

		let cutoutDiameter = diameter + (strokeWidth * 2)
		let cutoutOffset = (cutoutDiameter * (1 - overlap) - (strokeWidth * 2))

		ZStack {
			if let image {
				image
					.resizable()
					.scaledToFill()
					.frame(width: diameter, height: diameter)
					.clipped()
			} else if let icon {
					Circle()
						.fill(style.iconBackgroundColor)
						.overlay(
							icon
								.renderingMode(.template)
								.resizable()
								.scaledToFit()
								.padding(diameter * 0.2)
								.foregroundColor(style.strokeColor)
						)
			}

			if isCutout {
				Circle()
					.frame(width: cutoutDiameter, height: cutoutDiameter)
					.blendMode(.destinationOut)
					.offset(x: cutoutOffset)
			}
		}
		.drawingGroup()
		.frame(width: diameter, height: diameter)
		.clipShape(Circle())
		.if(isCutout) { view in
			view.compositingGroup()
		}
		.overlay {
			if !isCutout && hasBorder {
				Circle()
					.stroke(style.strokeColor, lineWidth: strokeWidth)
			}
		}
	}
}


extension View {
	@ViewBuilder
	func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
