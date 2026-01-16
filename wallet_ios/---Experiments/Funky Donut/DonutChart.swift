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
	@State private var processedData: [SalesData] = [] // ✅ store sorted + remainder
	@State private var chartRotation: Angle = .degrees(-90)
	
	var body: some View {
		Chart(animatedData) { element in
			let style = ChartDonutStyle.segmentStyle(
				for: element,
				selectedName: selectedName,
				isPseudo: isPseudo,
				allData: processedData // ✅ use processedData for styles
			)
			
			SectorMark(
				angle: .value("Sales", element.sales),
				innerRadius: .ratio(style.innerRadius),
				outerRadius: .ratio(style.outerRadius),
				angularInset: style.inset
			)
			.foregroundStyle(
				element.name == "Remaining" ? Color.gray.opacity(0.2) : style.color
			)
			.cornerRadius(style.cornerRadius)
		}
		.chartAngleSelection(value: $rawSelectedValue)
		.chartLegend(.hidden)
		.frame(width: 300, height: 300)
		.scaleEffect(x: -1, y: 1)
		.rotationEffect(chartRotation)
		.onAppear {
			// 1️⃣ Preprocess data: sort descending + append remainder
			processedData = preprocessData(data: data, total: 240)
			
			// 2️⃣ Start animation using processedData
			ChartDonutSnapperAnimation.start(
				data: processedData,
				animatedData: $animatedData,
				chartRotation: $chartRotation
			)
		}
		.onChange(of: rawSelectedValue) { _, newValue in
			ChartSelection.updateSelection(
				rawValue: newValue,
				data: processedData, // ✅ use processedData for selection
				selectedName: $selectedName
			)
		}
		.chartSpringAnimation(
			rawSelectedValue: rawSelectedValue,
			selectedName: selectedName
		)
	}
	
	// MARK: - Helper: sort and add remainder
	private func preprocessData(data: [SalesData], total: Double) -> [SalesData] {
		let sum = data.reduce(0) { $0 + $1.sales }
		let remainder = max(total - sum, 0)
		
		// 1️⃣ Sort original data descending
		var sortedData = data.sorted { $0.sales < $1.sales }
		
		// 2️⃣ Append remainder at start or end (here at end)
		if remainder > 0 {
			sortedData.append(SalesData(name: "Remaining", sales: remainder))
		}
		
		return sortedData
	}
}

