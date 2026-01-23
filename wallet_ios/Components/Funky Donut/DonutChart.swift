import SwiftUI
import Charts

struct ChartDonutView: View {
	@Bindable var context: DonutChartContext
	var body: some View {
		Chart(context.animation.animatedData) { element in
			ChartDonutSector(element: element, context: context)
		}
		.modifier(DonutChartModifier(context: context))
	}
}
