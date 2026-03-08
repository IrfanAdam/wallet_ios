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

struct RewardSpinnerConfig {
	// MARK: Layout
	var wheelSize: CGFloat = 240
	// MARK: - Segments  ← NEW

	// MARK: Theme
	var colors = BrandColors()

	// MARK: Interaction Feel
	var dragSensitivity: Double = 0.25
	var momentumMultiplier: Double = 8
	var minimumSpinDegrees: Double = 720

	// MARK: Animation
	var springMass: Double = 1.2
	var springStiffness: Double = 40
	var springDamping: Double = 8
	var animationDuration: Double = 2.4

	// MARK: Physics  ← NEW
	var friction: Double = 0.97
	var stopThreshold: Double = 5
}

struct BrandColors {
	let brandBlue: Color
	let brandSky: Color
	let brandOrange: Color

	init(
		brandBlue: Color = Color(red: 0/255, green: 111/255, blue: 235/255),
		brandSky: Color = Color(red: 82/255, green: 178/255, blue: 255/255),
		brandOrange: Color = Color(red: 235/255, green: 124/255, blue: 0/255)
	) {
		self.brandBlue = brandBlue
		self.brandSky = brandSky
		self.brandOrange = brandOrange
	}
}
