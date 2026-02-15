import SwiftUI

struct CutoutAvatarStackContent: View {
	@Environment(CutoutAvatarStackContext.self)
	private var context
	
	var body: some View {
		HStack(spacing: context.layout.overlapSpacing) {
			ForEach(Array(context.model.avatars.enumerated()), id: \.offset) { index, avatar in
				
				let avatar = context.model.avatars[index]
				let isLast = index == context.model.avatars.count - 1
				
				let cutout = avatar.forceCutout ?? (context.model.shouldCutout && !isLast)
				
				CutoutAvatarCircle(
					avatar: avatar,
					style: context.model.style,
					isCutout: cutout,
					diameter: context.layout.avatarDiameter
				)
				.offset(
					x: context.animation.animateIn ? 0 : -(context.layout.avatarDiameter * CGFloat(index))
				)
			}
		}
		.padding(context.model.style.strokeWidth * 2)
		.opacity(context.animation.animateIn ? 1 : 0)
		.if(context.animation.isRasterized) { $0.drawingGroup() }
		.background(
			CutoutAvatarStackBackground()
				.environment(context)
		)
	}
}

struct CutoutAvatarStackBackground: View {
	
	@Environment(CutoutAvatarStackContext.self)
	private var context
	
	var body: some View {
		Capsule()
			.fill(
				context.model.style.stackBackgroundColor
					.opacity(context.animation.animateIn ? 1 : 0)
			)
			.overlay {
				if context.model.showBorder {
					Capsule()
						.inset(by: context.model.style.strokeWidth / 2)
						.stroke(
							context.model.style.strokeColor,
							lineWidth: context.model.style.strokeWidth
						)
				}
			}
	}
}

// MARK: - Conditional Modifier Helper

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
