import SwiftUI
import AVFoundation


// MARK: - Drag Gesture

private let anim = SpinAnimationConfig()

struct RewardSpinnerDragGesture {

	let store: RewardSpinnerStore
	
	// MARK: - Animations
	
	let snapFailAnimation    = Animation.interpolatingSpring(mass: anim.failSnapMass, stiffness: anim.failSnapStiffness, damping: anim.failSnapDamping)
	let snapSuccessAnimation = Animation.interpolatingSpring(mass: anim.successSnapMass, stiffness: anim.successSnapStiffness, damping: anim.successSnapDamping)
	let completionAnimation  = Animation.spring(response: anim.completionSpringResponse, dampingFraction: anim.completionSpringDamping)
	
	let toastDismissDelay = anim.toastDismissDelay
	let completionDelay   = anim.completionDelay

	var geometry: RewardSpinnerGeometry { store.geometry }

	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				guard case .idle = store.spinnerState else { return }

				let center = CGPoint(x: store.config.wheelSize / 2, y: store.config.wheelSize / 2)
				let currentAngle = angle(from: center, to: value.location)
				let physics = store.physics

				guard let last = physics.lastDragAngle else {
					physics.lastDragAngle = currentAngle
					physics.lastTimestamp = CACurrentMediaTime()
					physics.lastRotationSample = store.rotation
					return
				}

				store.rotation += normalizedDelta(currentAngle - last)
				physics.lastDragAngle = currentAngle

				let now = CACurrentMediaTime()
				if let lastTime = physics.lastTimestamp,
					 let lastRot = physics.lastRotationSample,
					 now - lastTime > 0 {
					physics.currentAngularVelocity = (store.rotation - lastRot) / (now - lastTime)
				}
				physics.lastTimestamp = now
				physics.lastRotationSample = store.rotation
			}
			.onEnded { value in
				guard case .idle = store.spinnerState else { return }
				store.physics.lastDragAngle = nil
				store.physics.lastTimestamp = nil
				store.physics.lastRotationSample = nil
				handleSpin(value)
			}
	}
}
