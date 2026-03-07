import SwiftUI

// MARK: - View

struct SpinnerPointer: View {
	let store: RewardSpinnerStore
	@State var wobble: Double = 0
	@State var lastSegmentIndex: Int = -1
	@State var lastRotation: Double = 0
	
	var ptr: PointerConfig { PointerConfig() }
	
	var body: some View {
		TrianglePointer()
			.fill(Color.black)
			.frame(width: frameSize, height: frameSize)
			.rotationEffect(.degrees(wobble), anchor: wobbleAnchor)
			.rotationEffect(.degrees(pointerRotation))
			.offset(pointerOffset)
			.onChange(of: boundaryIndex) { _, newIndex in
				guard newIndex != lastSegmentIndex else { return }
				lastSegmentIndex = newIndex
				triggerTick()
			}
			.onChange(of: store.rotation) { _, newRotation in
				lastRotation = newRotation
			}
	}
	
	func triggerTick() {
		TickSoundPlayer.shared.tick()
		withAnimation(wobbleAnimation) {
			wobble = -ptr.wobbleDeflection * spinDirection
		}
		withAnimation(wobbleReturnAnimation.delay(ptr.wobbleDelay)) {
			wobble = 0
		}
	}
}
