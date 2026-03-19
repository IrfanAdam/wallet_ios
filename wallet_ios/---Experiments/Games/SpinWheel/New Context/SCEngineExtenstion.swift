import SwiftUI
import AVFoundation

extension Engine {

	// MARK: - Config

	private var toastDismissDelay: Double { 1.4 }
	private var completionDelay: Double { 0.3 }

	// MARK: - Drag Handling

	func handleDragChanged(location: CGPoint) {
		guard case .idle = model.phase else { return }

		let currentAngle = interaction.angle(from: geometry.center, to: location)

		guard let lastAngle = physics.lastDragAngle else {
			physics.lastDragAngle = currentAngle
			physics.lastRotationSample = physics.rotation
			return
		}

		physics.rotation += interaction.normalizedDelta(currentAngle - lastAngle)

		physics.updateVelocity(
			rotation: physics.rotation,
			currentAngle: currentAngle
		)
	}

	func handleDragEnded() {
		guard case .idle = model.phase else { return }

		physics.clear()

		if hasSufficientVelocity {
			startSpin()
		} else {
			failSpin()
		}
	}

	// MARK: - Spin Flow

	private func startSpin() {
		model.phase = .spinning

		physics.startSpin(
			update: { [weak self] rotation in
				self?.physics.rotation = rotation
			},
			completion: { [weak self] snappedRotation in
				self?.completeSpin(snappedRotation)
			},
			segmentAngle: geometry.spinWheel.segmentAngle
		)
	}

	private func failSpin() {
		model.phase = .idle

		// Haptic (restored)
		UINotificationFeedbackGenerator().notificationOccurred(.warning)

		let snapped = physics.snapToSegment(
			physics.rotation,
			segmentAngle: geometry.spinWheel.segmentAngle
		)

		withAnimation(anim.spinSnap.animation) {
			physics.rotation = snapped
		}

		physics.angularVelocity = 0

		// Toast (fixed animation)
		model.toastMessage = "Spin harder to win 🎯"
		withAnimation {
			model.showToast = true
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + toastDismissDelay) {
			withAnimation {
				self.model.showToast = false
			}
		}
	}

	// MARK: - Completion

	private func completeSpin(_ snappedRotation: Double) {

		withAnimation(anim.spinSnap.animation) {
			physics.rotation = snappedRotation
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
			let index = self.winningIndex(from: snappedRotation)

			self.triggerCompletionFeedback()

			withAnimation(self.anim.spinBounce.animation) {
				self.model.selectedIndex = index
				self.model.phase = .completed(.win(index: index))
			}
		}
	}

	private var hasSufficientVelocity: Bool {
		let predicted = abs(physics.angularVelocity) / (1 - physics.friction)
		return predicted >= geometry.spinWheel.minimumSpinDegrees
	}

	private func winningIndex(from rotation: Double) -> Int {
		let positive = (rotation.truncatingRemainder(dividingBy: 360) + 360)
			.truncatingRemainder(dividingBy: 360)

		let adjusted = ((360 - positive)
										- geometry.spinWheel.segmentAngle / 2 + 360)
			.truncatingRemainder(dividingBy: 360)

		return (Int(adjusted / geometry.spinWheel.segmentAngle)
						% segments.count + segments.count)
		% segments.count
	}

	func triggerCompletionFeedback() {
		UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		AudioServicesPlaySystemSound(1158)
	}
}

// MARK: - Interaction Helpers

extension Engine.Interaction {

	func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}

	func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}
