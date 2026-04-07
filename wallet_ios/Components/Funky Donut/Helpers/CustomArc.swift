import SwiftUI

struct ArcSegment: View {
	@State private var trimFrom: CGFloat = 0.0
	@State private var trimTo:   CGFloat = 0.2

	@Bindable var context: DonutChartContext
	let opacity: CGFloat
	let offset:  CGFloat
	let maxSpan:  CGFloat

	private let minSpan: CGFloat = 0.01

	// Pure function — no side effects, easy to test
	private func clampedTrim(start: CGFloat, end: CGFloat) -> (from: CGFloat, to: CGFloat) {
		let rawFrom = start + offset
		let rawTo   = end   - offset
		let span    = rawTo - rawFrom

		let mid = (rawFrom + rawTo) / 2

		// Clamp span between minSpan and maxSpan
		let clampedSpan = min(max(span, minSpan), maxSpan)

		return (
			mid - clampedSpan / 2,
			mid + clampedSpan / 2
		)
	}

	private func applyTrim(start: CGFloat, end: CGFloat) {
		let result = clampedTrim(start: start, end: end)
		trimFrom = result.from
		trimTo   = result.to
	}

	var body: some View {
		if let range = context.selectedTrimRange() {
			Circle()
				.trim(from: trimFrom, to: trimTo)
				.stroke(
					Color.blue.opacity(opacity),
					style: StrokeStyle(lineWidth: 8, lineCap: .round)
				)
				.rotationEffect(.degrees(-90))
			// Animate both handles independently
				.animation(.spring(response: 0.36, dampingFraction: 0.7), value: trimFrom)
				.animation(.spring(response: 0.36, dampingFraction: 0.7), value: trimTo)
				.onAppear {
					applyTrim(start: range.start, end: range.end)
				}
				.onChange(of: range.start) { applyTrim(start: range.start, end: range.end) }
				.onChange(of: range.end)   { applyTrim(start: range.start, end: range.end) }
		}
	}
}
