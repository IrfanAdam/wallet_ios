import SwiftUI

struct ChartDonutSnapperAnimation2 {

	static func start(context: DonutChartContext2) {
		context.animation.animatedData = context.model.processedData.map {
			SalesData(id: $0.id, name: $0.name, sales: .ulpOfOne)
		}
		context.animation.rotationAngle = .degrees(0)
		animateSegment(at: context.model.processedData.count - 1, context: context)
	}

	private static func animateSegment(at index: Int, context: DonutChartContext2) {
		guard index >= 0 else { return }

		let segmentAnimation = Animation.spring(response: 0.36, dampingFraction: 0.6)
		let delay: TimeInterval = 0.24

		withAnimation(segmentAnimation) {
			context.animation.animatedData[index] = context.model.processedData[index]
		}
		animateRotation(at: index, context: context)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			animateSegment(at: index - 1, context: context)
		}
	}

	private static func animateRotation(at index: Int, context: DonutChartContext2) {
		let total = context.model.processedData.reduce(0) { $0 + $1.sales }
		let segmentAngle = (context.model.processedData[index].sales / total) * 360
		let rotationAnimation = Animation.spring(response: 0.32, dampingFraction: 0.8)
		let snapAnimation = Animation.spring(response: 0.42, dampingFraction: 0.6)
		let delay: TimeInterval = 0.24

		withAnimation(rotationAnimation) {
			context.animation.rotationAngle += .degrees(segmentAngle) // <- use original context
		}

		if index == context.model.processedData.count - 1 {
			let cumulative = context.model.processedData
				.prefix(index + 1)
				.filter { $0.name != "Remaining" }
				.reduce(0) { $0 + $1.sales }
			let cumulativeAngle = (cumulative / total) * 360

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(snapAnimation) {
					context.animation.rotationAngle += .degrees(cumulativeAngle) // <- again, original context
				}
			}
		}
	}
}
