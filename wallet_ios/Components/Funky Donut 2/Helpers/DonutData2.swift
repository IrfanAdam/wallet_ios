import SwiftUI

enum ChartDonutDataProcessor2 {
	static func preprocess(context: DonutChartContext2) -> [SalesData] {
		let data = context.model.data
		let total = context.model.total
		let sum = data.reduce(0) { $0 + $1.sales }
		let remainder = max(total - sum, 0)
		var sortedData = data.sorted { $0.sales < $1.sales }
		if remainder > 0 {
			sortedData.append(
				SalesData(name: "Remaining", sales: remainder)
			)
		}
		return sortedData
	}
}
