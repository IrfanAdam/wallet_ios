import SwiftUI

// MARK: - Reward Spinner View

enum SpinnerState {
	case idle
	case spinning
	case completed(segmentIndex: Int)
}

struct RewardSpinner: View {
	
	private let config: RewardSpinnerConfig
	@State private var physics: RewardSpinnerPhysics
	
	@State private var rotation: Double
	@State private var lastRotation: Double = 0
	@State private var isSpinning = false
	
	@State private var showToast = false
	@State private var toastMessage = ""
	
	@State private var selectedSegmentIndex: Int? = nil
	
	@State private var spinnerState: SpinnerState = .idle
	
	init(config: RewardSpinnerConfig = .init()) {
		self.config = config
		self.physics = RewardSpinnerPhysics(config: config)

		let segmentAngle = 360.0 / Double(config.segments)
		_rotation = State(initialValue: -segmentAngle / 2)
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(Color.gray.opacity(0.1))
				.overlay(
					SpinnerSegments(count: config.segments, selectedIndex: selectedSegmentIndex)
				)
				.frame(width: config.wheelSize,
							 height: config.wheelSize)
				.rotationEffect(.degrees(rotation))
				.gesture(dragGesture)

			let segmentAngle = 360.0 / Double(config.segments)
			let boundaryAngle = -90 - segmentAngle / 2
			let radius = config.wheelSize / 2
			let radians = boundaryAngle * .pi / 180

			let x = cos(radians) * radius
			let y = sin(radians) * radius

			SpinnerPointer(rotation: rotation, segmentCount: config.segments)
				.rotationEffect(.degrees(-segmentAngle / 2))
				.offset(
					x: x - 4,
					y: y - 8
				)

			// 🏁 Completion Panel
			if case .completed = spinnerState {
				completionOverlay
					.transition(.scale(scale: 0.8).combined(with: .opacity))
			}
			
			if showToast {
				VStack {
					Spacer()
					
					Text(toastMessage)
						.font(.subheadline.weight(.semibold))
						.padding(.horizontal, 18)
						.padding(.vertical, 10)
						.background(.ultraThinMaterial)
						.clipShape(Capsule())
						.shadow(color: Color.black.opacity(0.1), radius: 12, y: 12)
						.padding(.bottom, 40)
						.transition(.move(edge: .bottom).combined(with: .opacity))
				}
				.animation(.easeInOut, value: showToast)
			}
		}
	}
}

// MARK: - Gesture Handling

private extension RewardSpinner {
	
	func angle(from center: CGPoint, to point: CGPoint) -> Double {
		let dx = point.x - center.x
		let dy = point.y - center.y
		return atan2(dy, dx) * 180 / .pi
	}
	
	func normalizedDelta(_ delta: Double) -> Double {
		var adjusted = delta
		if adjusted > 180 { adjusted -= 360 }
		if adjusted < -180 { adjusted += 360 }
		return adjusted
	}
	
	var dragGesture: some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				guard case .idle = spinnerState else { return }

				let center = CGPoint(
					x: config.wheelSize / 2,
					y: config.wheelSize / 2
				)

				let currentAngle = angle(from: center, to: value.location)

				// 🔥 FIX: If this is first frame of drag,
				// just store angle and DO NOT move wheel.
				if physics.lastDragAngle == nil {
					physics.lastDragAngle = currentAngle
					physics.lastTimestamp = CACurrentMediaTime()
					physics.lastRotationSample = rotation
					return
				}

				// Normal delta logic
				if let last = physics.lastDragAngle {
					let delta = normalizedDelta(currentAngle - last)
					rotation += delta
				}

				physics.lastDragAngle = currentAngle

				let now = CACurrentMediaTime()

				if let lastTime = physics.lastTimestamp,
					 let lastRot = physics.lastRotationSample {

					let dt = now - lastTime
					if dt > 0 {
						physics.currentAngularVelocity = (rotation - lastRot) / dt
					}
				}

