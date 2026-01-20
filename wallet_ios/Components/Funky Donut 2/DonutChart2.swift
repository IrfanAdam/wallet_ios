import SwiftUI
import Charts

struct ChartDonutView2: View {
	@Bindable var context: DonutChartContext2
	@Binding var selectedData: SalesData?
	let isPseudo: Bool  // ← new

	var body: some View {
		Chart(context.animation.animatedData) { element in
			ChartDonutSector2(element: element, context: context, isPseudo: isPseudo)
		}
		.modifier(DonutChartModifier(context: context, isPseudo: isPseudo))
	}
}
