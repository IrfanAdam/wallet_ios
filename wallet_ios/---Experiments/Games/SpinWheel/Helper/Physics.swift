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

struct RewardSpinnerPhysics {
	
	let config: RewardSpinnerConfig
	var lastDragAngle: Double?
	
	var lastTimestamp: TimeInterval?
	var lastRotationSample: Double?
	var currentAngularVelocity: Double = 0
	
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

// MARK: - Private Simulation

extension RewardSpinnerPhysics {
	
	func runFrictionSimulation(
		startRotation: Double,
		initialVelocity: Double,
		update: @escaping (Double) -> Void,
		completion: @escaping (Double) -> Void
	) {
		var rotation = startRotation
		var velocity = initialVelocity
		
		let friction: Double = 0.97
		let stopThreshold: Double = 5
		
		// Create proxy first
		let proxy = DisplayLinkProxy { }
		
		// Create displayLink
		let displayLink = CADisplayLink(
			target: proxy,
			selector: #selector(DisplayLinkProxy.step)
		)
		
		// Inject actual handler AFTER displayLink exists
		proxy.setHandler { [weak displayLink] in
			guard let link = displayLink else { return }
			
			// Frame-accurate delta time
			let deltaTime = link.targetTimestamp - link.timestamp
			
			// Apply rotation
			rotation += velocity * deltaTime
			
			// Apply friction (frame independent)
			velocity *= pow(friction, deltaTime * 60)
			
			update(rotation)
			
			if abs(velocity) < stopThreshold {
				link.invalidate()
				
				let snapped = snapToSegment(rotation)
				completion(snapped)
			}
		}
		
		displayLink.add(to: .main, forMode: .common)
	}
	
	func snapToSegment(_ angle: Double) -> Double {
		let segmentAngle = 360.0 / Double(config.segments)
		let halfSegment = segmentAngle / 2
		// Shift by half, round to boundary, shift back → lands on center
		return ((angle + halfSegment) / segmentAngle).rounded() * segmentAngle - halfSegment
	}
}
