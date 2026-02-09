import SwiftUI

struct CutoutV2AvatarStack: View {
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool
	let avatarDiameter: CGFloat   // 👈 new

	private var overlapSpacing: CGFloat {
		let overlapDistance =
		(avatarDiameter - style.strokeWidth * 2) * style.overlapRatio
		return -overlapDistance - (style.strokeWidth * 2)
	}

	var body: some View {
		HStack(spacing: overlapSpacing) {
			ForEach(avatars.indices, id: \.self) { index in
				let avatar = avatars[index]
				let isLast = index == avatars.count - 1
				let cutout = avatar.forceCutout ?? (shouldCutout && !isLast)

				CutoutV2AvatarCircle(
					avatar: avatar,
					style: style,
					isCutout: cutout,
					diameter: avatarDiameter
				)
			}
		}
		.padding(style.strokeWidth * 2)
		.background(backgroundCapsule)
		.clipShape(Capsule())
		.background(
			Capsule()
				.fill(Color.white.opacity(0.4))
		)
	}

	@ViewBuilder
	private var backgroundCapsule: some View {
		if showBorder {
			Capsule()
				.fill(style.stackBackgroundColor)
				.overlay(
					Capsule()
						.inset(by: style.strokeWidth/2)
						.stroke(style.strokeColor, lineWidth: style.strokeWidth)
				)
		}
	}
}
