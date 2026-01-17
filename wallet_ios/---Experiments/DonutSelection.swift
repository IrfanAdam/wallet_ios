import SwiftUI
import Charts

struct SimpleDonutSelectionView: View {
	
	// MARK: - Models
	
	struct Item: Identifiable {
		let id = UUID()
		let name: String
		let value: Double
	}
	
	struct DonutSelection {
		let item: Item
		let rawValue: Double
		let percentage: Double
	}
	
	// MARK: - Data
	
	let data: [Item] = [
		.init(name: "A", value: 20),
		.init(name: "B", value: 15),
		.init(name: "C", value: 10),
		.init(name: "D", value: 60)
	]
	
	private var total: Double {
		data.reduce(0) { $0 + $1.value }
	}
	
	// MARK: - State
	
	@State private var rawSelectedValue: Double?
	@State private var selection: DonutSelection?
	
	// MARK: - View
	
	var body: some View {
		VStack(spacing: 16) {
			
			Chart(data) { item in
				SectorMark(
					angle: .value("Value", item.value),
					innerRadius: .ratio(0.6)
				)
				.foregroundStyle(by: .value("Category", item.name))
			}
			.chartAngleSelection(value: $rawSelectedValue)
			.frame(width: 240, height: 240)
			.onChange(of: rawSelectedValue) { _, newValue in
				guard let newValue else { return }
				
				var cumulative: Double = 0
				
				for item in data {
					cumulative += item.value
					if newValue <= cumulative {
						selection = DonutSelection(
							item: item,
							rawValue: newValue,
							percentage: newValue / total
						)
						break
					}
				}
			}
			
			// MARK: - Stored Selection Display
			
			if let selection {
				VStack(spacing: 6) {
					Text("Name: \(selection.item.name)")
					Text("Raw angle value: \(selection.rawValue, specifier: "%.2f")")
					Text("Percentage: \(selection.percentage * 100, specifier: "%.1f")%")
				}
				.font(.headline)
			} else {
				Text("Tap a segment")
					.foregroundStyle(.secondary)
			}
		}
	}
}

#Preview {
	SimpleDonutSelectionView()
}
