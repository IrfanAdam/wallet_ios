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
		let renderBorder = isPseudo && isSelected
		
		if renderBorder {
			return .init(
				innerRadius: 0.94,
				outerRadius: 1.0,
				inset: 12,
				cornerRadius: 12,
				color: .black.opacity(0.8)
			)
		}
		
		return .init(
			innerRadius: 0.7,
			outerRadius: isSelected ? 0.9 : 0.8,
			inset: isSelected ? 4 : 1,
			cornerRadius: 8,
			color: ChartColors.color(for: element, in: allData)
		)
	}
}
