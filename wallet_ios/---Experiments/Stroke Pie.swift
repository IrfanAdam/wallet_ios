import SwiftUI

struct DonutSegmentNew: Identifiable {
	let id = UUID()
	let value: Double
	let color: Color
}

struct RoundedArc: Shape {
	let startAngle: Angle
	let endAngle: Angle

	func path(in rect: CGRect) -> Path {
		var p = Path()
		p.addArc(
			center: CGPoint(x: rect.midX, y: rect.midY),
			radius: min(rect.width, rect.height) / 2,
			startAngle: startAngle,
			endAngle: endAngle,
			clockwise: false
		)
		return p
	}
}

struct RoundedDonutChart: View {

	let segments: [DonutSegmentNew]
	let lineWidth: CGFloat
	let gap: Double      // degrees between arcs
	@State private var animateProgress: [Bool] = []
	@State private var selectedIndex: Int? = nil

	private var angles: [(start: Angle, end: Angle, color: Color)] {
		let total = segments.reduce(0) { $0 + $1.value }
		var start = -90.0
		var arr: [(Angle, Angle, Color)] = []

		for seg in segments {
			let sweep = (seg.value / total) * 360
			let end = start + sweep
			arr.append((.degrees(start), .degrees(end), seg.color))
			start = end
		}
		return arr
	}

	var body: some View {
		ZStack {
			ForEach(Array(angles.enumerated()), id: \.offset) { index, arc in
				// Overlay border if selected
				if selectedIndex == index {
					RoundedArc(
						startAngle: .degrees(arc.start.degrees + gap/2),
						endAngle: .degrees(arc.end.degrees - gap/2)
					)
					.stroke(
						Color.black, // border color
						style: StrokeStyle(
							lineWidth: lineWidth * 1.2, // slightly thicker
							lineCap: .round,
							lineJoin: .round
						)
					)
				}

				RoundedArc(
					startAngle: .degrees(arc.start.degrees + gap/2),
					endAngle: .degrees(arc.end.degrees - gap/2)
				)
				.trim(from: 0, to: animateProgress.indices.contains(index) && animateProgress[index] ? 1 : 0)
				.stroke(
					arc.color,
					style: StrokeStyle(
						lineWidth: lineWidth,
						lineCap: .round,
						lineJoin: .round
					)
				)
				.onTapGesture {
					selectedIndex = (selectedIndex == index) ? nil : index
				}
				.animation(.easeOut(duration: 0.2).delay(Double(index) * 0.1), value: animateProgress)


			}
		}
		.onAppear {
			// initialize progress array
			animateProgress = Array(repeating: false, count: segments.count)

			// animate each segment sequentially
			for i in segments.indices {
				DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
					animateProgress[i] = true
				}
			}
		}
	}
}

struct RoundedDonutChart_Preview: PreviewProvider {
	static let data: [DonutSegmentNew] = [
		.init(value: 20, color: .mint),
		.init(value: 15, color: .purple),
		.init(value: 40, color: .pink),
		.init(value: 25, color: Color.gray.opacity(0.3))
	]

	static var previews: some View {
		RoundedDonutChart(
			segments: data,
			lineWidth: 20,
			gap: 10
		)
		.frame(width: 260, height: 260)
		.padding()
	}
}
