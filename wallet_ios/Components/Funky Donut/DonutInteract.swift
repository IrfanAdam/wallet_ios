import SwiftUI

struct ChartSelection {
	static func updateSelection(context: DonutChartContext) {
		guard let rawValue = context.rawSelectedValue.wrappedValue else { return }
		
		let selected = findSelectedData(for: rawValue, in: context.processedData.wrappedValue)
		context.selectedData.wrappedValue = selected
	}
	
	private static func findSelectedData(for value: Double, in data: [SalesData]) -> SalesData? {
		var cumulativeTotal: Double = 0
		
		for element in data {
			cumulativeTotal += element.sales
			if value <= cumulativeTotal {
				return element
			}
		}
		return nil
	}
}
