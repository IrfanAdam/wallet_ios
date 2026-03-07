import SwiftUI
import Foundation

// MARK: - DisplayLink Proxy

final class DisplayLinkProxy {

	private var handler: (() -> Void)?

	init(handler: @escaping () -> Void = {}) {
		self.handler = handler
	}

	func setHandler(_ newHandler: @escaping () -> Void) {
		self.handler = newHandler
	}

	@objc func step() {
		handler?()
	}
}


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
