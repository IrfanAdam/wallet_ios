import SwiftUI

extension DonutChartContext {
	struct Model {
		let data: [DonutData]
		let dataMax: Double
		var processedData: [DonutData] = []
	}

	struct Interaction {
		var rawSelectedValue: Double? = nil
		var selectedData: DonutData? = nil
	}

	struct Animation {
		var animatedData: [DonutData] = []
		var rotationAngle: Angle = .degrees(0) // combined rotation
		var sliceAngles: [DonutSlice] = [] // combined rotation
	}

	struct Layout {
		let fillSpace: CGFloat = 0.88
		let donutWidth: CGFloat = 0.12
		let arcWidth: CGFloat = 8
		var geometry: [DonutData] = []
	}
	
	func makeSlices(from data: [DonutData]) -> [DonutSlice] {
		let total = data.reduce(0) { $0 + $1.sales }
		var current: Double = 0
		
		return data.map { item in
			let start = current
			let angle = item.sales / total * 360
			current += angle
			
			return DonutSlice(
				id: item.id,
				startAngle: start,
				endAngle: current
			)
		}
	}
	
	func selectedSlice() -> DonutSlice? {
		guard let id = interaction.selectedData?.id else { return nil }
		return animation.sliceAngles.first { $0.id == id }
	}
}

