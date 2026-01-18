import SwiftUI
import Charts

struct ChartDonutView: View {
	let data: [SalesData]
	let total: Double
	@Binding var selectedData: SalesData? // <--- change to SalesData
	let isPseudo: Bool
	
	init(
		data: [SalesData],
		total: Double,
		selectedData: Binding<SalesData?>, // <--- change here
		isPseudo: Bool = false
	) {
		self.data = data
		self.total = total
		self._selectedData = selectedData
		self.isPseudo = isPseudo
	}
	
	@State private var animatedData: [SalesData] = []
	@State private var rawSelectedValue: Double?
	@State private var processedData: [SalesData] = []
	@State private var rotationContext = ChartRotationContext()

	
	
	private var context: DonutChartContext {
		DonutChartContext(
			data: data,
			total: total,
			rawSelectedValue: $rawSelectedValue,
			selectedData: $selectedData,
			processedData: $processedData,
			animatedData: $animatedData,
			rotationContext: rotationContext,
			isPseudo: isPseudo
		)
	}
	
	var body: some View {
		Chart(animatedData) { element in
			ChartDonutSector(element: element, context: context)
		}
		.donutChartModifiers(context: context)
	}
}
