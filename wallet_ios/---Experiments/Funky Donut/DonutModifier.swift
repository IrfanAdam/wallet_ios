import SwiftUI
import Charts

extension View {
	func donutChartModifiers(
		rawSelectedValue: Binding<Double?>,
		selectedName: Binding<String?>,
		chartRotation: Binding<Angle>,
		data: [SalesData],
		processedData: Binding<[SalesData]>,
		animatedData: Binding<[SalesData]>
	) -> some View {
		self
			.chartAngleSelection(value: rawSelectedValue)
			.chartLegend(.hidden)
			.frame(width: 300, height: 300)
			.scaleEffect(x: -1, y: 1)
			.rotationEffect(chartRotation.wrappedValue)
			.onAppear {
				processedData.wrappedValue =
				ChartDonutDataProcessor.preprocess(data: data, total: 240)

				ChartDonutSnapperAnimation.start(
					data: processedData.wrappedValue,
					animatedData: animatedData,
					chartRotation: chartRotation
				)
			}
			.onChange(of: rawSelectedValue.wrappedValue) { _, newValue in
				ChartSelection.updateSelection(
					rawValue: newValue,
					data: processedData.wrappedValue,
					selectedName: selectedName
				)
			}
			.chartSpringAnimation(
				rawSelectedValue: rawSelectedValue.wrappedValue,
				selectedName: selectedName.wrappedValue
			)
	}
}
