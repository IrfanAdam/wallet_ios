import SwiftUI

struct CutoutV2AvatarStackLayout {
	
	static func overlapSpacing(
		diameter: CGFloat,
		strokeWidth: CGFloat,
		overlapRatio: CGFloat
	) -> CGFloat {
		let overlapDistance =
		(diameter - strokeWidth * 2) * overlapRatio
		
		return -overlapDistance - (strokeWidth * 2)
	}
	
	static func totalWidth(
		diameter: CGFloat,
		overlapRatio: CGFloat,
		strokeWidth: CGFloat,
		count: Int
	) -> CGFloat {
		let count = CGFloat(count)
		let negSpace = overlapRatio * diameter
		
		let baseWidth =
		(diameter * count) - (negSpace * (count - 1))
		
		return baseWidth + (strokeWidth * 2)
	}
}

struct CutoutV2AvatarStackBackground: View {
	let style: CutoutV2AvatarStyle
	let showBorder: Bool
	let isVisible: Bool
	
	var body: some View {
		Capsule()
			.fill(style.stackBackgroundColor.opacity(isVisible ? 1 : 0))
			.overlay {
				if showBorder {
					Capsule()
						.inset(by: style.strokeWidth / 2)
						.stroke(
							style.strokeColor,
							lineWidth: style.strokeWidth
						)
				}
			}
	}
}
