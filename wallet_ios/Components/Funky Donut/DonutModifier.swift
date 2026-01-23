import SwiftUI
import Charts

struct DonutChartModifier: ViewModifier {
	@Bindable var context: DonutChartContext
	func body(content: Content) -> some View {
		content
			.chartAngleSelection(value: $context.interaction.rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 360, height: 360)
			.scaleEffect(x: -1, y: 1)
			.rotationEffect(context.animation.rotationAngle)
			.allowsHitTesting(context.layout.isPseudo != true)
	}
}

struct DonutSelectionInfoView: View {
	@Bindable var mainContext: DonutChartContext
	@Bindable var pseudoContext: DonutChartContext

	var body: some View {
		VStack(spacing: 8) {
			if let selected = mainContext.interaction.selectedData {
				Text("Sales of: \(selected.name)").font(.headline)
				Button("Clear") { withAnimation {
					mainContext.interaction.selectedData = nil
					pseudoContext.interaction.selectedData = nil
				} }.font(.subheadline).foregroundStyle(.secondary)
			} else {
				Text("Tap a segment").foregroundStyle(.secondary)
			}
		}
	}
}
