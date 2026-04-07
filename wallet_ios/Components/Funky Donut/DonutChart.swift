import SwiftUI
import Charts

struct ChartDonutView: View {
	@Bindable var context: DonutChartContext
	var body: some View {
		Chart(context.animation.animatedData) { element in
			let style = context.sectorStyle(for: element)
			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(style.innerRadius),
				outerRadius: .ratio(style.outerRadius),
				angularInset: style.inset
			)
			.foregroundStyle(style.color)
			.cornerRadius(style.cornerRadius)
			.shadow(
				color: style.borderColor,
				radius: 0,
				x: 0,
				y: -1
			)
			.shadow(
				color: style.borderColor,
				radius: 0,
				x: -1,
				y: 0
			)
			.shadow(
				color: style.borderColor,
				radius: 0,
				x: 0,
				y: 1
			)
			.shadow(
				color: style.borderColor,
				radius: 0,
				x: 1,
				y: 0
			)
		}
		.modifier(DonutChartModifier(context: context))
	}
}
