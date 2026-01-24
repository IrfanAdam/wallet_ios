import SwiftUI

struct ChartSelection {
	static func updateSelection(context: DonutChartContext) {
		guard let rawValue = context.interaction.rawSelectedValue else { return }		
		var cumulative = 0.0
		let selected = context.model.processedData.first { element in
			cumulative += element.sales
			return rawValue <= cumulative
		}
		withAnimation(.spring(response: 0.42, dampingFraction: 0.6)) {
			context.interaction.selectedData = selected
		}
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
