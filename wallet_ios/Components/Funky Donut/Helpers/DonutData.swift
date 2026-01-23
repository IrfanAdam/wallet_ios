import SwiftUI

struct SalesData: Identifiable, Equatable {
	let id: UUID
	let name: String
	let sales: Double
	init(id: UUID = UUID(), name: String, sales: Double) {
		self.id = id
		self.name = name
		self.sales = sales
	}
}

enum ChartDonutDataProcessor {
	static func preprocess(context: DonutChartContext) -> [SalesData] {
		let data = context.model.data
		let dataMax = context.model.dataMax
		let sum = data.reduce(0) { $0 + $1.sales }
		let remainder = max(dataMax - sum, 0)
		var sortedData = data.sorted { $0.sales < $1.sales }
		if remainder > 0 {
			sortedData.append(
				SalesData(name: "Remaining", sales: remainder)
			)
		}
		return sortedData
	}
}
