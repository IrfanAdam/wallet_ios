import SwiftUI


struct SpinnerSegment: Identifiable {
	let id = UUID()
	let imageName: String
}


// MARK: - Public Store (what views see)

@Observable
final class RewardSpinnerStore {

	// MARK: Inputs

	let segments: [SpinnerSegment]
	let theme: SCTheme
	var geometry: Geometry2
	var engine: Engine

	init(
		segments: [SpinnerSegment],
		theme: SCTheme = .default,
		engine: Engine = .init()
	) {
		self.segments = segments
		self.theme = theme
		self.geometry = Geometry2(
			wheelSize: 240,
			segmentCount: segments.count
		)
		self.engine = engine
		self.engine.initializeRotation(segmentCount: geometry.spinWheel.segmentCount)
	}
	
	
	// TEMP COMPATIBILITY
	
	var rotation: Double {
		get { engine.physics.rotation }
		set { engine.physics.rotation = newValue }
	}
	
	var selectedSegmentIndex: Int? {
		get { engine.model.selectedIndex }
		set { engine.model.selectedIndex = newValue }
	}
	
	var spinnerState: Engine.Phase {
		get { engine.model.phase }
		set { engine.model.phase = newValue }
	}


	func segmentState(for index: Int) -> SpinnerSegmentState {

		let seg = self.geometry.components.segment
		let img = self.geometry.components.image

		let selected = engine.model.selectedIndex
		let isSelected = index == selected
		let hasSelection = selected != nil

		let innerRadius =
		isSelected
		? seg.innerRadiusRatio - seg.innerRadiusSelectedOffset
		: seg.innerRadiusRatio

		let outerRadius =
		isSelected
		? seg.outerRadiusSelected
		: seg.outerRadiusNormal

		let opacity =
		(!hasSelection || isSelected)
		? 1.0
		: seg.dimOpacity

		let imgOpacity =
		(!hasSelection || isSelected)
		? 1.0
		: 0


		let scale = isSelected ? img.selectedScale : 1.0

		let offset = self.geometry.imageOffset(for: index)

		return SpinnerSegmentState(
			innerRadius: innerRadius,
			outerRadius: outerRadius,
			opacity: opacity,
			imgOpacity: imgOpacity,
			imageName: segments[index].imageName,
			imageScale: scale,
			imageRotation: -engine.physics.rotation,
			offset: CGPoint(x: offset.x, y: offset.y)
		)
	}
}

struct SpinnerSegmentState {
	let innerRadius: CGFloat
	let outerRadius: CGFloat
	let opacity: Double
	let imgOpacity: Double
	let imageName: String
	let imageScale: CGFloat
	let imageRotation: Double
	let offset: CGPoint
}

struct SCTheme {
	var colors: SCColors
	
	static let `default` = SCTheme(colors: .init())
}

struct SCColors {
	var wheelBackground = Color.white.opacity(0.48)
	var brandBlue       = Color(red: 0/255, green: 111/255, blue: 235/255)
	var brandSky        = Color(red: 82/255, green: 178/255, blue: 255/255)
	var brandOrange     = Color(red: 235/255, green: 124/255, blue: 0/255)
}

enum SpinnerAnimationStyle {
	case snappy
	case smooth
	case bouncy
	case quick
	
	var animation: Animation {
		switch self {
		case .snappy:
			return .interpolatingSpring(mass: 0.5, stiffness: 180, damping: 16)
		case .smooth:
			return .spring(response: 0.5, dampingFraction: 0.9)
		case .bouncy:
			return .spring(response: 0.4, dampingFraction: 0.6)
		case .quick:
			return .easeOut(duration: 0.2)
		}
	}
}
