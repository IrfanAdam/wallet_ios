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

	var colors = BrandColors()

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
		self.rotation = -segmentAngle / 2
	}
}
