import SwiftUI
import Charts

struct ChartDonutSector: ChartContent {
	let element: SalesData
	let context: DonutChartContext
	
	@ChartContentBuilder
	var body: some ChartContent {
		let style = ChartDonutStyle.segmentStyle(
			for: element,
			selectedData: context.selectedData.wrappedValue,
			isPseudo: context.isPseudo,
			allData: context.processedData.wrappedValue
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
