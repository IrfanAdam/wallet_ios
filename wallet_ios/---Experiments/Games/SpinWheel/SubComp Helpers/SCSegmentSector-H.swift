import SwiftUI

extension SpinnerSegmentChart {
	struct SegmentState {
		let innerRadius: CGFloat
		let outerRadius: CGFloat
		let color: Color
		let opacity: Double
	}

	func segmentState(for index: Int) -> SegmentState {
		let selectedIndex = store.anim.selectedSegmentIndex
		let isSelected = index == selectedIndex
		let hasSelection = selectedIndex != nil
		let colors = store.config.colors

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
