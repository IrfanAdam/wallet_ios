import SwiftUI

// Your data model
struct DonutData: Identifiable {
	let id = UUID()
	let name: String
	let sales: Double
	let color: Color
}

// Custom arc shape with inner radius
struct DonutSegmentShape: Shape {
	let startAngle: Angle
	let endAngle: Angle
	let innerRadiusRatio: CGFloat

	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let innerRadius = radius * innerRadiusRatio

		var path = Path()

		path.addArc(center: center,
								radius: radius,
								startAngle: startAngle,
								endAngle: endAngle,
								clockwise: false)

		path.addArc(center: center,
								radius: innerRadius,
								startAngle: endAngle,
								endAngle: startAngle,
								clockwise: true)

		path.closeSubpath()
		return path
	}
}

struct CustomDonutChart: View {
	let data: [DonutData]
	let innerRadiusRatio: CGFloat
	let angularInset: Double
	@Binding var selectedName: String?

	private var angles: [(start: Angle, end: Angle, data: DonutData)] {
		let total = data.reduce(0) { $0 + $1.sales }
		var start = -90.0
		var arr: [(Angle, Angle, DonutData)] = []

		for element in data {
			let sweep = (element.sales / total) * 360
			let end = start + sweep
			arr.append((.degrees(start), .degrees(end), element))
			start = end
		}
		return arr
	}

	var body: some View {
		ZStack {
			ForEach(angles, id: \.data.id) { arc in
				DonutSegmentShape(
					startAngle: .degrees(arc.start.degrees + angularInset/2),
					endAngle: .degrees(arc.end.degrees - angularInset/2),
					innerRadiusRatio: innerRadiusRatio
				)
				.fill(arc.data.color)
				.onTapGesture {
					selectedName = arc.data.name
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
	}
}

// Preview Example
struct CustomDonutChart_Previews: PreviewProvider {
	@State static var selected: String? = "B"

	static let chartData: [DonutData] = [
		.init(name: "A", sales: 20, color: .red),
		.init(name: "B", sales: 15, color: .blue),
		.init(name: "C", sales: 40, color: .green),
		.init(name: "D", sales: 25, color: .orange)
	]

	static var previews: some View {
		CustomDonutChart(
			data: chartData,
			innerRadiusRatio: 0.8,
			angularInset: 1.5,
			selectedName: $selected
		)
		.frame(width: 300, height: 300)
		.padding()
	}
}
