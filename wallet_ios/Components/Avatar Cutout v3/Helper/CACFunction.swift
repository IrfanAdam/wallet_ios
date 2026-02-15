import SwiftUI

extension CutoutAvatarStackContext {
	func updateContainerHeight(_ height: CGFloat) {
		print("Container height:", height)
		layout.containerHeight = height
		resolveLayout()
	}
}

private extension CutoutAvatarStackContext {
	func resolveLayout() {
		
		let stroke = model.style.strokeWidth
		let count = CGFloat(model.avatars.count)
		
		let diameter = max(layout.containerHeight - (stroke * 4), 0)
		
		let overlapDistance = (diameter - stroke * 2) * model.style.overlapRatio
		
		let overlapSpacing = -overlapDistance - (stroke * 2)
		
		let totalWidth = (diameter * count) - (model.style.overlapRatio * diameter * (count - 1))
		
		layout.avatarDiameter = diameter
		layout.overlapSpacing = overlapSpacing
		layout.totalWidth = totalWidth
	}
}

extension CutoutAvatarStackContext {
	func triggerEntrance() {
		
		animation.animateIn = false
		animation.isRasterized = false
		
		DispatchQueue.main.async {
			withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
				self.animation.animateIn = true
			}
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
			self.animation.isRasterized = true
		}
	}
}
