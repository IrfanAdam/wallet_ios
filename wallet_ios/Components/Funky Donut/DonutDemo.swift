import SwiftUI

struct ChartDonutDemoView: View {
	let data: [SalesData]
	let total: Double

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
				if let selected = mainContext.interaction.selectedData {
					Text("Sales of: \(selected.name)").font(.headline)
					Button("Clear") { withAnimation {
						mainContext.interaction.selectedData = nil
						pseudoContext.interaction.selectedData = nil
					} }.font(.subheadline).foregroundStyle(.secondary)
				} else {
					Text("Tap a segment").foregroundStyle(.secondary)
				}
			}
		}
	}
}

extension ChartDonutDemoView {
	init(data: [SalesData], total: Double) {
		self.data = data
		self.total = total
		_pseudoContext = State(initialValue: .init(data: data, total: total, isPseudo: true))
		_mainContext = State(initialValue: .init(data: data, total: total, isPseudo: false))
	}
}

struct ChartDonutDemoView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView(
			data: [
				.init(name: "A", sales: 20),
				.init(name: "B", sales: 24),
				.init(name: "C", sales: 16),
				.init(name: "D", sales: 32)
			],
			total: 240
		)
	}
}
