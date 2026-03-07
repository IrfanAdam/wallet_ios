import SwiftUI
import AVFoundation

extension SpinnerPointer {
	var frameSize:       CGFloat   { ptr.frameSize }
	var wobbleAnchor:    UnitPoint { UnitPoint(x: 0.5, y: ptr.anchorY) }
	var pointerRotation: Double    { store.geometry.pointerRotation }
	var pointerOffset:   CGSize    { store.geometry.pointerOffset() }


	var boundaryIndex: Int {
		let normalized = store.rotation.truncatingRemainder(dividingBy: 360)
		let positive   = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / store.geometry.segmentAngle).rounded()) % store.segmentCount
	}
	
	var spinDirection: Double {
		store.rotation - lastRotation > 0 ? 1 : -1
	}
	
	var wobbleAnimation: Animation {
		.interpolatingSpring(
			mass:      ptr.wobbleSpringMass,
			stiffness: ptr.wobbleSpringStiffness,
			damping:   ptr.wobbleSpringDamping
		)
	}
	
	var wobbleReturnAnimation: Animation {
		.interpolatingSpring(
			mass:      ptr.wobbleSpringMass,
			stiffness: ptr.returnSpringStiffness,
			damping:   ptr.returnSpringDamping
		)
	}
}

final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []
	
	func tick(intensity: Double = 1.0) {
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}
