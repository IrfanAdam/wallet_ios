import SwiftUI

// MARK: - Geometry (pure, no runtime state)

struct Geometry2 {

	// Inputs
	var spinWheel: SpinWheel
	var components: Components = .init()

	// Convenience init, keeps your old call site
	init(wheelSize: CGFloat, segmentCount: Int) {
		self.spinWheel = SpinWheel(wheelSize: wheelSize, segmentCount: segmentCount)
		self.components = Components()
	}
	

	// MARK: - Sub-structs
	struct SpinWheel {
		let wheelSize: CGFloat
		let segmentCount: Int

		var minimumSpinDegrees: Double = 720

		var radius: CGFloat { wheelSize / 2 }
		var segmentAngle: Double { 360.0 / Double(max(segmentCount, 1)) }
	}
	
	struct Components {
		var segment = Segment()
		var pointer = Pointer()
		var image   = Image()
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
	
	var pointerRotation: Double {
		-spinWheel.segmentAngle / 2
	}

	struct Pointer {
		var size: CGFloat = 22
		var anchorY: CGFloat = 0.35
		var offsetX: CGFloat = -4
		var offsetY: CGFloat = -8
	}
	
	var imageSize: CGFloat {
		spinWheel.radius * components.image.sizeRatio
	}
	
	func imageOffset(for index: Int) -> (x: CGFloat, y: CGFloat) {
		let imageRadius = spinWheel.radius * ((1 + components.segment.innerRadiusRatio) / 2)
		let midAngle = Double(index) * spinWheel.segmentAngle + (spinWheel.segmentAngle / 2) - 90
		let radians = midAngle * .pi / 180
		
		return (
			x: cos(radians) * imageRadius,
			y: sin(radians) * imageRadius
		)
	}

	struct Image {
		var sizeRatio: CGFloat = 0.36
		var selectedScale: CGFloat = 1.15
		var opacity: CGFloat = 0
	}

	// MARK: - Derived helpers

	func pointerOffset() -> CGSize {
		let radius = spinWheel.radius
		let segmentAngle = spinWheel.segmentAngle

		let boundaryAngle: Double = -90 - segmentAngle / 2
		let radians = boundaryAngle * .pi / 180
		return CGSize(
			width: cos(radians) * Double(radius) + Double(components.pointer.offsetX),
			height: sin(radians) * Double(radius) + Double(components.pointer.offsetY)
		)
	}
}

