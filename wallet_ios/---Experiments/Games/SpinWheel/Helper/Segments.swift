import SwiftUI
import Charts

struct SpinnerSegments: View {
	let count: Int
	let selectedIndex: Int?
	private let innerRadiusRatio: CGFloat = 0.36
	
	private var segments: [(index: Int, value: Double)] {
		(0..<count).map { (index: $0, value: 1.0) }
	}
	
	var body: some View {
		ZStack {
			// Subtle background circle
			Circle()
				.fill(Color.brandBlue.opacity(0.08))
				.blur(radius: 8)
				.padding(-8)
			
			Chart(segments, id: \.index) { segment in
				let isSelected = segment.index == selectedIndex
				SectorMark(
					angle: .value("Segment", segment.value),
					innerRadius: .ratio(isSelected ? innerRadiusRatio - 0.04 : innerRadiusRatio),
					outerRadius: .ratio(isSelected ? 1.0 : 0.95),
					angularInset: 2
				)
				.cornerRadius(10)
				.foregroundStyle(
					segment.index.isMultiple(of: 2) ? Color.brandBlue : Color.brandSky
				)
				.opacity(selectedIndex == nil || isSelected ? 1.0 : 0.45)
			}
			.shadow(
				color: selectedIndex != nil ? .white.opacity(0.6) : .clear,
				radius: 12
			)
		}
	}
}

extension Color {
	static let brandBlue = Color(red: 0/255,   green: 111/255, blue: 235/255) // vivid blue
	static let brandSky  = Color(red: 82/255,  green: 178/255, blue: 255/255) // lighter complementary blue
	static let brandOrange = Color(red: 235/255, green: 124/255, blue: 0/255)
}
