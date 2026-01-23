import SwiftUI

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

// MARK: - Sub-contexts
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
}

extension DonutChartContext {
	struct SegmentStyle: Equatable {
		let innerRadius: CGFloat
		let outerRadius: CGFloat
		let inset: CGFloat
		let cornerRadius: CGFloat
		let color: Color
	}

	func segmentStyle(for element: SalesData) -> DonutChartContext.SegmentStyle {
		ChartDonutStyle.segmentStyle(
			for: element,
			selectedData: interaction.selectedData,
			isPseudo: layout.isPseudo,
			allData: model.processedData
		)
	}
}
