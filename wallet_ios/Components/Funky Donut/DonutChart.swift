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

	var body: some View {
		Chart(animatedData) { element in
			let style = ChartDonutStyle.segmentStyle(
				for: element,
				selectedName: selectedName,
				isPseudo: isPseudo,
				allData: processedData
			)
			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(style.innerRadius),
				outerRadius: .ratio(style.outerRadius),
				angularInset: style.inset
			)
			.foregroundStyle(style.color)
			.cornerRadius(style.cornerRadius)
		}
		.donutChartModifiers(
			rawSelectedValue: $rawSelectedValue,
			selectedName: $selectedName,
			chartRotation: $chartRotation,
			data: data,
			processedData: $processedData,
			animatedData: $animatedData
		)
	}
}

