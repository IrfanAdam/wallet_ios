import SwiftUI
import Charts

struct SalesData: Identifiable {
	let id = UUID()
	let name: String
	let sales: Double
}

struct ChartDonutView: View {
	let data: [SalesData]
	@Binding var selectedName: String?

	@State private var selectedAngle: Double? = nil

	var body: some View {
		Chart(data, id: \.id) { element in
			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(0.72),
				angularInset: 1.5
			)
			.cornerRadius(5)
			.foregroundStyle(by: .value("Name", element.name))
		}
		.chartAngleSelection(value: $selectedAngle)
		.frame(width: 300, height: 300)
		.onChange(of: selectedAngle) { oldValue, newValue in
			guard let angle = newValue else {
				selectedName = nil
				return
			}

			// Map angle to segment
			let total = data.reduce(0) { $0 + $1.sales }
			var start: Double = 0
			for element in data {
				let sweep = element.sales / total * 360
				if angle >= start && angle <= start + sweep {
					selectedName = element.name
					break
				}
				start += sweep
			}
		}

	}
}

struct ChartDonutView_Previews: PreviewProvider {
	@State static var selected: String? = "B"

	static let chartData: [SalesData] = [
		.init(name: "A", sales: 20),
		.init(name: "B", sales: 15),
		.init(name: "C", sales: 40),
		.init(name: "D", sales: 25)
	]

	static var previews: some View {
		ChartDonutView(data: chartData, selectedName: $selected)
			.padding()
	}
}

