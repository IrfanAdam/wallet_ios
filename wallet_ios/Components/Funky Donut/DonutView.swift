import SwiftUI
import Charts

struct ChartDonutDemoView: View {
	let data: [SalesData]
	let dataMax: Double

	@State private var pseudoContext: DonutChartContext
	@State private var mainContext: DonutChartContext

	var body: some View {
		GeometryReader { geo in
			let size = min(geo.size.width, geo.size.height)
			let firstHiglight = size * 0.54
			let secondHiglight = size * 0.47
			ZStack {
				ZStack {
					ArcSegment(
						context: mainContext,
						opacity: 0.9,
						offset: 0.02
					)
					.frame(width: firstHiglight, height: firstHiglight)
					.scaleEffect(x: -1, y: 1)
					.rotationEffect(mainContext.animation.rotationAngle)
					ArcSegment(
						context: mainContext,
						opacity: 0.5,
						offset: 0.03
					)
					.frame(width: secondHiglight, height: secondHiglight)
					.scaleEffect(x: -1, y: 1)
					.rotationEffect(mainContext.animation.rotationAngle)
					ChartDonutView(context: mainContext)
				}
				.modifier(
					DonutChartCoordinator(
						main: mainContext,
						pseudo: pseudoContext
					)
				)
				VStack(spacing: 8) {
					DonutSelectionInfoView(
						mainContext: mainContext,
						pseudoContext: pseudoContext
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
		_pseudoContext = State(initialValue: .init(data: data, dataMax: dataMax, isPseudo: true))
		_mainContext = State(initialValue: .init(data: data, dataMax: dataMax, isPseudo: false))
	}
}
