import SwiftUI

@Observable
final class CutoutV2AvatarStackAnimator {
	
	var animateIn = false
	var isRasterized = false
	
	func triggerEntrance() {
		animateIn = false
		
		DispatchQueue.main.async {
			withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
				self.animateIn = true
			}
		}
	}
	
	func scheduleRasterization() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			Task { @MainActor in
				try? await Task.sleep(
					nanoseconds: UInt64(0.35 * 1_000_000_000)
				)
				self.isRasterized = true
			}
		}
	}
	
	func disableRasterization() {
		isRasterized = false
	}
}
