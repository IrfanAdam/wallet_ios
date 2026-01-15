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
	
	var body: some View {
		Chart(animatedData) { element in
			let style = ChartDonutStyle.segmentStyle(
				for: element,
				selectedName: selectedName,
				isPseudo: isPseudo,
				allData: data
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
		.chartAngleSelection(value: $rawSelectedValue)
		.chartLegend(.hidden)
		.frame(width: 300, height: 300)
		.flippedHorizontally()
		.onAppear {
			ChartDonutSnapperAnimation.start(
				data: data,
				animatedData: $animatedData
			)
		}
		.onChange(of: rawSelectedValue) { _, newValue in
			ChartSelection.updateSelection(
				rawValue: newValue,
				data: data,
				selectedName: $selectedName
			)
		}
		.chartSpringAnimation(
			rawSelectedValue: rawSelectedValue,
			selectedName: selectedName
		)
	}
}
