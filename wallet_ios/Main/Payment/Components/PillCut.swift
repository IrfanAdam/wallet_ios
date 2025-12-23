import SwiftUI

struct AvatarStyle {
	let strokeWidth: CGFloat
	let strokeColor: Color
	let iconBackgroundColor: Color
	let stackBackgroundColor: Color
	let overlapRatio: CGFloat

	static let `default` = AvatarStyle(
		strokeWidth: 1.5,
		strokeColor: .blue,
		iconBackgroundColor: .white.opacity(0.9),
		stackBackgroundColor: .white,
		overlapRatio: 0.2
	)
}


enum AvatarContent {
	case image(Image)
	case icon(Image)
}

struct AvatarData: Identifiable {
	let id = UUID()
	let content: AvatarContent
	let hasBorder: Bool
	
	init(content: AvatarContent, hasBorder: Bool = true) {
		self.content = content
		self.hasBorder = hasBorder
	}
}

@ViewBuilder
func AvatarCircle(
	size: CGFloat,
	image: Image? = nil,
	icon: Image? = nil,
	isCutout: Bool = false,
	hasBorder: Bool = true,
	style: AvatarStyle
) -> some View {

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
			ZStack {
				Circle().fill(style.iconBackgroundColor)

				icon
					.renderingMode(.template)
					.resizable()
					.scaledToFit()
					.padding(diameter * 0.2)
					.foregroundColor(style.strokeColor)
			}
		}

		if isCutout {
			Circle()
				.frame(width: cutoutDiameter, height: cutoutDiameter)
				.blendMode(.destinationOut)
				.offset(x: cutoutOffset)
		}
	}
	.compositingGroup()
	.frame(width: diameter, height: diameter)
	.clipShape(Circle())
	.overlay {
		if !isCutout && hasBorder {
			Circle()
				.stroke(style.strokeColor, lineWidth: strokeWidth)
		}
	}
}

struct AvatarStack: View {
	let avatars: [AvatarData]
	let avatarSize: CGFloat
	let showBackground: Bool
	let style: AvatarStyle

	init(
		avatars: [AvatarData],
		avatarSize: CGFloat = 32,
		showBackground: Bool = false,
		style: AvatarStyle = .default
	) {
		self.avatars = avatars
		self.avatarSize = avatarSize
		self.showBackground = showBackground
		self.style = style
	}

	var body: some View {
		HStack(spacing: -(avatarSize * style.overlapRatio)) {
			ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in
				let isLast = index == avatars.count - 1

				switch avatar.content {
				case .image(let image):
					AvatarCircle(
						size: avatarSize,
						image: image,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder,
						style: style
					)

				case .icon(let icon):
					AvatarCircle(
						size: avatarSize,
						icon: icon,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder,
						style: style
					)
				}
			}
		}
		.padding(style.strokeWidth) // inner clearance only
		.background {
			if showBackground {
				RoundedRectangle(
					cornerRadius: avatarSize / 2,
					style: .continuous
				)
				.fill(style.stackBackgroundColor)
			}
		}
		.drawingGroup()
	}
}
