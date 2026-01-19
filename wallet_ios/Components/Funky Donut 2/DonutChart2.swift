import SwiftUI
import Charts

struct ChartDonutView2: View {
	let data: [SalesData]
	let total: Double
	let isPseudo: Bool

	@State private var context: DonutChartContext2

	@Binding var selectedData: SalesData? // <--- change to SalesData

	var body: some View {
		Chart(context.animation.animatedData) { element in
			ChartDonutSector2(element: element, context: context)
		}
		.modifier(DonutChartModifier(context: context))
	}
}

extension ChartDonutView2 {
	init(
		data: [SalesData],
		total: Double,
		isPseudo: Bool = false,
		selectedData: Binding<SalesData?>
	) {
		self.data = data
		self.total = total
		self.isPseudo = isPseudo
		self._selectedData = selectedData

		self._context = State(
			initialValue: DonutChartContext2(
				data: data,
				total: total,
				isPseudo: isPseudo
			)
		)
	}
}
