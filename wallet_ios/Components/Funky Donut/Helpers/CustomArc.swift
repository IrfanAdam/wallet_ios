import SwiftUI

struct ArcSegment: View {
	@Bindable var context: DonutChartContext
	let opacity: CGFloat
	let offset: CGFloat
	let maxSpan: CGFloat
	
	private let minSpan: CGFloat = 0.01
	
	@State private var animatedFrom: CGFloat = 0
	@State private var animatedTo: CGFloat = 0
	
	private func normalize(_ degrees: Double) -> CGFloat {
		CGFloat(degrees / 360.0)
	}
	
	private func clampedTrim(start: CGFloat, end: CGFloat) -> (from: CGFloat, to: CGFloat) {
		let rawFrom = start + offset
		let rawTo   = end   - offset
		let span    = rawTo - rawFrom
		
		let mid = (rawFrom + rawTo) / 2
		let clampedSpan = min(max(span, minSpan), maxSpan)
		
		return (
			mid - clampedSpan / 2,
			mid + clampedSpan / 2
		)
	}
	
	var body: some View {
		if let slice = context.selectedSlice() {
			
			let start = normalize(slice.startAngle)
			let end   = normalize(slice.endAngle)
			let trim  = clampedTrim(start: start, end: end)
			
			Circle()
				.trim(from: animatedFrom, to: animatedTo)
				.stroke(
					Color.blue.opacity(opacity),
					style: StrokeStyle(lineWidth: 8, lineCap: .round)
				)
				.rotationEffect(.degrees(-90))
				.onAppear {
					animatedFrom = trim.from
					animatedTo   = trim.to
				}
				.onChange(of: slice.id) { _, _ in
					animatedFrom = trim.from
					animatedTo   = trim.to
				}
				.animation(.spring(response: 0.36, dampingFraction: 0.7), value: animatedFrom)
				.animation(.spring(response: 0.36, dampingFraction: 0.7), value: animatedTo)
		}
	}
}
