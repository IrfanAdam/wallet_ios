import SwiftUI


// MARK: - Donut Chart Context
struct DonutChartContext2 {
	let model: Model
	let interaction: Interaction
	let animation: Animation
	let layout: Layout
}

// MARK: - Sub-contexts

extension DonutChartContext2 {
	
	struct Model {
		let observable: DataObs
		let values: ModelVal
	}
	
	struct Interaction {
		let observable: InteractionObs
		let values: InteractionVal
	}
	
	struct Animation {
		let observable: AnimationObs
		let values: AnimationVal
	}
	
	struct Layout {
		let values: LayoutVal
	}
}


// MARK: - Observable Classes
@Observable
final class DataObs {
	var processedData: [SalesData] = []
}
@Observable
final class AnimationObs {
	var animatedData: [SalesData] = []
	var rotationAngle: Angle = .degrees(0) // combined rotation
}
@Observable
final class InteractionObs {
	var rawSelectedValue: Double? = nil
	var selectedData: SalesData? = nil
}

// MARK: - Static Structures
struct ModelVal {
	let data: [SalesData]
	let total: Double
}
struct InteractionVal {
	// Add immutable config for interaction if needed
}
struct AnimationVal {
	// Add immutable animation config if needed
}
struct LayoutVal {
	let isPseudo: Bool
	let geometry: [SalesData]
}
