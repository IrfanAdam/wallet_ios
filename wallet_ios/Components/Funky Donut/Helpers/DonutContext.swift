import SwiftUI

extension DonutChartContext {
	struct Model {
		let data: [SalesData]
		let dataMax: Double
		var processedData: [SalesData] = []
	}

	struct Interaction {
		var rawSelectedValue: Double? = nil
		var selectedData: SalesData? = nil
	}

	struct Animation {
		var animatedData: [SalesData] = []
		var rotationAngle: Angle = .degrees(0) // combined rotation
	}

	struct Layout {
		let isPseudo: Bool
		var geometry: [SalesData] = []
	}

	func selectedTrimRange() -> (start: CGFloat, end: CGFloat)? {
		guard let selected = interaction.selectedData else { return nil }

		let data = model.processedData
		let total = model.dataMax

		var cumulative: Double = 0

		for element in data {
			let start = cumulative / total
			cumulative += element.sales
			let end = cumulative / total

			if element.id == selected.id {
				return (CGFloat(start), CGFloat(end))
			}
		}

		return nil
	}
}
