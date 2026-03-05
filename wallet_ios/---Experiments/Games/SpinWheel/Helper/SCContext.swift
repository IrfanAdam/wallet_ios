import SwiftUI
// RewardSpinnerContext.swift

enum RewardSpinnerContext {} // namespace only

@Observable
final class RewardSpinnerStore {

	// MARK: - Model
	let segments: [SpinnerSegment]
	let config: RewardSpinnerConfig
	var segmentCount: Int { segments.count }

	// MARK: - Interaction
	var spinnerState: SpinnerState = .idle
	var selectedSegmentIndex: Int? = nil
	var showToast: Bool = false
	var toastMessage: String = ""

	// MARK: - Animation
	var rotation: Double
	var isSpinning: Bool = false

	// MARK: - Physics
	let physics: RewardSpinnerPhysics

	init(
		segments: [SpinnerSegment],
		config: RewardSpinnerConfig = .init()
	) {
		self.segments = segments
		self.config = config
		self.physics = RewardSpinnerPhysics(config: config, segmentCount: segments.count)
		let segmentAngle = 360.0 / Double(segments.count)
		self.rotation = -segmentAngle / 2
	}
}

struct RewardSpinnerConfig {

	// MARK: Layout
	var segments: Int = 8
	var wheelSize: CGFloat = 240

	// MARK: Interaction Feel
	var dragSensitivity: Double = 0.25
	var momentumMultiplier: Double = 8
	var minimumSpinDegrees: Double = 720

	// MARK: Animation  
	var springMass: Double = 1.2
	var springStiffness: Double = 40
	var springDamping: Double = 8
	var animationDuration: Double = 2.4
}
