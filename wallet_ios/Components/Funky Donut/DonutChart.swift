import SwiftUI
import Charts

struct ChartDonutView: View {
	@Bindable var context: DonutChartContext
	var body: some View {
		Chart(context.animation.animatedData) { element in
			let style = context.segmentStyle(for: element)
			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(style.innerRadius),
				outerRadius: .ratio(style.outerRadius),
				angularInset: style.inset
			)
			.foregroundStyle(style.color)
			.cornerRadius(style.cornerRadius)
		}
		.modifier(DonutChartModifier(context: context))
	}
}
