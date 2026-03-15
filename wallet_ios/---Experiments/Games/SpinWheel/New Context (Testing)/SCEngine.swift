import SwiftUI

// MARK: - Engine (model + physics + animation)

@Observable
final class Engine {

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
	}

	struct Anim {
		var spinSnap: SpinnerAnimationStyle = .snappy
		var spinBounce: SpinnerAnimationStyle = .bouncy
		var spinSmooth: SpinnerAnimationStyle = .snappy
	}

	struct Interaction {
		// e.g. helpers that compute Animations from `anim`
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
