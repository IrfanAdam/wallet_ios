import SwiftUI
import Charts

struct ChartDonutSector2: ChartContent {
	let element: SalesData
	let context: DonutChartContext2

	@ChartContentBuilder
	var body: some ChartContent {
		let style = context.segmentStyle(for: element, isPseudo: context.layout.isPseudo)
		SectorMark(
			angle: .value("Sales", element.sales),
			innerRadius: .ratio(style.innerRadius),
			outerRadius: .ratio(style.outerRadius),
			angularInset: style.inset
		)
		.foregroundStyle(style.color)
		.cornerRadius(style.cornerRadius)
	}
}

extension DonutChartContext2 {
	func segmentStyle(for element: SalesData, isPseudo: Bool) -> ChartDonutStyle.SegmentStyle {
		ChartDonutStyle.segmentStyle(
			for: element,
			selectedData: interaction.selectedData,
			isPseudo: layout.isPseudo,
			allData: model.processedData
		)
	}
}
