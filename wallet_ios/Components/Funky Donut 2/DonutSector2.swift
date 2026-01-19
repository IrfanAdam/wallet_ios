import SwiftUI
import Charts

struct ChartDonutSector2: ChartContent {
	let element: SalesData
	let context: DonutChartContext2

	@ChartContentBuilder
	var body: some ChartContent {
		let style = ChartDonutStyle.segmentStyle(
			for: element,
			selectedData: context.interaction.selectedData,
			isPseudo: context.layout.isPseudo,
			allData: context.model.processedData
		)

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
