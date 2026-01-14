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

	// 1. Native temporary selection tracked by the chart
	@State private var rawSelectedValue: Double?

	var body: some View {
		Chart(data) { element in
			// 2. Highlight based on the persistent binding
			let isSelected = selectedName == element.name

			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(0.7),
				outerRadius: .ratio(isSelected ? 1.0 : 0.95),
				angularInset: 1
			)
			.foregroundStyle(by: .value("Name", element.name))
			.opacity(isSelected || selectedName == nil ? 1 : 0.4)
			.cornerRadius(6)
			.shadow(
				color: .black.opacity(isSelected ? 0.9 : 0),
				radius:0,
				x: 1, y: 1)
			.shadow(
				color: .black.opacity(isSelected ? 0.9 : 0),
				radius:0,
				x: -1, y: -1)
			.shadow(
				color: .black.opacity(isSelected ? 0.9 : 0),
				radius:0,
				x: -1, y: 1)
			.shadow(
				color: .black.opacity(isSelected ? 0.9 : 0),
				radius:0,
				x: 1, y: -1)
		}
		.animation(.spring(response: 0.25, dampingFraction: 0.8), value: rawSelectedValue)
		// 3. Bind to the temporary raw value
		.chartAngleSelection(value: $rawSelectedValue)
		// 4. Native way to capture and "persist" the value
		.onChange(of: rawSelectedValue) { _, newValue in
			if let newValue {
				withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
					selectedName = findSelectedName(for: newValue)
				}
			}
		}
		.frame(width: 300, height: 300)
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
			ChartDonutView(data: chartData, selectedName: $selectedName)

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
				Text("Tap a segment to select")
					.foregroundStyle(.secondary)
			}
		}
	}
}
