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
	
	@State private var rotation: Double = 0
	@State private var lastRotation: Double = 0
	@State private var isSpinning = false
	
	@State private var showToast = false
	@State private var toastMessage = ""
	
	@State private var selectedSegmentIndex: Int? = nil
	
	@State private var spinnerState: SpinnerState = .idle
	
	init(config: RewardSpinnerConfig = .init()) {
		self.config = config
		self.physics = RewardSpinnerPhysics(config: config)
	}
	
	var body: some View {
		ZStack {
			Circle()
				.fill(.ultraThinMaterial)
				.overlay(
					SpinnerSegments(count: config.segments, selectedIndex: selectedSegmentIndex)
				)
				.frame(width: config.wheelSize,
							 height: config.wheelSize)
				.rotationEffect(.degrees(rotation))
				.gesture(dragGesture)
			
			SpinnerPointer(rotation: rotation, segmentCount: config.segments)
				.offset(y: -(config.wheelSize / 2 + 16))
			
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
						.shadow(radius: 8)
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
				guard case .idle = spinnerState else { return } // blocks drag when spinning or completed
				
				if selectedSegmentIndex != nil {
					withAnimation(.easeOut(duration: 0.2)) {
						selectedSegmentIndex = nil
					}
				}
				
				let center = CGPoint(
					x: config.wheelSize / 2,
					y: config.wheelSize / 2
				)
				
				let currentAngle = angle(from: center, to: value.location)
				
				if let last = physics.lastDragAngle {
					let delta = normalizedDelta(currentAngle - last)
					rotation += delta
				}
				
				physics.lastDragAngle = currentAngle
				
				
				let now = CACurrentMediaTime()
				
				if let lastTime = physics.lastTimestamp,
					 let lastRot = physics.lastRotationSample {
					
					let dt = now - lastTime
					let velocity = (rotation - lastRot) / dt
					physics.currentAngularVelocity = velocity
				}
				
				physics.lastTimestamp = now
				physics.lastRotationSample = rotation
			}
			.onEnded { value in
				guard case .idle = spinnerState else { return }
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
				print("rotation: \(snappedRotation), pointerAngle: \(pointerAngle), index: \(index), selected: \(safeIndex)")
			}
		)
	}
	
	private var completionOverlay: some View {
		VStack(spacing: 12) {
			Button {
				revealPrize()
			} label: {
				Label("Reveal Prize", systemImage: "dollarsign.circle.fill")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.tint(.brandBlue)
			
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

