import SwiftUI

// MARK: - Data Model
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
	static func preprocess(
		data: [SalesData],
		total: Double
	) -> [SalesData] {

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

struct DonutChartContext {
	let data: [SalesData]
	let rawSelectedValue: Binding<Double?>
	let selectedName: Binding<String?>
	let chartRotation: Binding<Angle>
	let processedData: Binding<[SalesData]>
	let animatedData: Binding<[SalesData]>
}
