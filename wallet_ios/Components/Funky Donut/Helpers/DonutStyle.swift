import SwiftUI

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

extension DonutChartContext {
	struct SegmentStyle {
		let element: SalesData
		let isSelected: Bool
		let isHighlightRing: Bool
		let allData: [SalesData]
		
		var innerRadius: CGFloat { isSelected ? 0.69 : 0.72 }
		var outerRadius: CGFloat { isHighlightRing ? 1.0 : (isSelected ? 0.82 : 0.82) }
		var inset: CGFloat { isHighlightRing ? 12 : (isSelected ? 4 : 1) }
		var cornerRadius: CGFloat { isHighlightRing ? 12 : 8 }
		
		var color: Color {
			element.name == "Remaining"
			? .gray.opacity(0.1)
			: ChartColors.color(for: element, in: allData)
		}
	}
	
	func sectorStyle(for element: SalesData) -> SegmentStyle {
		let isSelected = interaction.selectedData?.id == element.id
		return SegmentStyle(
			element: element,
			isSelected: isSelected,
			isHighlightRing: layout.isPseudo && isSelected,
			allData: model.processedData
		)
	}
}
