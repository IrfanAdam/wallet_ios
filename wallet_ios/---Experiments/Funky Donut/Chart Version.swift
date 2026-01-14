import SwiftUI
import Charts

// MARK: - Data Model
struct SalesData: Identifiable {
	let id = UUID()
	let name: String
	let sales: Double
}

// MARK: - Donut Chart View

struct ChartDonutView: View {
	let data: [SalesData]
	@Binding var selectedName: String? // Persistent selection for the parent
	let isPseudo: Bool

	init(
		data: [SalesData],
		selectedName: Binding<String?>,
		isPseudo: Bool = false
	) {
		self.data = data
		self._selectedName = selectedName
		self.isPseudo = isPseudo
	}

	// 1. Native temporary selection tracked by the chart
	@State private var rawSelectedValue: Double?

	var body: some View {
		Chart(data) { element in
			// 2. Highlight based on the persistent binding
			let isSelected = selectedName == element.name
			let renderBorder = isPseudo && isSelected
			if renderBorder {
				SectorMark(
					angle: .value("Sales", element.sales),
					innerRadius: .ratio(0.94),
					outerRadius: .ratio(1),
					angularInset: 12
				)
				.foregroundStyle(Color.black.opacity(0.8))
				.cornerRadius(12)
			} else {
				SectorMark(
					angle: .value("Sales", element.sales),
					innerRadius: .ratio(0.7),
					outerRadius: .ratio(isSelected ? 0.9 : 0.8),
					angularInset: isSelected ? 4.0 : 1.0
				)
				.foregroundStyle(by : .value("Name", element.name))
				.cornerRadius(8)
			}
		}
		.animation(.spring(response: 0.25, dampingFraction: 0.8), value: rawSelectedValue)
		.animation(.spring(response: 0.42, dampingFraction: 0.6), value: selectedName)
		.chartAngleSelection(value: $rawSelectedValue)
		.onChange(of: rawSelectedValue) { _, newValue in
			if let newValue {
				withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
					selectedName = findSelectedName(for: newValue)
				}
			}
		}
		.frame(width: 300, height: 300)
		.chartLegend(.hidden)
	}

	private func findSelectedName(for value: Double) -> String? {
		var cumulativeTotal: Double = 0
		for element in data {
			cumulativeTotal += element.sales
			if value <= cumulativeTotal { return element.name }
		}
		return nil
	}
}



// MARK: - Preview
struct ChartDonutView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutViewPreviewWrapper()
			.padding()
	}
}

// MARK: - Preview Wrapper
private struct ChartDonutViewPreviewWrapper: View {
	@State private var selectedName: String?

	private let chartData: [SalesData] = [
		.init(name: "A", sales: 20),
		.init(name: "B", sales: 15),
		.init(name: "C", sales: 40),
		.init(name: "D", sales: 25)
	]

	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				ChartDonutView(data: chartData, selectedName: $selectedName, isPseudo: true)
				ChartDonutView(data: chartData, selectedName: $selectedName)

				VStack(spacing: 12) {
					if let selectedName {
						Text("Selected: \(selectedName)")
							.font(.headline)

						Button("Clear") {
							withAnimation(.easeInOut(duration: 0.2)) {
								self.selectedName = nil
							}
						}
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
}
