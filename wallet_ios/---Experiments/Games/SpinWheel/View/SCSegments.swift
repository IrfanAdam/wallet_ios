import SwiftUI
import Charts

struct SpinnerSegment: Identifiable {
	let id = UUID()
	let imageName: String
}

struct SpinnerSegments: View {
	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }
	private var seg: SegmentConfig { geometry.segments }

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
			.fill(Color.brandBlue.opacity(glow.opacity))
			.blur(radius: glow.blur)
			.padding(glow.padding)
	}
}

extension Color {
	static let brandBlue   = Color(red: 0/255,   green: 111/255, blue: 235/255)
	static let brandSky    = Color(red: 82/255,  green: 178/255, blue: 255/255)
	static let brandOrange = Color(red: 235/255, green: 124/255, blue: 0/255)
}
