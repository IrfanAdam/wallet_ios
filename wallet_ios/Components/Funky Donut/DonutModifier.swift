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

struct DonutSelectionInfoView: View {
	@Bindable var mainContext: DonutChartContext
	@Bindable var pseudoContext: DonutChartContext

	var body: some View {
		if let selected = mainContext.interaction.selectedData {
			Text("Sales of: \(selected.name)").font(.headline)
			Button("Clear") {
				withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
					mainContext.interaction.selectedData = nil
					pseudoContext.interaction.selectedData = nil
				}
			}.font(.subheadline).foregroundStyle(.secondary)
		} else {
			Text("Tap a segment").foregroundStyle(.secondary)
		}
	}
}
