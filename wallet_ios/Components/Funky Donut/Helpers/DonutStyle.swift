import SwiftUI

struct ChartDonutStyle {
	static func segmentStyle(
		for element: SalesData,
		selectedData: SalesData?,
		isPseudo: Bool,
		allData: [SalesData]
	) -> DonutChartContext.SegmentStyle {

		let selected = selectedData?.id == element.id
		let pseudo = isPseudo && selected

		return .init(
			innerRadius: pseudo ? 0.94 : 0.7,
			outerRadius: pseudo ? 1.0 : (selected ? 0.9 : 0.8),
			inset: pseudo ? 12 : (selected ? 3 : 1),
			cornerRadius: pseudo ? 12 : 8,
			color: element.name == "Remaining"
			? .gray.opacity(0.1)
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
