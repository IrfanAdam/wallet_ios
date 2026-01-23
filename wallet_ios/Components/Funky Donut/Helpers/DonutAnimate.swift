import SwiftUI

struct ChartDonutSnapperAnimation {

	static func start(context: DonutChartContext) {
		let procsData = context.model.processedData
		let totalSales = context.model.data.reduce(0.0) { $0 + $1.sales }
		let totalAngle = (totalSales / context.model.total) * 360
		context.animation.animatedData = procsData.map {
			SalesData(id: $0.id, name: $0.name, sales: .ulpOfOne)
		}
		context.animation.rotationAngle = .degrees(0)
		animateSegment(at: procsData.count - 1, context: context, totalAngle: totalAngle)
	}
}

private extension ChartDonutSnapperAnimation {
	static func animateSegment(at index: Int, context: DonutChartContext, totalAngle: Double) {
		guard index >= 0 else { return }
		let data = context.model.processedData
		withAnimation(segmentAnimation) {
			context.animation.animatedData[index] = data[index]
		}
		animateRotation(at: index, context: context, totalAngle: totalAngle)
		DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay) {
			animateSegment(at: index - 1, context: context, totalAngle: totalAngle)
		}
	}

	static func animateRotation(at index: Int, context: DonutChartContext, totalAngle: Double) {
		let data = context.model.processedData
		let max = context.model.total
		let reduceAngle = data.prefix(index).reduce(0) { $0 + ($1.sales / max) * 360 }
		let targetRotation = totalAngle - reduceAngle
		withAnimation(rotationAnimation) {
			context.animation.rotationAngle = .degrees(targetRotation)
		}
	}
}

extension ChartDonutSnapperAnimation {
	private static let segmentAnimation = Animation.spring(response: 0.36, dampingFraction: 0.6)
	private static let rotationAnimation = Animation.spring(response: 0.32, dampingFraction: 0.8)
	private static let snapAnimation = Animation.spring(response: 0.42, dampingFraction: 0.6)
	private static let stepDelay: TimeInterval = 0.24
}
