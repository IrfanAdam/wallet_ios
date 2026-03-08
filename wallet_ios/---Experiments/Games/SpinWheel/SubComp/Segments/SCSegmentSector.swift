import SwiftUI
import Charts

struct SpinnerSegmentChart: View {

	let store: RewardSpinnerStore

	var geometry: RewardSpinnerGeometry { store.geometry }
	var seg: SegmentConfig { geometry.segments }
	var segAnim: RewardSpinnerAnimationConfig.Segments { store.animations.segments }

	var body: some View {
		Chart(0..<store.segmentCount, id: \.self) { index in
			let segProps = segmentState(for: index)

			SectorMark(
				angle: .value("Segment", 1),
				innerRadius: .ratio(segProps.innerRadius),
				outerRadius: .ratio(segProps.outerRadius),
				angularInset: seg.angularInset
			)
			.cornerRadius(seg.cornerRadius)
			.foregroundStyle(segProps.color)
			.opacity(segProps.opacity)
		}
		.animation(
			.spring(
				response:       segAnim.selectionResponse,
				dampingFraction: segAnim.selectionDamping
			),
			value: store.anim.selectedSegmentIndex
		)
	}
}
