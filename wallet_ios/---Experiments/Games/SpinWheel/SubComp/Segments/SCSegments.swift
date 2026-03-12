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
		.rotationEffect(.degrees(store.anim.rotation))
		.onAppear {
			let base = store.anim.rotation
			withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
				store.anim.rotation = base - 90   // small nudge
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(.spring(response: 0.6, dampingFraction: 0.72)) {
					store.anim.rotation = base
				}
			}
		}
	}
}