				physics.lastTimestamp = now
				physics.lastRotationSample = rotation
			}
			.onEnded { value in
				guard case .idle = spinnerState else { return }

				// 🔥 IMPORTANT: Reset drag tracking
				physics.lastDragAngle = nil
				physics.lastTimestamp = nil
				physics.lastRotationSample = nil

				lastRotation = rotation
				handleSpin(value)
			}
	}

	func handleSpin(_ value: DragGesture.Value) {
		
		let initialVelocity = physics.currentAngularVelocity
		let friction: Double = 0.97
		let predictedTravel = abs(initialVelocity) / (1 - friction)
		
		if predictedTravel < config.minimumSpinDegrees {

			// 🔔 Haptic feedback
			let generator = UINotificationFeedbackGenerator()
			generator.prepare()
			generator.notificationOccurred(.warning)

			toastMessage = "Spin harder to win 🎯"

			withAnimation {
				showToast = true
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
				withAnimation {
					showToast = false
				}
			}

			// 🔥 NEW: Snap to nearest segment with spring
			let snapped = physics.snapToSegment(rotation)

			withAnimation(
				.interpolatingSpring(
					mass: 0.6,
					stiffness: 140,
					damping: 16
				)
			) {
				rotation = snapped
			}

			lastRotation = snapped
			physics.currentAngularVelocity = 0

			return
		}

		isSpinning = true
		physics.startSpin(
			currentRotation: rotation,
			dragValue: value,
			update: { newRotation in rotation = newRotation },
			completion: { snappedRotation in
				withAnimation(.interpolatingSpring(mass: 0.6, stiffness: 120, damping: 14)) {
					rotation = snappedRotation
				}
				lastRotation = snappedRotation
				
				let segmentAngle = 360.0 / Double(config.segments)
				let normalized = snappedRotation.truncatingRemainder(dividingBy: 360)
				let positive = normalized < 0 ? normalized + 360 : normalized
				
				// Invert wheel rotation to get what's under the pointer
				let pointerAngle = (360 - positive).truncatingRemainder(dividingBy: 360)
				
				// Swift Charts starts at 3 o'clock → subtract 90°
				let adjusted = (pointerAngle - (segmentAngle / 2) + 360).truncatingRemainder(dividingBy: 360)
				let safeIndex = (Int(adjusted / segmentAngle) % config.segments + config.segments) % config.segments
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					let haptic = UIImpactFeedbackGenerator(style: .heavy)
					haptic.prepare()
					haptic.impactOccurred()
					
					withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
						selectedSegmentIndex = safeIndex
						spinnerState = .completed(segmentIndex: safeIndex)
					}
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					let haptic = UIImpactFeedbackGenerator(style: .heavy)
					haptic.prepare()
					haptic.impactOccurred()
					
					withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
						selectedSegmentIndex = safeIndex
						spinnerState = .completed(segmentIndex: safeIndex)
					}
				}
			}
		)
	}
	
	private var completionOverlay: some View {
		VStack(spacing: 12) {
			HStack {
				Button {
					withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
						selectedSegmentIndex = nil
						spinnerState = .idle
					}
				} label: {
					Label("Spin Again", systemImage: "arrow.clockwise")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.bordered)

				Button {
					revealPrize()
				} label: {
					Label("Rewards", systemImage: "dollarsign.circle.fill")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)
				.tint(.brandBlue)
			}
		}
		.padding(.horizontal, 40)
		.offset(y: config.wheelSize / 2 + 60)
	}
	
	private func revealPrize() {
		// Hook into your coins/reward logic here
		let haptic = UINotificationFeedbackGenerator()
		haptic.notificationOccurred(.success)
		// e.g. viewModel.spendCoins() / show prize sheet
	}
}

extension SpinnerState: Equatable {
	var isCompleted: Bool {
		if case .completed = self { return true }
		return false
	}
}

