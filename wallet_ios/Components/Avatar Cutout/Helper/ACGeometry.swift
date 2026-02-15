import SwiftUI

@Observable
final class CutoutV2AvatarStackGeometry {
	var avatarDiameter: CGFloat = 0
	
	func updateDiameterIfNeeded(
		height: CGFloat,
		strokeWidth: CGFloat
	) {
		
		let proposed = height - (strokeWidth * 4)
		guard proposed > avatarDiameter else { return }
		
		avatarDiameter = proposed
	}
}
