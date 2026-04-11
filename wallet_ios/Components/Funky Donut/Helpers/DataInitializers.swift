import SwiftUI

struct DonutData: Identifiable, Equatable {
	let id: UUID
	let name: String
	let sales: Double
	let imgPath: String
	init(id: UUID = UUID(), name: String, sales: Double, imgPath: String) {
		self.id = id
		self.name = name
		self.sales = sales
		self.imgPath = imgPath
	}
}

struct DonutSlice: Identifiable {
	let id: UUID
	let startAngle: Double
	let endAngle: Double
}

@Observable
final class DonutChartContext {
	var model: Model
	var interaction: Interaction
	var animation: Animation
	var layout: Layout
	
	// MARK: - Initializers
	init(data: [DonutData], dataMax: Double) {
		self.model = Model(data: data, dataMax: dataMax)
		self.interaction = Interaction()
		self.animation = Animation()
		self.layout = Layout()
	}
}

enum ChartDonutDataProcessor {
	static func preprocess(context: DonutChartContext) -> [DonutData] {
		let data = context.model.data
		let remainder = max(0, context.model.dataMax - data.reduce(0) { $0 + $1.sales })
		let sorted = data.sorted { $0.sales < $1.sales }
		if remainder > 0 {
			return sorted + [.init(name: "Remaining", sales: remainder, imgPath: "")]
		}
		return sorted
	}
}

