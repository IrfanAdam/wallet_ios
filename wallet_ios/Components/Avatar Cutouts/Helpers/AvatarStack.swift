import SwiftUI

struct AvatarStack: View {
	let avatars: [AvatarData]
	let avatarSize: CGFloat
	let showBackground: Bool
	let style: AvatarStyle
	let shouldCutout: Bool

	init(
		avatars: [AvatarData],
		avatarSize: CGFloat = 32,
		showBackground: Bool = false,
		style: AvatarStyle = .default,
		shouldCutout: Bool = false
	) {
		self.avatars = avatars
		self.avatarSize = avatarSize
		self.showBackground = showBackground
		self.style = style
		self.shouldCutout = shouldCutout
	}

	var body: some View {
		HStack(spacing: -(avatarSize * style.overlapRatio)) {
			ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in

				let isLast = index == avatars.count - 1
				let cutout = shouldCutout && !isLast

				switch avatar.content {
				case .image(let image):
					AvatarCircle(
						size: avatarSize,
						image: image,
						isCutout: cutout,
						hasBorder: avatar.hasBorder,
						style: style
					)

				case .icon(let icon):
					AvatarCircle(
						size: avatarSize,
						icon: icon,
						isCutout: cutout,
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
	}
}

