import SwiftUI
import Charts
import AVFoundation

// MARK: - Tick Sound Player
final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []
	
	func tick(intensity: Double = 1.0) {
		// Use system sound as fallback, or load a custom tick.wav from bundle
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}

// MARK: - Config & Animations

private let ptr = PointerConfig()
private let wobbleAnimation = Animation.interpolatingSpring(mass: ptr.wobbleSpringMass, stiffness: ptr.wobbleSpringStiffness, damping: ptr.wobbleSpringDamping)
private let wobbleReturnAnimation = Animation.interpolatingSpring(mass: ptr.wobbleSpringMass, stiffness: ptr.returnSpringStiffness, damping: ptr.returnSpringDamping)

// MARK: - Pointer View

struct SpinnerPointer: View {

	let store: RewardSpinnerStore

	@State private var wobble: Double = 0
	@State private var lastSegmentIndex: Int = -1
	@State private var lastRotation: Double = 0

	private var currentBoundaryIndex: Int {
		let normalized = store.rotation.truncatingRemainder(dividingBy: 360)
		let positive = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / store.geometry.segmentAngle).rounded()) % store.segmentCount
	}

	private var spinDirection: Double {
		store.rotation - lastRotation > 0 ? 1 : -1
	}

	var body: some View {
		TrianglePointer()
			.fill(Color.black)
			.frame(width: ptr.frameSize, height: ptr.frameSize)
			.rotationEffect(.degrees(wobble), anchor: UnitPoint(x: 0.5, y: ptr.anchorY))
			.rotationEffect(.degrees(store.geometry.pointerRotation))
			.offset(store.geometry.pointerOffset())
			.onChange(of: currentBoundaryIndex) { _, newIndex in
				guard newIndex != lastSegmentIndex else { return }
				lastSegmentIndex = newIndex
				triggerTick()
			}
			.onChange(of: store.rotation) { _, newRotation in
				lastRotation = newRotation
			}
	}

	private func triggerTick() {
		TickSoundPlayer.shared.tick()

		let deflection = -ptr.wobbleDeflection * spinDirection

		withAnimation(wobbleAnimation) {
			wobble = deflection
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + ptr.wobbleDelay) {
			withAnimation(wobbleReturnAnimation) {
				wobble = 0
			}
		}
	}
}
