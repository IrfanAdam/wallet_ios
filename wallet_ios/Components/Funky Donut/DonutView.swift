import SwiftUI
import Charts

struct ChartDonutDemoView: View {
	let data: [SalesData]
	let dataMax: Double

	@State private var mainContext: DonutChartContext

	var body: some View {
		GeometryReader { geo in
			let size = min(geo.size.width, geo.size.height)
			let firstHiglight = size * 0.51
			let secondHiglight = size * 0.44
			ZStack {
				ZStack {
					ArcSegment(
						context: mainContext,
						opacity: 0.9,
						offset: 0.02,
						maxSpan: 0.08
					)
					.frame(width: firstHiglight, height: firstHiglight)
					.scaleEffect(x: -1, y: 1)
					.rotationEffect(mainContext.animation.rotationAngle)
					ArcSegment(
						context: mainContext,
						opacity: 0.5,
						offset: 0.03,
						maxSpan: 0.04
					)
					.frame(width: secondHiglight, height: secondHiglight)
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
	init(data: [SalesData], dataMax: Double) {
		self.data = data
		self.dataMax = dataMax
		_mainContext = State(initialValue: .init(data: data, dataMax: dataMax))
	}
}
