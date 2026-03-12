import SwiftUI

// MARK: - Geometry (pure, no runtime state)

struct Geometry2 {

	// Inputs
	let segmentCount: Int
	var spinWheel: SpinWheel
	var parts: Parts = .init()

	// Convenience init, keeps your old call site
	init(wheelSize: CGFloat, segmentCount: Int) {
		self.segmentCount = segmentCount
		self.spinWheel = SpinWheel(wheelSize: wheelSize, segmentCount: segmentCount)
		self.parts = Parts()
	}

	// MARK: - Sub-structs



	struct Parts {
		var segment = Segment()
		var pointer = Pointer()
		var image   = Image()
	}

	struct SpinWheel {
		let wheelSize: CGFloat
		let segmentCount: Int

		var minimumSpinDegrees: Double = 720

		var radius: CGFloat { wheelSize / 2 }
		var segmentAngle: Double { 360.0 / Double(max(segmentCount, 1)) }

		var initialRotation: Double { -segmentAngle / 2 }
		var pointerRotation: Double { -segmentAngle / 2 }
	}

	struct Segment {
		var innerRadiusRatio: CGFloat = 0.32
		var innerRadiusSelectedOffset: CGFloat = 0.04
		var outerRadiusNormal: CGFloat = 0.98
		var outerRadiusSelected: CGFloat = 1.10
		var angularInset: CGFloat = 2
		var cornerRadius: CGFloat = 8
		var dimOpacity: Double = 0.32
	}

	struct Pointer {
		var size: CGFloat = 22
		var anchorY: CGFloat = 0.35
		var offsetX: CGFloat = -4
		var offsetY: CGFloat = -8
	}

	struct Image {
		var size: CGFloat = 48
		var selectedScale: CGFloat = 1.15
	}

	// MARK: - Derived helpers

	func pointerOffset() -> CGSize {
		let radius = spinWheel.radius
		let segmentAngle = spinWheel.segmentAngle

		let boundaryAngle: Double = -90 - segmentAngle / 2
		let radians = boundaryAngle * .pi / 180
		return CGSize(
			width: cos(radians) * Double(radius) + Double(parts.pointer.offsetX),
			height: sin(radians) * Double(radius) + Double(parts.pointer.offsetY)
		)
	}
}
