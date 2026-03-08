import SwiftUI
import AVFoundation

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
