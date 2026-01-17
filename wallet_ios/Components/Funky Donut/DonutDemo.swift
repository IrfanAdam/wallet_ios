import SwiftUI

struct ChartDonutDemoView: View {
	let data: [SalesData]
	let total: Double
	@State private var selectedData: SalesData?
	
	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				ChartDonutView(
					data: data,
					total: total,
					selectedData: $selectedData,
					isPseudo: true
				)
				ChartDonutView(
					data: data,
					total: total,
					selectedData: $selectedData
				)

				VStack(spacing: 8) {
					if let selectedData {
						Text("Sales of : \(selectedData.name)").font(.headline)
						Button("Clear") { withAnimation {
							self.selectedData = nil
						}}
						.font(.subheadline)
						.foregroundStyle(.secondary)
					} else {
						Text("Tap a segment").foregroundStyle(.secondary)
					}
				}
			}
		}
	}
}

struct ChartDonutDemoView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView(
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
