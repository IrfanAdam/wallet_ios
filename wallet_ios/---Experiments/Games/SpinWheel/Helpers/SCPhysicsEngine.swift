import SwiftUI
import Foundation


//// MARK: - Spinner Physics Engine (Friction-Based)
//
//final class RewardSpinnerPhysics {
//
//	let config: RewardSpinnerConfig
//	let segmentCount: Int
//	let geometry: RewardSpinnerGeometry
//
//	var lastDragAngle: Double?
//	var lastTimestamp: TimeInterval?
//	var lastRotationSample: Double?
//	var currentAngularVelocity: Double = 0
//
//	init(
//		config: RewardSpinnerConfig,
//		segmentCount: Int,
//		geometry: RewardSpinnerGeometry
//	) {
//		self.config = config
//		self.segmentCount = segmentCount
//		self.geometry = geometry
//	}
//
//	// MARK: - Public Entry
//
//	func startSpin(
//		currentRotation: Double,
//		dragValue: DragGesture.Value,
//		update: @escaping (Double) -> Void,
//		completion: @escaping (Double) -> Void
//	) {
//
//		let initialVelocity = currentAngularVelocity
//
//		runFrictionSimulation(
//			startRotation: currentRotation,
//			initialVelocity: initialVelocity,
//			update: update,
//			completion: completion
//		)
//	}
//}
//
//
//extension RewardSpinnerPhysics {
//	func seed(rotation: Double, angle: Double) {
//		lastDragAngle      = angle
//		lastTimestamp      = CACurrentMediaTime()
//		lastRotationSample = rotation
//	}
//	
//	func updateVelocity(rotation: Double, currentAngle: Double) {
//		let now = CACurrentMediaTime()
//		
//		if let lastTime = lastTimestamp,
//			 let lastRot  = lastRotationSample,
//			 now - lastTime > 0 {
//			currentAngularVelocity = (rotation - lastRot) / (now - lastTime)
//		}
//		
//		lastDragAngle      = currentAngle
//		lastTimestamp      = now
//		lastRotationSample = rotation
//	}
//	
//	func clear() {
//		lastDragAngle      = nil
//		lastTimestamp      = nil
//		lastRotationSample = nil
//	}
//}
//
//// MARK: - Simulation
//// Drives the wheel spin using a frame-by-frame friction model via CADisplayLink.
//// Each frame: applies velocity, decays it by friction, until it falls below the stop threshold.
//// Once stopped, snaps the final rotation to the nearest segment and calls completion.
//
//extension RewardSpinnerPhysics {
//	
//	func runFrictionSimulation(
//		startRotation:   Double,
//		initialVelocity: Double,
//		update:          @escaping (Double) -> Void,
//		completion:      @escaping (Double) -> Void
//	) {
//		var rotation = startRotation
//		var velocity = initialVelocity
//		
//		let proxy       = DisplayLinkProxy()
//		let displayLink = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step))
//		
//		proxy.setHandler { [weak displayLink] in
//			guard let link = displayLink else { return }
//			
//			// Advance physics one frame
//			let dt    = link.targetTimestamp - link.timestamp
//			rotation += velocity * dt
//			velocity *= pow(self.config.friction, dt * 60)
//			update(rotation)
//			
//			// Stop and snap once wheel has slowed to a halt
//			if abs(velocity) < self.config.stopThreshold {
//				link.invalidate()
//				completion(self.snapToSegment(rotation))
//			}
//		}
//		
//		displayLink.add(to: .main, forMode: .common)
//	}
//	
//	// Rounds any rotation angle to the center of the nearest segment
//	func snapToSegment(_ angle: Double) -> Double {
//		let half = geometry.segmentAngle / 2
//		return ((angle + half) / geometry.segmentAngle).rounded() * geometry.segmentAngle - half
//	}
//}

// MARK: - DisplayLink Proxy
// CADisplayLink requires an @objc target — this proxy bridges that requirement
// so the simulation logic can live in a plain Swift closure instead.

final class DisplayLinkProxy {
	
	private var handler: (() -> Void)?
	
	func setHandler(_ handler: @escaping () -> Void) {
		self.handler = handler
	}
	
	@objc func step() {
		handler?()
	}
}

