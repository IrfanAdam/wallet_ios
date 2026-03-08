import SwiftUI
import AVFoundation

// MARK: - Drag Gesture

//private let anim = SpinAnimationConfig()

struct RewardSpinnerDragGesture {
	let store: RewardSpinnerStore
	var animConfig: RewardSpinnerAnimationConfig.Spin { store.animations.spin }
	var anim: RewardSpinnerAnimState {
		get { store.anim }
		nonmutating set { store.anim = newValue }
	}
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
		guard case .idle = store.anim.spinnerState else { return }
		
		let physics      = store.physics
		let currentAngle = angle(from: wheelCenter, to: value.location)
		
		guard let lastAngle = physics.lastDragAngle else {
			physics.seed(rotation: store.anim.rotation, angle: currentAngle)
			return
		}
		
		store.anim.rotation += normalizedDelta(currentAngle - lastAngle)
		physics.updateVelocity(rotation: store.anim.rotation, currentAngle: currentAngle)
	}
	
	private func handleDragEnded(_ value: DragGesture.Value) {
		guard case .idle = store.anim.spinnerState else { return }
		store.physics.clear()
		handleSpin(value)
	}
}

// MARK: - Geometry & Math

extension RewardSpinnerDragGesture {
	var geometry:    RewardSpinnerGeometry { store.geometry }
	var wheelCenter: CGPoint               { CGPoint(x: store.config.wheelSize / 2, y: store.config.wheelSize / 2) }
	
	private func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}
	
	private func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}
