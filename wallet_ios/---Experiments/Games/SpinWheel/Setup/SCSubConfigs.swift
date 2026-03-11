import SwiftUI

struct SegmentConfig {
	var innerRadiusRatio: CGFloat = 0.32
	var innerRadiusSelectedOffset: CGFloat = 0.04
	var outerRadiusNormal: CGFloat = 0.98
	var outerRadiusSelected: CGFloat = 1.1
	var angularInset: CGFloat = 2
	var cornerRadius: CGFloat = 8
	var dimOpacity: Double = 0.32
	var imageSize: CGFloat = 48
	var selectedScale: CGFloat = 1.15
}

struct PointerConfig {
	var frameSize: CGFloat = 22
	var anchorY: CGFloat = 0.35
	var wobbleDeflection: Double = 18.0
	var wobbleDelay: Double = 0.08
	var offsetX: CGFloat = -4
	var offsetY: CGFloat = -8
}

struct MessagingConfig {
	var scaleTransition: CGFloat = 0.85
	var vStackSpacing: CGFloat = 16
	var horizontalPadding: CGFloat = 40
	var yOffset: CGFloat = 60
	var toastVerticalPadding: CGFloat = 12
	var toastCornerRadius: CGFloat = 14
}

struct RewardSpinnerGeometry {
	let config: RewardSpinnerConfig
	
	var segments: SegmentConfig = .init()
	var pointer: PointerConfig = .init()

	let segmentCount: Int

	var segmentAngle: Double { 360.0 / Double(segmentCount) }

	var pointerRotation: Double { -segmentAngle / 2 }

	func pointerOffset() -> CGSize {
		let boundaryAngle: Double = -90 - segmentAngle / 2
		let radius: Double = config.wheelSize / 2
		let radians = boundaryAngle * Double.pi / 180

		return CGSize(
			width: cos(radians) * radius + pointer.offsetX,
			height: sin(radians) * radius + pointer.offsetY
		)
	}
}
//