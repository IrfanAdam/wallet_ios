import SwiftUI

struct ChartDonutDemoView: View {
	let data: [SalesData]
	@State private var selectedName: String?
	
	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				ChartDonutView(data: data, selectedName: $selectedName, isPseudo: true)
				ChartDonutView(data: data, selectedName: $selectedName)

				VStack(spacing: 12) {
					if let selectedName {
						Text("Selected: \(selectedName)").font(.headline)
						Button("Clear") { withAnimation { self.selectedName = nil } }
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
			]
		)
		.padding()
	}
}
