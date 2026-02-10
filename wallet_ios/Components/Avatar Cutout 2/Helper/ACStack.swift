import SwiftUI

struct CutoutV2AvatarStack: View {
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool

	@State private var avatarDiameter: CGFloat = 0
	@State private var isHeightLocked = false
	@State private var lastToken = UUID()

	private func overlapSpacing(for diameter: CGFloat) -> CGFloat {
		let overlapDistance =
		(diameter - style.strokeWidth * 2) * style.overlapRatio
		return -overlapDistance - (style.strokeWidth * 2)
	}

	var body: some View {
		Group {
			if isHeightLocked {
				stackContent(diameter: avatarDiameter)
			} else {
				GeometryReader { geo in
					stackContent(diameter: avatarDiameter)
						.onAppear {
							updateDiameterIfNeeded(from: geo.size.height)
						}
						.onChange(of: geo.size.height) { _, newValue in
							updateDiameterIfNeeded(from: newValue)
						}
				}
			}
		}
	}

	@ViewBuilder
	private func stackContent(diameter: CGFloat) -> some View {
		let overlap = overlapSpacing(for: diameter)

		HStack(spacing: overlap) {
			ForEach(avatars.indices, id: \.self) { index in
				let avatar = avatars[index]
				let isLast = index == avatars.count - 1
				let cutout = avatar.forceCutout ?? (shouldCutout && !isLast)

				CutoutV2AvatarCircle(
					avatar: avatar,
					style: style,
					isCutout: cutout,
					diameter: diameter
				)
			}
		}
		.padding(style.strokeWidth * 2)
		.background(backgroundCapsule)
		.clipShape(Capsule())
	}

	private func updateDiameterIfNeeded(from height: CGFloat) {
		guard !isHeightLocked else { return }

		let proposed =
		height - (style.strokeWidth * 4)

		guard proposed > avatarDiameter else { return }

		avatarDiameter = proposed
		let token = UUID()
		lastToken = token

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
			if lastToken == token {
				isHeightLocked = true
			}
		}
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
