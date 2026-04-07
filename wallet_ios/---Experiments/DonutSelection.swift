import SwiftUI
import Charts

struct DonutDemoView: View {
	let data: [(label: String, value: Double, color: Color)] = [
		("Rent",      35, .indigo),
		("Food",      20, .orange),
		("Transport", 15, .teal),
		("Health",    10, .pink),
		("Savings",   20, .green),
	]

	@State private var selectedAngle: Double? = nil
	@State private var lockedAngle: Double? = nil

	var selectedLabel: String? {
		guard let angle = lockedAngle else { return nil }

		var cumulative = 0.0
		for item in data {
			cumulative += item.value
			if angle <= cumulative {
				return item.label
			}
		}
		return nil
	}

	var body: some View {
		ZStack {
			// ── 1. Border (perfectly aligned shell) ──
			Chart(data, id: \.label) { item in
				SectorMark(
					angle:        .value("Value", item.value),
					innerRadius:  .ratio(0.52 - 0.03),  // expand inward
					outerRadius:  .ratio(0.90 + 0.02),  // expand outward
					angularInset: 0.2                     // EXACT SAME
				)
				.foregroundStyle(
					item.label == selectedLabel ? Color.black : Color.clear
				)
				.cornerRadius(10) // EXACT SAME
			}
			.drawingGroup()

			// ── 2. Fill ──
			Chart(data, id: \.label) { item in
				SectorMark(
					angle:        .value("Value", item.value),
					innerRadius:  .ratio(0.52),
					outerRadius:  .ratio(0.90),
					angularInset: 2.8
				)
				.foregroundStyle(item.color)
				.cornerRadius(8)
			}
			.chartAngleSelection(value: $selectedAngle)
			.onChange(of: selectedAngle) { _, newValue in
				if let newValue {
					lockedAngle = newValue
				}
			}
		}
		.frame(width: 260, height: 260)
		.padding()
	}
}

#Preview {
	DonutDemoView()
}
