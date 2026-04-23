import SwiftUI
import Charts

struct ChartDonutDemoView: View {
	let data: [DonutData]
	let dataMax: Double

	@State private var mainContext: DonutChartContext

	var body: some View {
		GeometryReader { geo in
			let size = min(geo.size.width, geo.size.height)
			let innerSpace = mainContext.layout.fillSpace - mainContext.layout.donutWidth * 2
			let arcWidth = mainContext.layout.arcWidth
			let base = size * innerSpace
			let w = arcWidth

			let firstHighlight = base - (1.5 * w)
			let secondHighlight = firstHighlight - (3.5 * w)

			ZStack {
				ZStack {
					ArcSegment(
						context: mainContext,
						opacity: 0.9,
						offset: 0.02,
						maxSpan: 0.08
					)
					.frame(width: firstHighlight, height: firstHighlight)
					.scaleEffect(x: -1, y: 1)
					.rotationEffect(mainContext.animation.rotationAngle)
					ArcSegment(
						context: mainContext,
						opacity: 0.5,
						offset: 0.03,
						maxSpan: 0.04
					)
					.frame(width: secondHighlight, height: secondHighlight)
					.scaleEffect(x: -1, y: 1)
					.rotationEffect(mainContext.animation.rotationAngle)
					ChartDonutView(context: mainContext)
				}
				.modifier(
					DonutChartCoordinator(
						main: mainContext
					)
				)
				VStack(spacing: 8) {
					DonutSelectionInfoView(
						mainContext: mainContext,
					)
				}
			}
		}
	}
}

extension ChartDonutDemoView {
	init(data: [DonutData], dataMax: Double) {
		self.data = data
		self.dataMax = dataMax
		_mainContext = State(initialValue: .init(data: data, dataMax: dataMax))
	}
}
