import SwiftUI

// MARK: - Engine (model + physics + animation)

@Observable
final class Engine {

	// MARK: Subcontexts

	var model = Model()           // what user sees
	var physics = Physics()       // motion state
	var anim    = Anim()
	var interaction = Interaction()   // interaction helpers

	// MARK: Model (view-facing state)

	enum Phase: Equatable {
		case idle
		case spinning
		case completed(index: Int)
	}

	struct Model {
		var phase: Phase = .idle
		var selectedIndex: Int? = nil
		var showToast: Bool = false
		var toastMessage: String = ""
	}

	// MARK: Physics (runtime motion)

	struct Physics {
		var rotation: Double = 0
		var angularVelocity: Double = 0
		var lastDragAngle: Double?
		var lastTimestamp: TimeInterval?
		var lastRotationSample: Double?
		var friction: Double = 0.97
		var stopThreshold: Double = 5
	}

	struct Anim {
		var spinSnap: SpinnerAnimationStyle = .snappy
		var spinBounce: SpinnerAnimationStyle = .bouncy
		var spinSmooth: SpinnerAnimationStyle = .snappy
	}

	struct Interaction {
		// e.g. helpers that compute Animations from `anim`
	}

	// MARK: Intents (what views call)

	func onDragChanged(_ value: DragGesture.Value, geometry: Geometry2) {
		// mutate physics + maybe model; use geometry.spinWheel.segmentAngle etc.
	}

	func onDragEnded(_ value: DragGesture.Value, geometry: Geometry2, segmentCount: Int) {
		// check velocity/friction, start spin, snap, update model
	}

	func spinAgain() {
		model.phase = .idle
		model.selectedIndex = nil
		model.showToast = false
		model.toastMessage = ""
	}
}


