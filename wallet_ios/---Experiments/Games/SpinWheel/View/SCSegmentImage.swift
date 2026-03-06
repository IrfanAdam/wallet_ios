import SwiftUI

struct SpinnerSegmentImages: View {

	let store: RewardSpinnerStore
	let radius: CGFloat

	private var geometry: RewardSpinnerGeometry { store.geometry }
	private var seg: SegmentConfig { geometry.segments }

	var body: some View {

		let segmentAngle = geometry.segmentAngle

		ForEach(0..<store.segmentCount, id: \.self) { index in

			let isSelected = index == store.selectedSegmentIndex
			let midAngle = Double(index) * segmentAngle + (segmentAngle / 2) - 90
			let radians = midAngle * .pi / 180

			Image(store.segments[index].imageName)
				.resizable()
				.scaledToFill()
				.frame(
					width: isActiveImage(isSelected) ? seg.imageSize : 0,
					height: isActiveImage(isSelected) ? seg.imageSize : 0
				)
				.background(Circle().fill(Color.brandOrange))
				.clipShape(Circle())
				.rotationEffect(.degrees(-store.rotation))
				.scaleEffect(isSelected ? seg.selectedScale : 1.0)
				.animation(.spring(response: 0.4), value: store.selectedSegmentIndex)
				.offset(
					x: cos(radians) * radius,
					y: sin(radians) * radius
				)
		}
	}

	private func isActiveImage(_ isSelected: Bool) -> Bool {
		store.selectedSegmentIndex == nil || isSelected
	}
}
