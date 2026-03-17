import SwiftUI
import AVFoundation

struct RewardSpinnerDragGesture {
	let store: RewardSpinnerStore

	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				store.engine.handleDragChanged(location: value.location)
			}
			.onEnded { value in
				store.engine.handleDragEnded(location: value.location)
			}
	}
}

//struct RewardSpinnerDragGesture {
//	let store: RewardSpinnerStore
//	var snapFailAnimation: Animation {store.engine.anim.spinSnap.animation}
//	var snapSuccessAnimation: Animation {store.engine.anim.spinSnap.animation}
//	var completionAnimation: Animation {store.engine.anim.spinBounce.animation}
//	var toastDismissDelay: Double { 1.4 }
//	var completionDelay:   Double { 0.3 }
//
//	private var geometry: Geometry2 {
//		store.geometry
//	}
//
//	func makeGesture() -> some Gesture {
//		DragGesture(minimumDistance: 0)
//			.onChanged(handleDragChanged)
//			.onEnded(handleDragEnded)
//	}
//	
//	private func handleDragChanged(_ value: DragGesture.Value) {
//		guard case .idle = store.engine.model.phase else { return }
//		
//		let physics = store.engine.physics
//		let currentAngle = angle(from: wheelCenter, to: value.location)
//		
//		guard let lastAngle = physics.lastDragAngle else {
//			store.engine.physics.lastDragAngle = currentAngle
//			store.engine.physics.lastRotationSample = store.engine.physics.rotation
//			return
//		}
//		
//		store.engine.physics.rotation += normalizedDelta(currentAngle - lastAngle)
//		store.engine.physics.updateVelocity(
//			rotation: store.engine.physics.rotation,
//			currentAngle: currentAngle
//		)
//	}
//	
//	private func handleDragEnded(_ value: DragGesture.Value) {
//		guard case .idle = store.engine.model.phase else { return }
//		store.engine.physics.clear()
//		handleSpin(value)
//	}
//	
//	var wheelCenter: CGPoint { .init(x: geometry.spinWheel.wheelSize / 2, y: geometry.spinWheel.wheelSize / 2) }
//	
//	private func angle(from center: CGPoint, to point: CGPoint) -> Double {
//		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
//	}
//	
//	private func normalizedDelta(_ delta: Double) -> Double {
//		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
//	}
//
//	func handleSpin(_ value: DragGesture.Value) {
//		guard hasSufficientVelocity else {
//			handleFailedSpin()
//			return
//		}
//		
//		store.engine.model.phase = .spinning
//		store.engine.physics.startSpin(
//			update: { store.engine.physics.rotation = $0 },
//			completion: handleSpinCompletion,
//			segmentAngle: geometry.spinWheel.segmentAngle
//		)
//	}
//
//	func handleFailedSpin() {
//		UINotificationFeedbackGenerator().notificationOccurred(.warning)
//		showToast("Spin harder to win 🎯")
//		withAnimation(snapFailAnimation) {
//			store.engine.physics.rotation = store.engine.physics.snapToSegment(
//				store.engine.physics.rotation,
//				segmentAngle: geometry.spinWheel.segmentAngle
//			)
//		}
//		store.engine.physics.angularVelocity = 0
//	}
//	
//	func handleSpinCompletion(_ snappedRotation: Double) {
//		withAnimation(snapSuccessAnimation) { store.engine.physics.rotation = snappedRotation }
//		
//		DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
//			let index = winningIndex(from: snappedRotation)
//			triggerCompletionFeedback()
//			withAnimation(completionAnimation) {
//				store.engine.model.selectedIndex = index
//				store.engine.model.phase = .completed(.win(index: index))
//			}
//		}
//	}
//
//	var hasSufficientVelocity: Bool {
//		let predicted = abs(store.engine.physics.angularVelocity) / (1 - store.engine.physics.friction)
//		return predicted >= store.geometry.spinWheel.minimumSpinDegrees
//	}
//	
//	func winningIndex(from snappedRotation: Double) -> Int {
//		let positive = (snappedRotation.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
//		let adjusted = ((360 - positive) - geometry.spinWheel.segmentAngle / 2 + 360).truncatingRemainder(dividingBy: 360)
//		return (Int(adjusted / geometry.spinWheel.segmentAngle) % store.segments.count + store.segments.count) % store.segments.count
//	}
//	
//	func showToast(_ message: String) {
//		store.engine.model.toastMessage = message
//		withAnimation { store.engine.model.showToast = true }
//		DispatchQueue.main.asyncAfter(deadline: .now() + toastDismissDelay) {
//			withAnimation { store.engine.model.showToast = false }
//		}
//	}
//	
//	func triggerCompletionFeedback() {
//		UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
//		AudioServicesPlaySystemSound(1158)
//	}
//}
