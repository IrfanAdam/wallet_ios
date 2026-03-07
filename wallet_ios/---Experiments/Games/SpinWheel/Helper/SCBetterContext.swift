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
	var wobbleSpringMass: Double = 0.3
	var wobbleSpringStiffness: Double = 300
	var wobbleSpringDamping: Double = 6
	var returnSpringStiffness: Double = 200
	var returnSpringDamping: Double = 8
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
	var dismissSpringResponse: Double = 0.4
	var dismissSpringDamping: Double = 0.7
	var toastDismissDelay: Double = 1.4
}

struct SpinAnimationConfig {
	var failSnapMass: Double = 0.6
	var failSnapStiffness: Double = 140
	var failSnapDamping: Double = 16
	var successSnapMass: Double = 0.6
	var successSnapStiffness: Double = 120
	var successSnapDamping: Double = 14
	var completionSpringResponse: Double = 0.4
	var completionSpringDamping: Double = 0.6
	var completionDelay: Double = 0.3
	var toastDismissDelay: Double = 1.4
}

struct GlowConfig {
	var opacity: Double = 0.04
	var blur: CGFloat = 4
	var padding: CGFloat = -2
}

struct RewardSpinnerGeometry {
	let config: RewardSpinnerConfig
	
	var segments: SegmentConfig = .init()
	// add alongside segments
	var pointer: PointerConfig = .init()
	var glow: GlowConfig = .init()
	var messaging: MessagingConfig = .init()
	var spinAnimation: SpinAnimationConfig = .init()

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
