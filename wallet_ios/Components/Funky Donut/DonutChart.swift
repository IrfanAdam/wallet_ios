import SwiftUI
import Charts

struct ChartDonutView: View {
	let data: [SalesData]
	@Binding var selectedName: String?
	let isPseudo: Bool

	init(
		data: [SalesData],
		selectedName: Binding<String?>,
		isPseudo: Bool = false
	) {
		self.data = data
		self._selectedName = selectedName
		self.isPseudo = isPseudo
	}
	
	@State private var animatedData: [SalesData] = []
	@State private var rawSelectedValue: Double?
	@State private var processedData: [SalesData] = []
	@State private var chartRotation: Angle = .degrees(0)

	private var context: DonutChartContext {
		DonutChartContext(
			data: data,
			rawSelectedValue: $rawSelectedValue,
			selectedName: $selectedName,
			chartRotation: $chartRotation,
			processedData: $processedData,
			animatedData: $animatedData
		)
	}

	var body: some View {
		Chart(animatedData) { element in
			ChartDonutSector(
				element: element,
				selectedName: selectedName,
				isPseudo: isPseudo,
				allData: processedData
			)
		}
		.donutChartModifiers(context: context)
	}
}

