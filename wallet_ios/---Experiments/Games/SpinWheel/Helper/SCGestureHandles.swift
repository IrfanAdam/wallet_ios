import SwiftUI
import AVFoundation

// MARK: - Animations
private let anim = SpinAnimationConfig()

private let snapFailAnimation    = Animation.interpolatingSpring(mass: anim.failSnapMass, stiffness: anim.failSnapStiffness, damping: anim.failSnapDamping)
private let snapSuccessAnimation = Animation.interpolatingSpring(mass: anim.successSnapMass, stiffness: anim.successSnapStiffness, damping: anim.successSnapDamping)
private let completionAnimation  = Animation.spring(response: anim.completionSpringResponse, dampingFraction: anim.completionSpringDamping)

private let toastDismissDelay = anim.toastDismissDelay
private let completionDelay   = anim.completionDelay

// MARK: - Drag Gesture

struct RewardSpinnerDragGesture {

	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }

	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				guard case .idle = store.spinnerState else { return }

				let center = CGPoint(x: store.config.wheelSize / 2, y: store.config.wheelSize / 2)
				let currentAngle = angle(from: center, to: value.location)
				let physics = store.physics

				guard let last = physics.lastDragAngle else {
					physics.lastDragAngle = currentAngle
					physics.lastTimestamp = CACurrentMediaTime()
					physics.lastRotationSample = store.rotation
					return
				}

				store.rotation += normalizedDelta(currentAngle - last)
				physics.lastDragAngle = currentAngle

				let now = CACurrentMediaTime()
				if let lastTime = physics.lastTimestamp,
					 let lastRot = physics.lastRotationSample,
					 now - lastTime > 0 {
					physics.currentAngularVelocity = (store.rotation - lastRot) / (now - lastTime)
				}
				physics.lastTimestamp = now
				physics.lastRotationSample = store.rotation
			}
			.onEnded { value in
				guard case .idle = store.spinnerState else { return }
				store.physics.lastDragAngle = nil
				store.physics.lastTimestamp = nil
				store.physics.lastRotationSample = nil
				handleSpin(value)
			}
	}
}

// MARK: - Math Helpers

private extension RewardSpinnerDragGesture {
	func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}

	func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}

// MARK: - Spin Handling

private extension RewardSpinnerDragGesture {

	func handleSpin(_ value: DragGesture.Value) {
		let physics = store.physics
		let predictedTravel = abs(physics.currentAngularVelocity) / (1 - store.config.friction)

		guard predictedTravel >= store.config.minimumSpinDegrees else {
			UINotificationFeedbackGenerator().notificationOccurred(.warning)
			store.toastMessage = "Spin harder to win 🎯"
			withAnimation { store.showToast = true }
			DispatchQueue.main.asyncAfter(deadline: .now() + toastDismissDelay) {
				withAnimation { store.showToast = false }
			}
			withAnimation(snapFailAnimation) {
				store.rotation = physics.snapToSegment(store.rotation)
			}
			physics.currentAngularVelocity = 0
			return
		}

		store.isSpinning = true

		physics.startSpin(
			currentRotation: store.rotation,
			dragValue: value,
			update: { store.rotation = $0 },
			completion: { snappedRotation in

				withAnimation(snapSuccessAnimation) {
					store.rotation = snappedRotation
				}

				let positive = (snappedRotation.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
				let adjusted = ((360 - positive) - geometry.segmentAngle / 2 + 360).truncatingRemainder(dividingBy: 360)
				let safeIndex = (Int(adjusted / geometry.segmentAngle) % store.segmentCount + store.segmentCount) % store.segmentCount

				DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
					UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
					AudioServicesPlaySystemSound(1158)
					withAnimation(completionAnimation) {
						store.selectedSegmentIndex = safeIndex
						store.spinnerState = .completed(segmentIndex: safeIndex)
					}
				}
			}
		)
	}
}
