import SwiftUI
import AVFoundation

extension SpinnerSegmentChart {
	struct SegmentState {
		let innerRadius: CGFloat
		let outerRadius: CGFloat
		let color: Color
		let opacity: Double
	}

	func segmentState(for index: Int) -> SegmentState {
		let selectedIndex = store.anim.selectedSegmentIndex
		let isSelected = index == selectedIndex
		let hasSelection = selectedIndex != nil
		let colors = store.config.colors

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

		return SegmentState(
			innerRadius: innerRadius,
			outerRadius: outerRadius,
			color: color,
			opacity: opacity
		)
	}
}

extension SpinnerSegmentImages {
	struct SegmentState {
		let imageName: String
		let imageSize: CGFloat
		let scale: CGFloat
		let imageRotation: Double
		let offsetX: CGFloat
		let offsetY: CGFloat
	}
	
	func segmentState(for index: Int) -> SegmentState {
		let selectedIndex = store.anim.selectedSegmentIndex
		let isSelected = index == selectedIndex
		let hasSelection = selectedIndex != nil
		
		let segmentAngle = geometry.segmentAngle
		let midAngle = Double(index) * segmentAngle + (segmentAngle / 2) - 90
		let radians = midAngle * .pi / 180
		
		let isActive = !hasSelection || isSelected
		
		let imageSize = isActive ? seg.imageSize : 0
		let scale = isSelected ? seg.selectedScale : 1.0
		
		let offsetX = cos(radians) * radius
		let offsetY = sin(radians) * radius
		
		return SegmentState(
			imageName: store.segments[index].imageName,
			imageSize: imageSize,
			scale: scale,
			imageRotation: -store.anim.rotation,
			offsetX: offsetX,
			offsetY: offsetY
		)
	}
}

extension SpinnerPointer {
	var frameSize:       CGFloat   { ptr.frameSize }
	var wobbleAnchor:    UnitPoint { UnitPoint(x: 0.5, y: ptr.anchorY) }
	var pointerRotation: Double    { store.geometry.pointerRotation }
	var pointerOffset:   CGSize    { store.geometry.pointerOffset() }
	
	
	var boundaryIndex: Int {
		let normalized = store.anim.rotation.truncatingRemainder(dividingBy: 360)
		let positive   = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / store.geometry.segmentAngle).rounded()) % store.segmentCount
	}
	
	var spinDirection: Double {
		store.anim.rotation - lastRotation > 0 ? 1 : -1
	}
	
	var wobbleAnimation: Animation {
		.interpolatingSpring(
			mass:      pointerAnim.wobbleMass,
			stiffness: pointerAnim.wobbleStiffness,
			damping:   pointerAnim.wobbleDamping
		)
	}
	var wobbleReturnAnimation: Animation {
		.interpolatingSpring(
			mass:      pointerAnim.wobbleMass,
			stiffness: pointerAnim.returnStiffness,
			damping:   pointerAnim.returnDamping
		)
	}
}

final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []
	
	func tick(intensity: Double = 1.0) {
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}


