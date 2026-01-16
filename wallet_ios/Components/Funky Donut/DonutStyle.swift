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
				? .gray.opacity(0.1)
				: isPseudoBorder
				? .black.opacity(0.8)
				: ChartColors.color(for: element, in: allData)
		)
	}
}

struct ChartColors {
	static func color(for element: SalesData, in data: [SalesData]) -> Color {
		guard let index = data.firstIndex(where: { $0.id == element.id }) else {
			return .clear
		}

		let segmentCount = max(data.count - 1, 1)
		let progress = segmentCount > 1 ? Double(index - 1) / Double(segmentCount - 1) : 0
		let minBrightness = 0.35
		let maxBrightness = 0.85
		let brightness = maxBrightness - progress * (maxBrightness - minBrightness)

		return Color(hue: 0.58, saturation: 0.75, brightness: brightness)
	}
}
