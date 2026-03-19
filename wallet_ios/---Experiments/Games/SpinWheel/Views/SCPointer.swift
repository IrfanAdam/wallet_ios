import SwiftUI
import AVFoundation

// MARK: - View

struct SpinnerPointer: View {
	let store: RewardSpinnerStore
	@State var wobble: Double = 4
	@State var lastSegmentIndex: Int = -1
	@State var lastRotation: Double = 0
	
	var ptr: PointerConfig { PointerConfig() }
	
	var body: some View {
		TrianglePointer()
			.fill(store.theme.colors.content)
			.frame(width: frameSize, height: frameSize)
			.rotationEffect(.degrees(wobble), anchor: wobbleAnchor)
			.rotationEffect(.degrees(pointerRotation))
			.offset(pointerOffset)
			.onChange(of: boundaryIndex) { _, newIndex in
				guard newIndex != lastSegmentIndex else { return }
				lastSegmentIndex = newIndex
				triggerTick()
			}
			.onChange(of: store.engine.physics.rotation) { _, newRotation in
				lastRotation = newRotation
			}
	}
	
	func triggerTick() {
		TickSoundPlayer.shared.tick()
		withAnimation(store.engine.anim.spinSnap.animation) {
			wobble = -ptr.wobbleDeflection * spinDirection
		}
		withAnimation(store.engine.anim.spinSnap.animation.delay(ptr.wobbleDelay)) {
			wobble = 0
		}
	}
}

extension SpinnerPointer {
	var frameSize:       CGFloat   { ptr.frameSize }
	var wobbleAnchor:    UnitPoint { UnitPoint(x: 0.5, y: ptr.anchorY) }
	var pointerRotation: Double    { store.geometry.pointerRotation }
	var pointerOffset:   CGSize    { store.geometry.pointerOffset() }


	var boundaryIndex: Int {
		let normalized = store.engine.physics.rotation.truncatingRemainder(dividingBy: 360)
		let positive   = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / store.geometry.spinWheel.segmentAngle).rounded()) % store.segments.count
	}

	var spinDirection: Double {
		store.engine.physics.rotation - lastRotation > 0 ? 1 : -1
	}
}

final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []

	func tick(intensity: Double = 1.0) {
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}
