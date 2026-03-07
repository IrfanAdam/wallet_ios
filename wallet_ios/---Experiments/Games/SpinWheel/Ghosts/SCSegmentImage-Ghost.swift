import SwiftUI

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

		let selectedIndex = store.selectedSegmentIndex
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
			imageRotation: -store.rotation,
			offsetX: offsetX,
			offsetY: offsetY
		)
	}
}
