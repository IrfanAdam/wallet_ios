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
}
