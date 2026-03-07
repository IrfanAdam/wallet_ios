import SwiftUI
import Charts

struct SpinnerSegments: View {
	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }
	private var seg: SegmentConfig { geometry.segments }
	private var colors: BrandColors {
		store.config.colors
	}

	var body: some View {
		GeometryReader { geo in
			let radius = geo.size.width / 2
			let imageRadius = radius * ((1 + seg.innerRadiusRatio) / 2)

			ZStack {
				glowLayer

				SpinnerSegmentChart(store: store)

				SpinnerSegmentImages(
					store: store,
					radius: imageRadius
				)
			}
		}
		.rotationEffect(.degrees(store.rotation))
	}

	// MARK: - Glow
	private var glowLayer: some View {
		let glow = geometry.glow
		return Circle()
			.fill(colors.brandBlue.opacity(glow.opacity))
			.blur(radius: glow.blur)
			.padding(glow.padding)
	}
}

