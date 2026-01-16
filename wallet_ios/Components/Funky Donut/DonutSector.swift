import SwiftUI
import Charts

struct ChartDonutSector: ChartContent {
	let element: SalesData
	let selectedName: String?
	let isPseudo: Bool
	let allData: [SalesData]

	@ChartContentBuilder
	var body: some ChartContent {
		let style = ChartDonutStyle.segmentStyle(
			for: element,
			selectedName: selectedName,
			isPseudo: isPseudo,
			allData: allData
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
