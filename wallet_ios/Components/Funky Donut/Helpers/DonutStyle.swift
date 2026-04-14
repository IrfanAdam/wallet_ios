import SwiftUI

struct ChartColors {
	static func color(for element: DonutData, in data: [DonutData]) -> Color {
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
		let element: DonutData
		let isSelected: Bool
		let allData: [DonutData]
		
		var innerRadius: CGFloat { isSelected ? 0.76 : 0.76 }
		var outerRadius: CGFloat { isSelected ? 0.88 : 0.88 }
		var inset: CGFloat { isSelected ? 2.25 : 2 }
		var cornerRadius: CGFloat { isSelected ? 8 : 8 }

		var color: Color {
			element.name == "Remaining"
			? .white
			: ChartColors.color(for: element, in: allData)
		}

		var borderColor: Color {isSelected ? Color.blue : Color.blue.opacity(0.32)}
	}

	func sectorStyle(for element: DonutData) -> SegmentStyle {
		let isSelectedVal = interaction.selectedData?.id == element.id

		return SegmentStyle(
			element: element,
			isSelected: isSelectedVal,
			allData: model.processedData
		)
	}
}
