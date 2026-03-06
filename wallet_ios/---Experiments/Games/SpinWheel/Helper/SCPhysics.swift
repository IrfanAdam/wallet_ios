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


// MARK: - Simulation

extension RewardSpinnerPhysics {
	func runFrictionSimulation(
		startRotation: Double,
		initialVelocity: Double,
		update: @escaping (Double) -> Void,
		completion: @escaping (Double) -> Void
	) {

		var rotation = startRotation
		var velocity = initialVelocity

		let friction = config.friction
		let stopThreshold = config.stopThreshold

		let proxy = DisplayLinkProxy {}

		let displayLink = CADisplayLink(
			target: proxy,
			selector: #selector(DisplayLinkProxy.step)
		)


		proxy.setHandler { [weak displayLink] in
			guard let link = displayLink else { return }

			let deltaTime = link.targetTimestamp - link.timestamp

			rotation += velocity * deltaTime

			velocity *= pow(friction, deltaTime * 60)

			update(rotation)

			if abs(velocity) < stopThreshold {

				link.invalidate()

				let snapped = self.snapToSegment(rotation)

				completion(snapped)
			}
		}

		displayLink.add(to: .main, forMode: .common)
	}

	func snapToSegment(_ angle: Double) -> Double {

		let halfSegment = geometry.segmentAngle / 2

		return ((angle + halfSegment) / geometry.segmentAngle)
			.rounded() * geometry.segmentAngle - halfSegment
	}
}
