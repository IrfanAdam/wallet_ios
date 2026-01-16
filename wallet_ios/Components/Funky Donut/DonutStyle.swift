import SwiftUI

struct ChartDonutStyle {
	struct SegmentStyle {
		let innerRadius: CGFloat
		let outerRadius: CGFloat
		let inset: CGFloat
		let cornerRadius: CGFloat
		let color: Color
	}
	
	static func segmentStyle(
		for element: SalesData,
		selectedName: String?,
		isPseudo: Bool,
		allData: [SalesData]
	) -> SegmentStyle {

		let isSelected = selectedName == element.name
		let isPseudoBorder = isPseudo && isSelected
		let isRemaining = element.name == "Remaining"

		return .init(
			innerRadius: isPseudoBorder ? 0.94 : 0.7,
			outerRadius: isPseudoBorder ? 1.0 : (isSelected ? 0.9 : 0.8),
			inset: isPseudoBorder ? 12 : (isSelected ? 3 : 1),
			cornerRadius: isPseudoBorder ? 12 : 8,
			color: isRemaining
				? .gray.opacity(0.06)
				: isPseudoBorder
				? .black.opacity(0.8)
				: ChartColors.color(for: element, in: allData)
		)
	}
}
