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
