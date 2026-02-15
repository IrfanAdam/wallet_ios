import SwiftUI

struct CutoutV2AvatarStackContent: View {
	
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool
	let diameter: CGFloat
	
	@Bindable var animator: CutoutV2AvatarStackAnimator
	
	var body: some View {
		
		let overlap = CutoutV2AvatarStackLayout.overlapSpacing(
			diameter: diameter,
			strokeWidth: style.strokeWidth,
			overlapRatio: style.overlapRatio
		)
		
		let step = diameter + overlap * 0.2
		
		HStack(spacing: overlap) {
			ForEach(avatars.indices, id: \.self) { index in
				let avatar = avatars[index]
				let isLast = index == avatars.count - 1
				let cutout =
				avatar.forceCutout ?? (shouldCutout && !isLast)
				
				CutoutV2AvatarCircle(
					avatar: avatar,
					style: style,
					isCutout: cutout,
					diameter: diameter
				)
				.offset(
					x: animator.animateIn
					? 0
					: -(step * CGFloat(index + 1)) * CGFloat(index)
				)
			}
		}
		.padding(style.strokeWidth * 2)
		.opacity(animator.animateIn ? 1 : 0)
		.if(animator.isRasterized) { $0.drawingGroup() }
		.onAppear {
			animator.triggerEntrance()
		}
		.fixedSize(horizontal: true, vertical: false)
		.background(
			CutoutV2AvatarStackBackground(
				style: style,
				showBorder: showBorder,
				isVisible: animator.animateIn
			)
		)
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
