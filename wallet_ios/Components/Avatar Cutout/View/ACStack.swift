import SwiftUI

struct CutoutV2AvatarStack: View {
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool

	@State private var effectiveOverlapRatio: CGFloat = 1.0
	@State private var isRasterized = false
	
	@State private var geometry = CutoutV2AvatarStackGeometry()
	@State private var animator = CutoutV2AvatarStackAnimator()

	var body: some View {
		let stackWidth = CutoutV2AvatarStackLayout.totalWidth(
			diameter: geometry.avatarDiameter,
			overlapRatio: style.overlapRatio,
			strokeWidth: style.strokeWidth,
			count: avatars.count
		)
		GeometryReader { geo in
			CutoutV2AvatarStackContent(
				avatars: avatars,
				style: style,
				shouldCutout: shouldCutout,
				showBorder: showBorder,
				diameter: geometry.avatarDiameter,
				animator: animator
			)
				.onAppear {
					print("Height onAppear:", geo.size.height)
					animator.disableRasterization()
					geometry.updateDiameterIfNeeded(
						height: geo.size.height,
						strokeWidth: style.strokeWidth
					)
				}
				.onChange(of: geo.size.height) { _, newValue in
					print("Height changed:", newValue)
					geometry.updateDiameterIfNeeded(
						height: newValue,
						strokeWidth: style.strokeWidth
					)
				}
		}
		.onChange(of: stackWidth) { _, newValue in
			print("Final width:", stackWidth)
			animator.scheduleRasterization()
		}
		.frame(width: stackWidth, alignment: .leading)
	}
}
