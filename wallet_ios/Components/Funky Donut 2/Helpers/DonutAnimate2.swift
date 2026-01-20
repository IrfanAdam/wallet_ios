import SwiftUI

struct ChartDonutSnapperAnimation2 {

	// MARK: - Public start
	static func start(context: DonutChartContext2) {
		let procsData = context.model.processedData
		context.animation.animatedData = procsData.map {
			SalesData(id: $0.id, name: $0.name, sales: .ulpOfOne)
		}
		context.animation.rotationAngle = .degrees(0)
		animateSegment(at: procsData.count - 1, context: context)
	}
}

// MARK: - Private helper methods
private extension ChartDonutSnapperAnimation2 {
	static func animateSegment(at index: Int, context: DonutChartContext2) {
		guard index >= 0 else { return }
		let data = context.model.processedData
		withAnimation(segmentAnimation) {
			context.animation.animatedData[index] = data[index]
		}
//		animateRotation(at: index, context: context)
		DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay) {
			animateSegment(at: index - 1, context: context)
		}
	}

	static func animateRotation(at index: Int, context: DonutChartContext2) {
		let data = context.model.processedData
		let total = data.reduce(0) { $0 + $1.sales }
		let segmentAngle = (data[index].sales / total) * 360

		withAnimation(rotationAnimation) {
			context.animation.rotationAngle += .degrees(segmentAngle)
		}

		if index == data.count - 1 {
			let cumulative = data.prefix(index + 1)
				.filter { $0.name != "Remaining" }
				.reduce(0) { $0 + $1.sales }
			let cumulativeAngle = (cumulative / total) * 360

			DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay) {
				withAnimation(snapAnimation) {
					context.animation.rotationAngle += .degrees(cumulativeAngle)
				}
			}
		}
	}
}

// MARK: - Animation constants
extension ChartDonutSnapperAnimation2 {
	private static let segmentAnimation = Animation.spring(response: 0.36, dampingFraction: 0.6)
	private static let rotationAnimation = Animation.spring(response: 0.32, dampingFraction: 0.8)
	private static let snapAnimation = Animation.spring(response: 0.42, dampingFraction: 0.6)
	private static let stepDelay: TimeInterval = 0.24
}
