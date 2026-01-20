import SwiftUI

struct ChartDonutDemoView2: View {
	let data: [SalesData]
	let total: Double

	@State private var selectedData: SalesData?
	@State private var context: DonutChartContext2

	var body: some View {
		ZStack {
			ZStack {
				ChartDonutView2(context: context, selectedData: $selectedData, isPseudo: true)
				ChartDonutView2(context: context, selectedData: $selectedData, isPseudo: false)

			}

			VStack(spacing: 8) {
				if let selected = selectedData {
					Text("Sales of: \(selected.name)")
						.font(.headline)
					Button("Clear") { withAnimation { selectedData = nil } }
						.font(.subheadline)
						.foregroundStyle(.secondary)
				} else {
					Text("Tap a segment")
						.foregroundStyle(.secondary)
				}
			}
		}
	}
}

private extension ChartDonutDemoView2 {
	init(data: [SalesData], total: Double) {
		self.data = data
		self.total = total
		_context = State(initialValue: .init(data: data, total: total, isPseudo: true))
	}
}

struct ChartDonutDemoView2_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView2(
			data: [
				.init(name: "A", sales: 20),
				.init(name: "B", sales: 15),
				.init(name: "C", sales: 10),
				.init(name: "D", sales: 60)
			],
			total: 240
		)
	}
}
