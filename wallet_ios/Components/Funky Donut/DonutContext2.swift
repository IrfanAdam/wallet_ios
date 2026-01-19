import SwiftUI

@Observable
final class DonutChartContext2 {
	var model: Model
	var interaction: Interaction
	var animation: Animation
	var layout: Layout

	// MARK: - Initializers
	init(data: [SalesData], total: Double, isPseudo: Bool) {
		self.model = Model(data: data, total: total)
		self.interaction = Interaction()
		self.animation = Animation()
		self.layout = Layout(isPseudo: isPseudo)
	}
}

// MARK: - Sub-contexts
extension DonutChartContext2 {
	struct Model {
		let data: [SalesData]
		let total: Double
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
}
