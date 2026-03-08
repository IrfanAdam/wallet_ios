import SwiftUI
import AVFoundation

// MARK: - Drag Gesture

private let anim = SpinAnimationConfig()

struct RewardSpinnerDragGesture {
	let store: RewardSpinnerStore
}

// MARK: - Animations

extension RewardSpinnerDragGesture {
	var snapFailAnimation:    Animation { .interpolatingSpring(mass: anim.failSnapMass,    stiffness: anim.failSnapStiffness,    damping: anim.failSnapDamping) }
	var snapSuccessAnimation: Animation { .interpolatingSpring(mass: anim.successSnapMass, stiffness: anim.successSnapStiffness, damping: anim.successSnapDamping) }
	var completionAnimation:  Animation { .spring(response: anim.completionSpringResponse, dampingFraction: anim.completionSpringDamping) }
	
	var toastDismissDelay: Double { anim.toastDismissDelay }
	var completionDelay:   Double { anim.completionDelay }
}

// MARK: - Geometry

extension RewardSpinnerDragGesture {
	var geometry:    RewardSpinnerGeometry { store.geometry }
	var wheelCenter: CGPoint               { CGPoint(x: store.config.wheelSize / 2, y: store.config.wheelSize / 2) }
}

// MARK: - Gesture

extension RewardSpinnerDragGesture {
	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged(handleDragChanged)
			.onEnded(handleDragEnded)
	}
}

// MARK: - Drag Handling

extension RewardSpinnerDragGesture {
	private func handleDragChanged(_ value: DragGesture.Value) {
		guard case .idle = store.spinnerState else { return }
		
		let currentAngle = angle(from: wheelCenter, to: value.location)
		let physics      = store.physics
		
		guard let lastAngle = physics.lastDragAngle else {
			seedPhysics(physics, angle: currentAngle)
			return
		}
		
		store.rotation += normalizedDelta(currentAngle - lastAngle)
		updateVelocity(physics, currentAngle: currentAngle)
	}
	
	private func handleDragEnded(_ value: DragGesture.Value) {
		guard case .idle = store.spinnerState else { return }
		clearPhysics(store.physics)
		handleSpin(value)
	}
}

// MARK: - Physics

extension RewardSpinnerDragGesture {
	private func seedPhysics(_ physics: RewardSpinnerPhysics, angle: Double) {
		physics.lastDragAngle      = angle
		physics.lastTimestamp      = CACurrentMediaTime()
		physics.lastRotationSample = store.rotation
	}
	
	private func updateVelocity(_ physics: RewardSpinnerPhysics, currentAngle: Double) {
		let now = CACurrentMediaTime()
		
		if let lastTime = physics.lastTimestamp,
			 let lastRot  = physics.lastRotationSample,
			 now - lastTime > 0 {
			physics.currentAngularVelocity = (store.rotation - lastRot) / (now - lastTime)
		}
		
		physics.lastDragAngle      = currentAngle
		physics.lastTimestamp      = now
		physics.lastRotationSample = store.rotation
	}
	
	private func clearPhysics(_ physics: RewardSpinnerPhysics) {
		physics.lastDragAngle      = nil
		physics.lastTimestamp      = nil
		physics.lastRotationSample = nil
	}
}
