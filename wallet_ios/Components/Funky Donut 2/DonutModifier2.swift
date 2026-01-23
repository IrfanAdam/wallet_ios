import SwiftUI
import Charts

struct DonutChartModifier: ViewModifier {
	@Bindable var context: DonutChartContext2
//	@State private var selectionToken = UUID()

	func body(content: Content) -> some View {
		content
			.chartAngleSelection(value: $context.interaction.rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 360, height: 360)
			.scaleEffect(x: -1, y: 1)
//			.animation(.spring(response: 0.25, dampingFraction: 0.8),value: context.interaction.rawSelectedValue)
			.animation(.spring(response: 0.42, dampingFraction: 0.6),value: context.interaction.selectedData)
			.rotationEffect(context.animation.rotationAngle)
			.allowsHitTesting(context.layout.isPseudo != true)
	}
}


struct DonutChartCoordinator: ViewModifier {
	@Bindable var main: DonutChartContext2
	@Bindable var pseudo: DonutChartContext2

	func body(content: Content) -> some View {
		content
			.task {
				prepare(main)
				prepare(pseudo)
			}
			.onChange(of: main.interaction.rawSelectedValue) { _, newValue in
				syncSelection(rawValue: newValue)
			}
		//			.onChange(of: context.interaction.rawSelectedValue) { _, _ in
		//				let token = UUID()
		//				selectionToken = token
		//
		//				Task {
		//					try? await Task.sleep(for: .milliseconds(40))
		//
		//					// debounce nullification
		//					guard selectionToken == token else { return }
		//
		//					await MainActor.run {
		//						withAnimation(.spring(response: 0.42, dampingFraction: 0.6)) {
		//							ChartSelection2.updateSelection(context: context)
		//						}
		//					}
		//				}
		//			}
	}

	private func prepare(_ context: DonutChartContext2) {
		context.model.processedData =
		ChartDonutDataProcessor2.preprocess(context: context)

		ChartDonutSnapperAnimation2.start(context: context)
	}

	private func syncSelection(rawValue: Double?) {
		pseudo.interaction.rawSelectedValue = rawValue
		ChartSelection2.updateSelection(context: main)
		ChartSelection2.updateSelection(context: pseudo)
	}
}

