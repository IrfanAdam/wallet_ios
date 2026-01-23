import SwiftUI
import Charts

struct DonutChartModifier: ViewModifier {
	@Bindable var context: DonutChartContext

	func body(content: Content) -> some View {
		content
			.chartAngleSelection(value: $context.interaction.rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 360, height: 360)
			.scaleEffect(x: -1, y: 1)
			.animation(.spring(response: 0.42, dampingFraction: 0.6),value: context.interaction.selectedData)
			.rotationEffect(context.animation.rotationAngle)
			.allowsHitTesting(context.layout.isPseudo != true)
	}
}

struct DonutChartCoordinator: ViewModifier {
	@Bindable var main: DonutChartContext
	@Bindable var pseudo: DonutChartContext

	func body(content: Content) -> some View {
		content
			.task {
				prepare(main)
				prepare(pseudo)
			}
			.onChange(of: main.interaction.rawSelectedValue) { _, newValue in
				syncSelection(rawValue: newValue)
			}
	}

	private func prepare(_ context: DonutChartContext) {
		context.model.processedData =
		ChartDonutDataProcessor.preprocess(context: context)
		ChartDonutSnapperAnimation.start(context: context)
	}

	private func syncSelection(rawValue: Double?) {
		pseudo.interaction.rawSelectedValue = rawValue
		ChartSelection.updateSelection(context: main)
		ChartSelection.updateSelection(context: pseudo)
	}
}

