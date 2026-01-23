import SwiftUI
import Charts

struct ChartDonutView2: View {
	@Bindable var context: DonutChartContext2
	var body: some View {
		Chart(context.animation.animatedData) { element in
			ChartDonutSector2(element: element, context: context)
		}
		.modifier(DonutChartModifier(context: context))
	}
}
