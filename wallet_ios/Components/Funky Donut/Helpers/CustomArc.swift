import SwiftUI

struct ArcSegment: View {
	@State private var start: CGFloat = 0.0
	@State private var end: CGFloat = 0.2


	@Bindable var context: DonutChartContext
	let opacity: CGFloat
	let offset: CGFloat

	var body: some View {
			if let range = context.selectedTrimRange() {
				Circle()
					.trim(from: range.start + offset, to: range.end - offset)
					.stroke(
						Color.blue.opacity(opacity), // or dynamic color
						style: StrokeStyle(
							lineWidth: 8,
							lineCap: .round
						)
					)
					.rotationEffect(.degrees(-90))
					.animation(.spring(response: 0.36, dampingFraction: 0.7), value: range.start)
			} 
	}
}

