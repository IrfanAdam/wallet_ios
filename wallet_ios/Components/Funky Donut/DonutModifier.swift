import SwiftUI
import Charts


extension View {
	func donutChartModifiers(context: DonutChartContext) -> some View {
		self
			.chartLayout(rawSelectedValue: context.rawSelectedValue)
			.chartDynamicChange(context: context)
			.chartSpringAnimation(context: context)
	}

	func chartLayout(
		rawSelectedValue: Binding<Double?>
	) -> some View {
		self
			.chartAngleSelection(value: rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 360, height: 360)
			.scaleEffect(x: -1, y: 1)
	}

	func chartDynamicChange(
		context: DonutChartContext
	) -> some View {
		self
			.task(id: context.data.count) {
				context.processedData.wrappedValue =
				ChartDonutDataProcessor.preprocess(context: context)
				ChartDonutSnapperAnimation.start(context: context)
			}
			.onChange(of: context.rawSelectedValue.wrappedValue) {
				ChartSelection.updateSelection(context: context)
			}
	}

	func chartSpringAnimation(
		context: DonutChartContext
	) -> some View {
		self
			.animation(.spring(response: 0.25, dampingFraction: 0.8),
				value: context.rawSelectedValue.wrappedValue
			)
			.animation(.spring(response: 0.42, dampingFraction: 0.6),
				value: context.selectedData.wrappedValue
			)
			.rotationEffect(context.rotationContext.angle)
	}
}

