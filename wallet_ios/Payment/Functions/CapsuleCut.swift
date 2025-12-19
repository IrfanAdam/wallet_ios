import SwiftUI

enum AvatarTokens {
	static let size: CGFloat = 36
	static let overlapRatio: CGFloat = 0.2
	static let strokeWidth: CGFloat = 2.25
}

enum AvatarContent {
	case image(Image)
	case icon(Image, backgroundColor: Color = .white)
}

struct AvatarData: Identifiable {
	let id = UUID()
	let content: AvatarContent
}

@ViewBuilder
func AvatarCircle(
	size: CGFloat = AvatarTokens.size,
	strokeWidth: CGFloat = AvatarTokens.strokeWidth,
	image: Image? = nil,
	icon: Image? = nil,
	isCutout: Bool = false,
	iconBackground: Color = .white,
	strokeColor: Color = .white
) -> some View {

	let diameter = size
	let overlap = AvatarTokens.overlapRatio

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
				Circle().fill(iconBackground)

				icon
					.resizable()
					.scaledToFit()
					.padding(diameter * 0.2)
					.foregroundColor(Color.blue)
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
	.overlay(
		Group {
			if !isCutout {
				Circle()
					.stroke(strokeColor, lineWidth: strokeWidth)
			}
		}
	)
}

struct AvatarStack: View {
	let avatars: [AvatarData]
	let avatarSize: CGFloat
	let strokeWidth: CGFloat
	let strokeColor: Color
	let showBackground: Bool

	init(
		avatars: [AvatarData],
		avatarSize: CGFloat = 34,
		strokeWidth: CGFloat = AvatarTokens.strokeWidth,
		strokeColor: Color = .blue,
		showBackground: Bool = false
	) {
		self.avatars = avatars
		self.avatarSize = avatarSize
		self.strokeWidth = strokeWidth
		self.strokeColor = strokeColor
		self.showBackground = showBackground
	}

	var body: some View {
		HStack(spacing: -(avatarSize * AvatarTokens.overlapRatio)) {
			ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in
				let isLast = index == avatars.count - 1

				switch avatar.content {
				case .image(let image):
					AvatarCircle(
						size: avatarSize,
						strokeWidth: strokeWidth,
						image: image,
						isCutout: !isLast,
						strokeColor: strokeColor
					)

				case .icon(let icon, let backgroundColor):
					AvatarCircle(
						size: avatarSize,
						strokeWidth: strokeWidth,
						icon: icon,
						isCutout: !isLast,
						iconBackground: backgroundColor,
						strokeColor: strokeColor
					)
				}
			}
		}
		.padding(2) // Inner padding for stroke
		.background {
			if showBackground {
				RoundedRectangle(cornerRadius: 32, style: .continuous)
					.fill(Color.white)
			}
		}
		.overlay(
			Capsule()
				.strokeBorder(strokeColor, lineWidth: strokeWidth)
		)
		.drawingGroup() // Single compositing operation for the entire stack
	}
}

struct CombinedStacksView: View {

	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card"))),
	]

	var body: some View {
		NavigationStack {
			ZStack {
				Color.mint.ignoresSafeArea()

				AvatarStack(
					avatars: avatars,
					avatarSize: AvatarTokens.size,
					showBackground: true
				)
			}
		}
	}
}

#Preview {
	CombinedStacksView()
}
