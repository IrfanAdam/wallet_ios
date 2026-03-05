import SwiftUI

struct RewardSpinnerGeometry {

	let config: RewardSpinnerConfig
	let segmentCount: Int

	var segmentAngle: Double {
		360.0 / Double(segmentCount)
	}

	var pointerRotation: Double {
		-segmentAngle / 2
	}

	func pointerOffset() -> CGSize {
		let boundaryAngle: Double = -90 - segmentAngle / 2
		let radius: Double = config.wheelSize / 2
		let radians = boundaryAngle * Double.pi / 180

		return CGSize(
			width: cos(radians) * radius - 4,
			height: sin(radians) * radius - 8
		)
	}
}
