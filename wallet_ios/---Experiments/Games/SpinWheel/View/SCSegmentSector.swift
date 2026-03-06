import SwiftUI
import Charts

struct SpinnerSegmentChart: View {

	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }
	private var seg: SegmentConfig { geometry.segments }

	var body: some View {
		Chart(0..<store.segmentCount, id: \.self) { index in
			let isSelected = index == store.selectedSegmentIndex

			SectorMark(
				angle: .value("Segment", 1),
				innerRadius: .ratio(
					isSelected
					? seg.innerRadiusRatio - seg.innerRadiusSelectedOffset
					: seg.innerRadiusRatio
				),
				outerRadius: .ratio(
					isSelected
					? seg.outerRadiusSelected
					: seg.outerRadiusNormal
				),
				angularInset: seg.angularInset
			)
			.cornerRadius(seg.cornerRadius)
			.foregroundStyle(
				index.isMultiple(of: 2)
				? Color.brandBlue
				: Color.brandSky
			)
			.opacity(
				store.selectedSegmentIndex == nil || isSelected
				? 1.0
				: seg.dimOpacity
			)
		}
	}
}
