import SwiftUI

// MARK: - Public Store (what views see)

@Observable
final class RewardSpinnerStore2 {

	// MARK: Inputs

	let segments: [SpinnerSegment2]
	let theme: Theme2
	let geometry: Geometry2
	var engine: Engine

	init(
		segments: [SpinnerSegment2],
		theme: Theme2 = .default,
		engine: Engine = .init()
	) {
		self.segments = segments
		self.theme = theme
		self.geometry = Geometry2(
			wheelSize: 240,
			segmentCount: segments.count
		)

		self.engine = engine
		self.engine.physics.rotation = geometry.spinWheel.initialRotation
	}
}

// MARK: - Model types

struct SpinnerSegment2: Identifiable {
	let id = UUID()
	let imageName: String
}


