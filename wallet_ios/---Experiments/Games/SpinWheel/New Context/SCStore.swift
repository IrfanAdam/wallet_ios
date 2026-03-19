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
		theme: SCTheme = .default
	) {
		self.segments = segments
		self.theme = theme

		let geometry = Geometry2(
			wheelSize: 240,
			segmentCount: segments.count
		)

		self.geometry = geometry

		self.engine = Engine(
			geometry: geometry,
			segments: segments   // ✅ pass here
		)

		self.engine.initializeRotation(
			segmentCount: geometry.spinWheel.segmentCount
		)
	}

	func segmentState(for index: Int) -> SpinnerSegmentState {
		let colors = theme.colors

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

		let color =
		index.isMultiple(of: 2)
		? colors.brandBlue
		: colors.brandSky

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
			color: color,
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
	let color: Color
	let opacity: Double
	let imgOpacity: Double
	let imageName: String
	let imageScale: CGFloat
	let imageRotation: Double
	let offset: CGPoint
}

//Additional

struct PointerConfig {
	var frameSize: CGFloat = 22
	var anchorY: CGFloat = 0.35
	var wobbleDeflection: Double = 18.0
	var wobbleDelay: Double = 0.08
	var offsetX: CGFloat = -4
	var offsetY: CGFloat = -8
}
//
struct MessagingConfig {
	var scaleTransition: CGFloat = 0.85
	var vStackSpacing: CGFloat = 16
	var horizontalPadding: CGFloat = 40
	var yOffset: CGFloat = 60
	var toastVerticalPadding: CGFloat = 12
	var toastCornerRadius: CGFloat = 14
}

