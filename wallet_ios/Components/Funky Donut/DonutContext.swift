import SwiftUI

struct DonutChartContext {
	let data: [SalesData]   /*provided data*/
	let total: Double /*provide total*/
	let rawSelectedValue: Binding<Double?> /*fetching selected value from chart*/
	let selectedData: Binding<SalesData?> /*storing selected element*/
	let processedData: Binding<[SalesData]> /*sorting and peocessing for visualisation*/
	let animatedData: Binding<[SalesData]> /*data being passed to chart for controlling animation*/
	let rotationContext: ChartRotationContext /*used to control chart angle so the arcs begin from top*/
	let isPseudo: Bool /*chart config given so i can have pseudo chart elements for displaying selected states*/
}

@Observable
final class ChartRotationContext: Equatable {
	var angle: Angle = .degrees(0)
	
	static func == (lhs: ChartRotationContext, rhs: ChartRotationContext) -> Bool {
		lhs.angle == rhs.angle
	}
}
