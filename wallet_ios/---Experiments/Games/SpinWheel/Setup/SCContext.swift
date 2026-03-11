import SwiftUI
// RewardSpinnerContext.swift

enum RewardSpinnerContext {} // namespace only

enum SpinnerState {
	case idle
	case spinning
	case completed(segmentIndex: Int)
}

extension SpinnerState: Equatable {
	var isCompleted: Bool {
		if case .completed = self { return true }
		return false
	}
}

struct SpinnerSegment: Identifiable {
	let id = UUID()
	let imageName: String
}

@Observable
final class RewardSpinnerStore {

	// MARK: - Model
	let segments: [SpinnerSegment]
	let config: RewardSpinnerConfig
	let geometry: RewardSpinnerGeometry
	var segmentCount: Int { segments.count }

	// MARK: - Physics
	let physics: RewardSpinnerPhysics

	// MARK: - Animation
	var anim = RewardSpinnerAnimState()
	let animations = RewardSpinnerAnimationConfig()

	init(
		segments: [SpinnerSegment],
		config: RewardSpinnerConfig = .init()
	) {
		self.segments = segments
		self.config = config

		self.geometry = RewardSpinnerGeometry(
			config: config,
			segmentCount: segments.count
		)

		self.physics = RewardSpinnerPhysics(
			config: config,
			segmentCount: segments.count,
			geometry: geometry
		)

		let segmentAngle = geometry.segmentAngle
		anim.rotation = -segmentAngle / 2
	}
}

@Observable
final class RewardSpinnerAnimState {
	var rotation: Double = 0
	var spinnerState: SpinnerState = .idle
	var selectedSegmentIndex: Int? = nil
	var showToast: Bool = false
	var toastMessage: String = ""
	var isSpinning: Bool = false
}

