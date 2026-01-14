import SwiftUI

// MARK: - Data Model

struct DonutData: Identifiable {
	let id = UUID()
	let name: String
	let sales: Double
	let color: Color
}

// MARK: - Animatable Donut Segment Shape

struct DonutSegmentShape: Shape {

	let startAngle: Angle
	let endAngle: Angle
	let innerRadiusRatio: CGFloat
	var progress: CGFloat   // 0 → 1

	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}

	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let innerRadius = radius * innerRadiusRatio

		let animatedEnd = Angle.degrees(
			startAngle.degrees +
			(endAngle.degrees - startAngle.degrees) * Double(progress)
		)

		var path = Path()
		guard progress > 0 else { return path }

		path.addArc(
			center: center,
			radius: radius,
			startAngle: startAngle,
			endAngle: animatedEnd,
			clockwise: false
		)

		path.addArc(
			center: center,
			radius: innerRadius,
			startAngle: animatedEnd,
			endAngle: startAngle,
			clockwise: true
		)

		path.closeSubpath()
		return path
	}
}

// MARK: - Rounded Segment Helper

extension Shape {
	func roundedStroke(lineWidth: CGFloat) -> some View {
		self.stroke(
			style: StrokeStyle(
				lineWidth: lineWidth,
				lineCap: .round,
				lineJoin: .round
			)
		)
	}
}

// MARK: - Donut Chart View

struct CustomDonutChart: View {

	let data: [DonutData]
	let innerRadiusRatio: CGFloat
	let angularInset: Double
	@Binding var selectedName: String?

	@State private var segmentProgress: [CGFloat] = []

	private var angles: [(start: Angle, end: Angle, data: DonutData)] {
		let total = data.reduce(0) { $0 + $1.sales }
		var start = -90.0
		var result: [(Angle, Angle, DonutData)] = []

		for item in data {
			let sweep = (item.sales / total) * 360
			let end = start + sweep
			result.append((.degrees(start), .degrees(end), item))
			start = end
		}
		return result
	}

	var body: some View {
		GeometryReader { geo in
			let thickness = (1 - innerRadiusRatio) * min(geo.size.width, geo.size.height)

			ZStack {
				ForEach(Array(angles.enumerated()), id: \.element.data.id) { index, arc in
					DonutSegmentShape(
						startAngle: .degrees(arc.start.degrees + angularInset / 2 + 12),
						endAngle: .degrees(arc.end.degrees - angularInset / 2),
						innerRadiusRatio: innerRadiusRatio,
						progress: segmentProgress[safe: index] ?? 0
					)
					.roundedStroke(lineWidth: thickness)
					.foregroundStyle(arc.data.color)
					.onTapGesture {
						selectedName = arc.data.name
					}
				}
			}
			.aspectRatio(1, contentMode: .fit)
			.onAppear {
				startSequentialAnimation()
			}
		}
	}

	// MARK: - Animation Logic

	private func startSequentialAnimation() {
		segmentProgress = Array(repeating: 0, count: angles.count)

		let duration: Double = 0.32

		for index in angles.indices {
			withAnimation(
				.snappy(duration: duration)
				.delay(Double(index) * duration)
			) {
				segmentProgress[index] = 1
			}
		}
	}
}

// MARK: - Safe Indexing

private extension Array {
	subscript(safe index: Int) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

// MARK: - Preview

struct CustomDonutChart_Previews: PreviewProvider {

	@State static var selected: String? = nil

	static let chartData: [DonutData] = [
		.init(name: "A", sales: 20, color: .red),
		.init(name: "B", sales: 15, color: .blue),
		.init(name: "C", sales: 40, color: .green),
		.init(name: "D", sales: 25, color: .orange)
	]

	static var previews: some View {
		CustomDonutChart(
			data: chartData,
			innerRadiusRatio: 0.92,
			angularInset: 0,
			selectedName: $selected
		)
		.frame(width: 300, height: 300)
		.padding()
	}
}
