import SwiftUI

extension Engine {

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

	func handleDragEnded(location: CGPoint) {
		guard case .idle = model.phase else { return }

		physics.clear()

		if hasSufficientVelocity {
			startSpin()
		} else {
			failSpin()
		}
	}
}

extension Engine {

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

		let snapped = physics.snapToSegment(
			physics.rotation,
			segmentAngle: geometry.spinWheel.segmentAngle
		)

		withAnimation(anim.spinSnap.animation) {
			physics.rotation = snapped
		}

		physics.angularVelocity = 0

		model.toastMessage = "Spin harder to win 🎯"
		model.showToast = true

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
			withAnimation {
				self.model.showToast = false
			}
		}
	}
}

extension Engine {

	private func completeSpin(_ snappedRotation: Double) {

		withAnimation(anim.spinSnap.animation) {
			physics.rotation = snappedRotation
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			let index = self.winningIndex(from: snappedRotation)

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
}

extension Engine.Interaction {

	func angle(from center: CGPoint, to point: CGPoint) -> Double {
		atan2(point.y - center.y, point.x - center.x) * 180 / .pi
	}

	func normalizedDelta(_ delta: Double) -> Double {
		(delta + 180).truncatingRemainder(dividingBy: 360) - 180
	}
}
