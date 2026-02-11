import SwiftUI

struct CutoutV2AvatarStack: View {
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool

	@State private var avatarDiameter: CGFloat = 0
	@State private var isHeightLocked = false
	@State private var lastToken = UUID()

	@State private var effectiveOverlapRatio: CGFloat = 1.0
	@State private var isRasterized = false

	// MARK: - Overlap math

	private func overlapSpacing(
		for diameter: CGFloat,
		ratio: CGFloat
	) -> CGFloat {
		let overlapDistance =
		(diameter - style.strokeWidth * 2) * ratio

		return -overlapDistance - (style.strokeWidth * 2)
	}

	// MARK: - Body

	var body: some View {
		Group {
			if isHeightLocked {
				stackContent(diameter: avatarDiameter)
					.onAppear {
						// Animate after appear
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
							withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
								effectiveOverlapRatio = style.overlapRatio
							}
						}
					}
					.onChange(of: effectiveOverlapRatio) { _, newValue in
						if newValue == style.overlapRatio {
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
									Task { @MainActor in
										try? await Task.sleep(
											nanoseconds: UInt64(0.35 * 1_000_000_000)
										)
										isRasterized = true
									}
							}
						}
					}
			} else {
				GeometryReader { geo in
					stackContent(diameter: avatarDiameter)
						.onAppear {
							effectiveOverlapRatio = 1.0
							isRasterized = false
							updateDiameterIfNeeded(from: geo.size.height)
						}
						.onChange(of: geo.size.height) { _, newValue in
							updateDiameterIfNeeded(from: newValue)
						}
				}
			}
		}
	}

	// MARK: - Stack content

	@ViewBuilder
	private func stackContent(diameter: CGFloat) -> some View {
		let overlap = overlapSpacing(
			for: diameter,
			ratio: effectiveOverlapRatio
		)

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
		.opacity(isHeightLocked ? 1 : 0)
		.animation(.easeOut(duration: 0.2), value: isHeightLocked)
		.if(isRasterized) { view in
			view.drawingGroup()
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	// MARK: - Geometry → diameter locking

	private func updateDiameterIfNeeded(from height: CGFloat) {
		guard !isHeightLocked else { return }

		let proposed = height - (style.strokeWidth * 4)
		guard proposed > avatarDiameter else { return }

		avatarDiameter = proposed
		let token = UUID()
		lastToken = token

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.54) {
			if lastToken == token {
				isHeightLocked = true
				isRasterized = false
			}
		}
	}

	// MARK: - Background

	@ViewBuilder
	private var backgroundCapsule: some View {
		if showBorder {
			Capsule()
				.fill(style.stackBackgroundColor)
				.overlay(
					Capsule()
						.inset(by: style.strokeWidth / 2)
						.stroke(
							style.strokeColor,
							lineWidth: style.strokeWidth
						)
				)
		}
	}
}

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
