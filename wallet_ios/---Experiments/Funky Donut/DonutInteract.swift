import SwiftUI

struct ChartSelection {
	
	static func updateSelection(
		rawValue: Double?,
		data: [SalesData],
		selectedName: Binding<String?>
	) {
		guard let rawValue else { return }
		
		selectedName.wrappedValue = findSelectedName(
			for: rawValue,
			in: data
		)
	}
	
	static func findSelectedName(
		for value: Double,
		in data: [SalesData]
	) -> String? {
		var cumulativeTotal: Double = 0
		
		for element in data {
			cumulativeTotal += element.sales
			if value <= cumulativeTotal {
				return element.name
			}
		}
		return nil
	}
}
