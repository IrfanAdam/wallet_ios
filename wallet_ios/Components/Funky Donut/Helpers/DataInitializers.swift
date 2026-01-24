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

@Observable
final class DonutChartContext {
	var model: Model
	var interaction: Interaction
	var animation: Animation
	var layout: Layout
	
	// MARK: - Initializers
	init(data: [SalesData], dataMax: Double, isPseudo: Bool) {
		self.model = Model(data: data, dataMax: dataMax)
		self.interaction = Interaction()
		self.animation = Animation()
		self.layout = Layout(isPseudo: isPseudo)
	}
}

enum ChartDonutDataProcessor {
	static func preprocess(context: DonutChartContext) -> [SalesData] {
		let data = context.model.data
		let remainder = max(0, context.model.dataMax - data.reduce(0) { $0 + $1.sales })
		let sorted = data.sorted { $0.sales < $1.sales }
		if remainder > 0 {
			return sorted + [.init(name: "Remaining", sales: remainder)]
		}
		return sorted
	}
}

