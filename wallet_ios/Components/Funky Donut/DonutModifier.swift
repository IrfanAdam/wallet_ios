import SwiftUI
import Charts

struct DonutChartModifier: ViewModifier {
	@Bindable var context: DonutChartContext
	func body(content: Content) -> some View {
		content
			.chartAngleSelection(value: $context.interaction.rawSelectedValue)
			.chartLegend(.hidden)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.scaleEffect(x: -1, y: 1)
			.rotationEffect(context.animation.rotationAngle)
			.allowsHitTesting(context.layout.isPseudo != true)
	}
}
