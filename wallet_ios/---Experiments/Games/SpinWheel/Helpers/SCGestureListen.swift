import SwiftUI
import AVFoundation

struct RewardSpinnerDragGesture {
	let store: RewardSpinnerStore
	var animConfig: RewardSpinnerAnimationConfig.Spin { store.animations.spin }
	var anim: RewardSpinnerAnimState {
		get { store.anim }
		nonmutating set { store.anim = newValue }
	}
}

extension RewardSpinnerDragGesture {
	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged(handleDragChanged)
			.onEnded(handleDragEnded)
	}
	
	private func handleDragChanged(_ value: DragGesture.Value) {
		guard case .idle = anim.spinnerState else { return }
		
		let physics = store.physics
		let currentAngle = angle(from: wheelCenter, to: value.location)
		
		guard let lastAngle = physics.lastDragAngle else {
			physics.seed(rotation: anim.rotation, angle: currentAngle)
			return
		}
		
		anim.rotation += normalizedDelta(currentAngle - lastAngle)
		physics.updateVelocity(rotation: anim.rotation, currentAngle: currentAngle)
	}
	
	private func handleDragEnded(_ value: DragGesture.Value) {
		guard case .idle = anim.spinnerState else { return }
		store.physics.clear()
		handleSpin(value)
	}
	
	var geometry: RewardSpinnerGeometry { store.geometry }
	var wheelCenter: CGPoint { .init(x: store.config.wheelSize / 2, y: store.config.wheelSize / 2) }
	
	private func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}
	
	private func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}

// MARK: - Spin Handling

extension RewardSpinnerDragGesture {
	func handleSpin(_ value: DragGesture.Value) {
		guard hasSufficientVelocity else {
			handleFailedSpin()
			return
		}
		
		store.anim.isSpinning = true
		
		store.physics.startSpin(
			currentRotation: store.anim.rotation,
			dragValue: value,
			update: { store.anim.rotation = $0 },
			completion: handleSpinCompletion
		)
	}
}

// MARK: - Outcomes

private extension RewardSpinnerDragGesture {
	func handleFailedSpin() {
		UINotificationFeedbackGenerator().notificationOccurred(.warning)
		showToast("Spin harder to win 🎯")
		withAnimation(snapFailAnimation) {
			store.anim.rotation = store.physics.snapToSegment(store.anim.rotation)
		}
		store.physics.currentAngularVelocity = 0
	}
	
	func handleSpinCompletion(_ snappedRotation: Double) {
		withAnimation(snapSuccessAnimation) { store.anim.rotation = snappedRotation }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
			let index = winningIndex(from: snappedRotation)
			triggerCompletionFeedback()
			withAnimation(completionAnimation) {
				store.anim.selectedSegmentIndex = index
				store.anim.spinnerState = .completed(segmentIndex: index)
			}
		}
	}
}

// MARK: - Helpers

private extension RewardSpinnerDragGesture {
	var hasSufficientVelocity: Bool {
		let predicted = abs(store.physics.currentAngularVelocity) / (1 - store.config.friction)
		return predicted >= store.config.minimumSpinDegrees
	}
	
	func winningIndex(from snappedRotation: Double) -> Int {
		let positive = (snappedRotation.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
		let adjusted = ((360 - positive) - geometry.segmentAngle / 2 + 360).truncatingRemainder(dividingBy: 360)
		return (Int(adjusted / geometry.segmentAngle) % store.segmentCount + store.segmentCount) % store.segmentCount
	}
	
	func showToast(_ message: String) {
		store.anim.toastMessage = message
		withAnimation { store.anim.showToast = true }
		DispatchQueue.main.asyncAfter(deadline: .now() + toastDismissDelay) {
			withAnimation { store.anim.showToast = false }
		}
	}
	
	func triggerCompletionFeedback() {
		UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		AudioServicesPlaySystemSound(1158)
	}
}

// MARK: - Animations

extension RewardSpinnerDragGesture {
	var snapFailAnimation: Animation {
		.interpolatingSpring(
			mass:      animConfig.failSnapMass,
			stiffness: animConfig.failSnapStiffness,
			damping:   animConfig.failSnapDamping
		)
	}
	var snapSuccessAnimation: Animation {
		.interpolatingSpring(
			mass:      animConfig.successSnapMass,
			stiffness: animConfig.successSnapStiffness,
			damping:   animConfig.successSnapDamping
		)
	}
	var completionAnimation: Animation {
		.spring(
			response:       animConfig.completionResponse,
			dampingFraction: animConfig.completionDamping
		)
	}
	var toastDismissDelay: Double { animConfig.toastDismissDelay }
	var completionDelay:   Double { animConfig.completionDelay }
}


