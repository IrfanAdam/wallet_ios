import SwiftUI
import AVFoundation

// MARK: - Math Helpers

extension RewardSpinnerDragGesture {
	func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}
	
	func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}

// MARK: - Spin Handling

extension RewardSpinnerDragGesture {
	func handleSpin(_ value: DragGesture.Value) {
		guard predictedTravel >= store.config.minimumSpinDegrees else {
			handleFailedSpin()
			return
		}
		
		store.isSpinning = true
		
		store.physics.startSpin(
			currentRotation: store.rotation,
			dragValue: value,
			update: { store.rotation = $0 },
			completion: handleSpinCompletion
		)
	}
}

// MARK: - Spin Outcomes

private extension RewardSpinnerDragGesture {
	func handleFailedSpin() {
		UINotificationFeedbackGenerator().notificationOccurred(.warning)
		showToast("Spin harder to win 🎯")
		
		withAnimation(snapFailAnimation) {
			store.rotation = store.physics.snapToSegment(store.rotation)
		}
		store.physics.currentAngularVelocity = 0
	}
	
	func handleSpinCompletion(_ snappedRotation: Double) {
		withAnimation(snapSuccessAnimation) {
			store.rotation = snappedRotation
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
			triggerCompletionFeedback()
			withAnimation(completionAnimation) {
				store.selectedSegmentIndex = winningIndex(from: snappedRotation)
				store.spinnerState = .completed(segmentIndex: winningIndex(from: snappedRotation))
			}
		}
	}
}

// MARK: - Helpers

private extension RewardSpinnerDragGesture {
	var predictedTravel: Double {
		abs(store.physics.currentAngularVelocity) / (1 - store.config.friction)
	}
	
	func winningIndex(from snappedRotation: Double) -> Int {
		let positive = (snappedRotation.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
		let adjusted = ((360 - positive) - geometry.segmentAngle / 2 + 360).truncatingRemainder(dividingBy: 360)
		return (Int(adjusted / geometry.segmentAngle) % store.segmentCount + store.segmentCount) % store.segmentCount
	}
	
	func showToast(_ message: String) {
		store.toastMessage = message
		withAnimation { store.showToast = true }
		DispatchQueue.main.asyncAfter(deadline: .now() + toastDismissDelay) {
			withAnimation { store.showToast = false }
		}
	}
	
	func triggerCompletionFeedback() {
		UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		AudioServicesPlaySystemSound(1158)
	}
}
