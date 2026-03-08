import SwiftUI
import Charts

struct SpinnerSegments: View {
	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }

	var body: some View {
		GeometryReader { geo in
			let radius = geo.size.width / 2
			let imageRadius = radius * ((1 + geometry.segments.innerRadiusRatio) / 2)

			ZStack {

				SpinnerSegmentChart(store: store)

				SpinnerSegmentImages(
					store: store,
					radius: imageRadius
				)
			}
		}
		.rotationEffect(.degrees(store.rotation))
	}
}

