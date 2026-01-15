import SwiftUI

// MARK: - Data Model
struct SalesData: Identifiable {
	let id: UUID
	let name: String
	let sales: Double
	
	init(id: UUID = UUID(), name: String, sales: Double) {
		self.id = id
		self.name = name
		self.sales = sales
	}
}


struct ChartColors {
	static func color(for element: SalesData, in data: [SalesData]) -> Color {
		guard let index = data.firstIndex(where: { $0.id == element.id }) else {
			return .clear
		}
		
		if index == 0 {
			return Color(hue: 0.58, saturation: 0.08, brightness: 0.85)
		}
		
		let segmentCount = max(data.count - 1, 1)
		let progress = segmentCount > 1 ? Double(index - 1) / Double(segmentCount - 1) : 0
		let minBrightness = 0.35
		let maxBrightness = 0.85
		let brightness = maxBrightness - progress * (maxBrightness - minBrightness)
		
		return Color(hue: 0.58, saturation: 0.75, brightness: brightness)
	}
}
