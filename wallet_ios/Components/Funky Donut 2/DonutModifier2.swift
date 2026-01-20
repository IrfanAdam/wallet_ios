import SwiftUI
import Charts

struct DonutChartModifier: ViewModifier {
	@Bindable var context: DonutChartContext2
	@State private var selectionToken = UUID()


	func body(content: Content) -> some View {
		content
			.chartAngleSelection(value: $context.interaction.rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 360, height: 360)
			.scaleEffect(x: -1, y: 1)
			.task(id: context.model.processedData.count) {
				context.model.processedData = ChartDonutDataProcessor2.preprocess(context: context)
				ChartDonutSnapperAnimation2.start(context: context)
			}
//			.onChange(of: context.interaction.rawSelectedValue) {
//				ChartSelection2.updateSelection(context: context)
//			}
			.onChange(of: context.interaction.rawSelectedValue) { _, _ in
				let token = UUID()
				selectionToken = token

				Task {
					try? await Task.sleep(for: .milliseconds(140))

					// debounce nullification
					guard selectionToken == token else { return }

					await MainActor.run {
						withAnimation(.spring(response: 0.42, dampingFraction: 0.6)) {
							ChartSelection2.updateSelection(context: context)
						}
					}
				}
			}
//			.animation(.spring(response: 0.25, dampingFraction: 0.8),value: context.interaction.rawSelectedValue)
			.animation(.spring(response: 0.42, dampingFraction: 0.6),value: context.interaction.selectedData)
			.rotationEffect(context.animation.rotationAngle)
	}
}
