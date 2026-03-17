import SwiftUI

// MARK: - Engine (model + physics + animation)

@Observable
final class Engine {

	var geometry: Geometry2
	var segments: [SpinnerSegment]   // ✅ ADD THIS

	init(geometry: Geometry2, segments: [SpinnerSegment]) {
		self.geometry = geometry
		self.segments = segments
	}

	// MARK: Subcontexts

	var model = Model()           // what user sees
	var physics = Physics()       // motion state and runtime rotation values live exclusively here, not in geometry
	var anim    = Anim()
	var interaction = Interaction()   // interaction helpers

	// MARK: Model (view-facing state)

	enum Phase: Equatable {
		case idle
		case spinning
		case completed(Result)
	}
	
	enum Result: Equatable {
		case win(index: Int)
		case lose(index: Int)
	}

	struct Model {
		var phase: Phase = .idle
		var selectedIndex: Int? = nil
		var showToast: Bool = false
		var toastMessage: String = ""
	}

	// MARK: Physics (runtime motion)
	// Rotation and related runtime values live exclusively here.
	// This struct is initialized independently and does not rely on geometry for initial rotation.
	struct Physics {
		// For Rotation
		var rotation: Double = 0
		var lastDragAngle: Double?
		var lastRotationSample: Double?
		// For Velocity
		var angularVelocity: Double = 0
		var friction: Double = 0.97
		var stopThreshold: Double = 5
		var lastTimestamp: TimeInterval?
		
		mutating func updateVelocity(rotation: Double, currentAngle: Double) {

			let now = CACurrentMediaTime()

			guard
				let lastRotation = lastRotationSample,
				let lastTime = lastTimestamp
			else {
				lastRotationSample = rotation
				lastTimestamp = now
				lastDragAngle = currentAngle
				return
			}

			let deltaRotation = rotation - lastRotation
			let deltaTime = now - lastTime

			guard deltaTime > 0 else { return }

			angularVelocity = deltaRotation / deltaTime

			lastRotationSample = rotation
			lastTimestamp = now
			lastDragAngle = currentAngle
		}

		func snapToSegment(
			_ rotation: Double,
			segmentAngle: Double
		) -> Double {
			let half = segmentAngle / 2
			return ((rotation + half) / segmentAngle).rounded() * segmentAngle - half
		}

		mutating func startSpin(
			update: @escaping (Double) -> Void,
			completion: @escaping (Double) -> Void,
			segmentAngle: Double
		) {
			
			let initialVelocity = angularVelocity
			let startRotation = rotation
			
			runFrictionSimulation(
				startRotation: startRotation,
				initialVelocity: initialVelocity,
				update: update,
				completion: completion,
				segmentAngle: segmentAngle
			)
		}
		
		mutating func clear() {
			lastDragAngle      = nil
			lastTimestamp      = nil
			lastRotationSample = nil
		}
		
		mutating func runFrictionSimulation(
			startRotation: Double,
			initialVelocity: Double,
			update: @escaping (Double) -> Void,
			completion: @escaping (Double) -> Void,
			segmentAngle: Double
		) {
			
			var rotation = startRotation
			var velocity = initialVelocity
			
			let friction = self.friction
			let stopThreshold = self.stopThreshold
			let snap = self.snapToSegment

			let proxy = DisplayLinkProxy()
			let displayLink = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step))
			
			proxy.setHandler { [weak displayLink] in
				guard let link = displayLink else { return }
				
				let dt = link.targetTimestamp - link.timestamp
				
				rotation += velocity * dt
				velocity *= pow(friction, dt * 60)

				update(rotation)

				if abs(velocity) < stopThreshold {
					link.invalidate()

					let snapped = snap(rotation, segmentAngle)
					completion(snapped)
				}
			}
			
			displayLink.add(to: .main, forMode: .common)
		}
	}

	struct Anim {
		var spinSnap: SpinnerAnimationStyle = .snappy
		var spinBounce: SpinnerAnimationStyle = .bouncy
		var spinSmooth: SpinnerAnimationStyle = .snappy
	}

	struct Interaction {
		// e.g. helpers that compute Animations from `anim`
		var dragSensitivity: Double = 0.25
		var momentumMultiplier: Double = 8
		var minimumSpinDegrees: Double = 720
	}
	
	func initializeRotation(segmentCount: Int) {
		let segmentAngle = 360.0 / Double(max(segmentCount, 1))
		physics.rotation = -segmentAngle / 2
	}

	// MARK: Intents (what views call)

	func onDragChanged(_ value: DragGesture.Value, geometry: Geometry2) {
		// mutate physics + maybe model; use geometry.spinWheel.segmentAngle etc.
	}

	func onDragEnded(_ value: DragGesture.Value, geometry: Geometry2, segmentCount: Int) {
		// check velocity/friction, start spin, snap, update model
	}

	// Reset or re-initialize rotation.
	// Takes segment count as input for initial placement, not geometry.
	func resetRotation(for segmentCount: Int) {
		physics.rotation = 0
		physics.lastDragAngle = nil
		physics.lastRotationSample = nil
		physics.angularVelocity = 0
		physics.lastTimestamp = nil
	}

	func spinAgain() {
		model.phase = .idle
		model.selectedIndex = nil
		model.showToast = false
		model.toastMessage = ""
	}
}

final class DisplayLinkProxy {

	private var handler: (() -> Void)?

	func setHandler(_ handler: @escaping () -> Void) {
		self.handler = handler
	}

	@objc func step() {
		handler?()
	}
}

