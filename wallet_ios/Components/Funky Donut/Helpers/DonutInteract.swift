import SwiftUI

struct ChartSelection {
	static func updateSelection(context: DonutChartContext) {
		guard let rawValue = context.interaction.rawSelectedValue else { return }

		let selected = findSelectedData(for: rawValue, in: context.model.processedData)
		withAnimation(Animation.spring(response: 0.42, dampingFraction: 0.6)) {
			context.interaction.selectedData = selected
		}
	}

	private static func findSelectedData(for value: Double, in data: [SalesData]) -> SalesData? {
		var cumulativeTotal: Double = 0

		for element in data {
			cumulativeTotal += element.sales
			if value <= cumulativeTotal {
				return element
			}
		}
		return nil
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
