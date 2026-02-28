import SwiftUI
import Charts

struct SpinnerSegments: View {
	let count: Int
	let selectedIndex: Int?
	private let innerRadiusRatio: CGFloat = 0.36

	var body: some View {
		GeometryReader { geo in
			let size = geo.size.width
			let radius = size / 2
			let segmentAngle = 360.0 / Double(count)
			let imageRadius = radius * ((1 + innerRadiusRatio) / 2)

			ZStack {

				// Background glow
				Circle()
					.fill(Color.brandBlue.opacity(0.08))
					.blur(radius: 8)
					.padding(-8)

				// MARK: Chart
				Chart(0..<count, id: \.self) { index in
					let isSelected = index == selectedIndex

					SectorMark(
						angle: .value("Segment", 1),
						innerRadius: .ratio(isSelected ? innerRadiusRatio - 0.04 : innerRadiusRatio),
						outerRadius: .ratio(isSelected ? 1.0 : 0.95),
						angularInset: 2
					)
					.cornerRadius(8)
					.foregroundStyle(
						index.isMultiple(of: 2)
						? Color.brandBlue
						: Color.brandSky
					)
					.opacity(selectedIndex == nil || isSelected ? 1.0 : 0.32)
				}

				// MARK: Images
				ForEach(0..<count, id: \.self) { index in

					let isSelected = index == selectedIndex

					let midAngle = (Double(index) * segmentAngle)
					+ (segmentAngle / 2)
					- 90

					let radians = midAngle * .pi / 180
					let x = cos(radians) * imageRadius
					let y = sin(radians) * imageRadius

					Image(systemName: "star.fill")
						.resizable()
						.scaledToFit()
						.frame(width: (selectedIndex == nil || isSelected ? 28 : 0), height: (selectedIndex == nil || isSelected ? 28 : 0))
						.foregroundStyle(.white)
						.background(
							Circle()
								.fill(Color.brandOrange)
						)
						.scaleEffect(selectedIndex == index ? 1.15 : 1.0)
						.animation(.spring(response: 0.4), value: selectedIndex)
						.offset(x: x, y: y)
				}
			}
		}
	}
}

extension Color {
	static let brandBlue = Color(red: 0/255,   green: 111/255, blue: 235/255) // vivid blue
	static let brandSky  = Color(red: 82/255,  green: 178/255, blue: 255/255) // lighter complementary blue
	static let brandOrange = Color(red: 235/255, green: 124/255, blue: 0/255)
}
