import SwiftUI

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

	// MARK: Physics  ← NEW
	var friction: Double = 0.97
	var stopThreshold: Double = 5
}

struct BrandColors {
	let brandBlue = Color(red: 0/255, green: 111/255, blue: 235/255)
	let brandSky = Color(red: 82/255, green: 178/255, blue: 255/255)
	let brandOrange = Color(red: 235/255, green: 124/255, blue: 0/255)
	let wheelBG = Color.white.opacity(0.48)
	let pointerBlack = Color.black
	let circleBorder = Color.white
}

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

struct RewardSpinnerAnimationConfig {
	struct Spin {
		var failSnapMass: Double        = 0.6
		var failSnapStiffness: Double   = 140
		var failSnapDamping: Double     = 16
		
		var successSnapMass: Double     = 0.6
		var successSnapStiffness: Double = 120
		var successSnapDamping: Double   = 14
		
		var completionResponse: Double  = 0.4
		var completionDamping: Double   = 0.6
		
		var completionDelay: Double     = 0.3
		var toastDismissDelay: Double   = 1.4
	}
	
	struct Pointer {
		var wobbleMass: Double          = 0.3
		var wobbleStiffness: Double     = 300
		var wobbleDamping: Double       = 6
		
		var returnStiffness: Double     = 200
		var returnDamping: Double       = 8
	}
	
	struct Messaging {
		var scaleTransition: CGFloat    = 0.85
		var dismissResponse: Double     = 0.4
		var dismissDamping: Double      = 0.7
	}
	
	struct Segments {
		var selectionResponse: Double   = 0.4
		var selectionDamping: Double    = 1.0
	}
	
	var spin      = Spin()
	var pointer   = Pointer()
	var messaging = Messaging()
	var segments  = Segments()
}

