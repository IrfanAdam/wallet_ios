import SwiftUI
import Charts

struct ChartDonutDemoView: View {
	let data: [SalesData]
	let dataMax: Double

	@State private var pseudoContext: DonutChartContext
	@State private var mainContext: DonutChartContext

	var body: some View {
		ZStack {
			ZStack {
				ChartDonutView(context: pseudoContext)
				ChartDonutView(context: mainContext)
			}
			.modifier(
				DonutChartCoordinator(
					main: mainContext,
					pseudo: pseudoContext
				)
			)
			VStack(spacing: 8) {
				DonutSelectionInfoView(
					mainContext: mainContext,
					pseudoContext: pseudoContext
				)
			}
		}
	}
}

extension ChartDonutDemoView {
	init(data: [SalesData], dataMax: Double) {
		self.data = data
		self.dataMax = dataMax
		_pseudoContext = State(initialValue: .init(data: data, dataMax: dataMax, isPseudo: true))
		_mainContext = State(initialValue: .init(data: data, dataMax: dataMax, isPseudo: false))
	}
}
