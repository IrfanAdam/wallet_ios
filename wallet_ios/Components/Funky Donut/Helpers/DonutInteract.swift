import SwiftUI

struct ChartSelection {
	static func updateSelection(context: DonutChartContext) {
		guard let rawValue = context.interaction.rawSelectedValue else { return }		
		var cumulative = 0.0
		let selected = context.model.processedData.first { element in
			cumulative += element.sales
			return rawValue <= cumulative
		}
		context.interaction.selectedData = selected
		print("Updates Selection")
	}
}

struct DonutChartCoordinator: ViewModifier {
	@Bindable var main: DonutChartContext

	func body(content: Content) -> some View {
		content
			.task {
				prepare(main)
			}
			.onChange(of: main.interaction.rawSelectedValue) { _, newValue in
				syncSelection(rawValue: newValue)
			}
	}

	private func prepare(_ context: DonutChartContext) {
		context.model.processedData =
		ChartDonutDataProcessor.preprocess(context: context)
		
		context.animation.sliceAngles = context.makeSlices(from: context.model.processedData)
		
		print(context.animation.sliceAngles)
		print(context.model.processedData)
		
		ChartDonutSnapperAnimation.start(context: context)
	}

	private func syncSelection(rawValue: Double?) {
		ChartSelection.updateSelection(context: main)
	}
}
