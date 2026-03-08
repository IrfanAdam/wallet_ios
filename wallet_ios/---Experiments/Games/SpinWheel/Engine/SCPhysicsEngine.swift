import SwiftUI
import Foundation


// MARK: - Spinner Physics Engine (Friction-Based)

final class RewardSpinnerPhysics {

	let config: RewardSpinnerConfig
	let segmentCount: Int
	let geometry: RewardSpinnerGeometry

	var lastDragAngle: Double?
	var lastTimestamp: TimeInterval?
	var lastRotationSample: Double?
	var currentAngularVelocity: Double = 0

	init(
		config: RewardSpinnerConfig,
		segmentCount: Int,
		geometry: RewardSpinnerGeometry
	) {
		self.config = config
		self.segmentCount = segmentCount
		self.geometry = geometry
	}

	// MARK: - Public Entry

	func startSpin(
		currentRotation: Double,
		dragValue: DragGesture.Value,
		update: @escaping (Double) -> Void,
		completion: @escaping (Double) -> Void
	) {

		let initialVelocity = currentAngularVelocity

		runFrictionSimulation(
			startRotation: currentRotation,
			initialVelocity: initialVelocity,
			update: update,
			completion: completion
		)
	}
}


extension RewardSpinnerPhysics {
	func seed(rotation: Double, angle: Double) {
		lastDragAngle      = angle
		lastTimestamp      = CACurrentMediaTime()
		lastRotationSample = rotation
	}
	
	func updateVelocity(rotation: Double, currentAngle: Double) {
		let now = CACurrentMediaTime()
		
		if let lastTime = lastTimestamp,
			 let lastRot  = lastRotationSample,
			 now - lastTime > 0 {
			currentAngularVelocity = (rotation - lastRot) / (now - lastTime)
		}
		
		lastDragAngle      = currentAngle
		lastTimestamp      = now
		lastRotationSample = rotation
	}
	
	func clear() {
		lastDragAngle      = nil
		lastTimestamp      = nil
		lastRotationSample = nil
	}
}
