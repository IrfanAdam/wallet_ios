import SwiftUI

struct AvatarStack: View {
	let avatars: [AvatarData]
	let style: AvatarStyle
	let shouldCutout: Bool

	private var avatarSize: CGFloat {
		style.circleSize - (4 * style.strokeWidth)
	}

	init(
		avatars: [AvatarData],
		style: AvatarStyle = .default,
		shouldCutout: Bool = false
	) {
		self.avatars = avatars
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
						image: image,
						isCutout: cutout,
						hasBorder: avatar.hasBorder,
						style: style
					)

				case .icon(let icon):
					AvatarCircle(
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
			if !shouldCutout {
				RoundedRectangle(
					cornerRadius: avatarSize / 2,
					style: .continuous
				)
				.fill(style.stackBackgroundColor)
			}
		}
	}
}

