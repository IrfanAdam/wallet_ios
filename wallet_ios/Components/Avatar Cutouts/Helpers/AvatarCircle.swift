import SwiftUI

// MARK: - AvatarCircle

struct AvatarCircle: View {
	// MARK: Public API
	let image: Image?
	let icon: Image?
	let isCutout: Bool
	let hasBorder: Bool
	let style: AvatarStyle

	// MARK: Init
	init(
		image: Image? = nil,
		icon: Image? = nil,
		isCutout: Bool = false,
		hasBorder: Bool = true,
		style: AvatarStyle = .default
	) {
		self.image = image
		self.icon = icon
		self.isCutout = isCutout
		self.hasBorder = hasBorder
		self.style = style
	}

	// MARK: View
	var body: some View {
		ZStack {
			contentView
			cutoutEnabler
		}
		.avatarCircleModifier(
			diameter: diameter,
			isCutout: isCutout
		) { borderView }
			.padding(.horizontal, hasBorder ? -1 * style.strokeWidth : style.strokeWidth)
			.padding(.vertical, hasBorder ? -1 * style.strokeWidth : style.strokeWidth)
	}
}

private extension View {
	func avatarCircleModifier<Border: View>(
		diameter: CGFloat,
		isCutout: Bool,
		@ViewBuilder border: () -> Border
	) -> some View {
		self
			.if(isCutout) { $0.drawingGroup() }
			.frame(width: diameter, height: diameter)
			.clipShape(Circle())
			.if(isCutout) { $0.compositingGroup() }
			.overlay(border())
	}
}

// MARK: - Geometry
private extension AvatarCircle {
	var diameter: CGFloat {
		max(0, style.circleSize - (4 * style.strokeWidth))
	}
	var strokeWidth: CGFloat { style.strokeWidth }
	var overlapRatio: CGFloat { style.overlapRatio }

	var cutoutDiameter: CGFloat {
		diameter + (strokeWidth * 2)
	}
	var cutoutOffset: CGFloat {
		(cutoutDiameter * (1 - overlapRatio) - (strokeWidth * 2))
	}
}

// MARK: - Content Rendering
private extension AvatarCircle {
	@ViewBuilder
	var contentView: some View {
		if let image {
			imageView(image)
		} else if let icon {
			iconView(icon)
		}
	}

	func imageView(_ image: Image) -> some View {
		image
			.resizable()
			.scaledToFill()
			.frame(width: diameter, height: diameter)
			.clipped()
	}

	func iconView(_ icon: Image) -> some View {
		Circle()
			.fill(Color(red: 250/255, green: 248/255, blue: 245/255))
			.overlay(
				icon
					.renderingMode(.template)
					.resizable()
					.scaledToFit()
					.padding(diameter * 0.2)
					.foregroundColor(style.strokeColor)
			)
	}
}

// MARK: - Cutout
private extension AvatarCircle {
	@ViewBuilder
	var cutoutEnabler: some View {
		if isCutout {
			Circle()
				.frame(width: cutoutDiameter, height: cutoutDiameter)
				.blendMode(.destinationOut)
				.offset(x: cutoutOffset)
		}
	}
}

// MARK: - Border
private extension AvatarCircle {
	@ViewBuilder
	var borderView: some View {
		if !isCutout && hasBorder {
			Circle()
				.stroke(style.strokeColor, lineWidth: strokeWidth)
		}
	}
}

// MARK: - Conditional Modifier
private extension View {
	@ViewBuilder
	func `if`<Content: View>(
		_ condition: Bool,
		transform: (Self) -> Content
	) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
