import SwiftUI

struct SpinnerSegmentImages: View {
	let store: RewardSpinnerStore
	let radius: CGFloat

	var geometry: RewardSpinnerGeometry { store.geometry }
	var seg: SegmentConfig { geometry.segments }
	var colors: BrandColors { store.config.colors }

	var body: some View {
		ForEach(0..<store.segmentCount, id: \.self) { index in
			let segProps = segmentState(for: index)

			Image(segProps.imageName)
				.resizable()
				.scaledToFill()
				.frame(
					width: segProps.imageSize,
					height: segProps.imageSize
				)
				.background(Circle().fill(colors.brandOrange))
				.clipShape(Circle())
				.rotationEffect(.degrees(segProps.imageRotation))
				.scaleEffect(segProps.scale)
				.offset(
					x: segProps.offsetX,
					y: segProps.offsetY
				)
		}
	}
}
