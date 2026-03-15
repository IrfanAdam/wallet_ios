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
		let selectedIndex = store.engine.model.selectedIndex
		let isSelected = index == selectedIndex
		let hasSelection = selectedIndex != nil
		let colors = store.theme.colors

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
		let selectedIndex = store.engine.model.selectedIndex
		let isSelected = index == selectedIndex
		let hasSelection = selectedIndex != nil
		
		let segmentAngle = geometry.spinWheel.segmentAngle
		let midAngle = Double(index) * segmentAngle + (segmentAngle / 2) - 90
		let radians = midAngle * .pi / 180
		
		let isActive = !hasSelection || isSelected
		
		let imageSize = isActive ? geometry.imageSize : 0
		let scale = isSelected ? geometry.components.image.selectedScale : 1.0
		
		let offsetX = cos(radians) * geometry.imageSize / 2
		let offsetY = sin(radians) * geometry.imageSize / 2
		
		return SegmentState(
			imageName: store.segments[index].imageName,
			imageSize: imageSize,
			scale: scale,
			imageRotation: -store.engine.physics.rotation,
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
		let normalized = store.engine.physics.rotation.truncatingRemainder(dividingBy: 360)
		let positive   = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / store.geometry.spinWheel.segmentAngle).rounded()) % store.segments.count
	}
	
	var spinDirection: Double {
		store.engine.physics.rotation - lastRotation > 0 ? 1 : -1
	}
}

final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []
	
	func tick(intensity: Double = 1.0) {
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}


