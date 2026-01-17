import SwiftUI

struct ChartDonutSnapperAnimation {
	
	static func start(context: DonutChartContext) {
		context.animatedData.wrappedValue = context.processedData.wrappedValue.map {
			SalesData(id: $0.id, name: $0.name, sales: .ulpOfOne)
		}
		context.rotationContext.angle = .degrees(0)
		animateSegment(at: context.processedData.wrappedValue.count - 1, context: context)
	}
	
	private static func animateSegment(at index: Int, context: DonutChartContext) {
		guard index >= 0 else { return }
		
		let segmentAnimation = Animation.spring(response: 0.36, dampingFraction: 0.6)
		let delay: TimeInterval = 0.24
		
		withAnimation(segmentAnimation) {
			context.animatedData.wrappedValue[index] = context.processedData.wrappedValue[index]
		}
		animateRotation(at: index, context: context)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			animateSegment(at: index - 1, context: context)
		}
	}
	
	private static func animateRotation(at index: Int, context: DonutChartContext) {
		let total = context.processedData.wrappedValue.reduce(0) { $0 + $1.sales }
		let segmentAngle = (context.processedData.wrappedValue[index].sales / total) * 360
		let rotationAnimation = Animation.spring(response: 0.32, dampingFraction: 0.8)
		let snapAnimation = Animation.spring(response: 0.42, dampingFraction: 0.6)
		let delay: TimeInterval = 0.24
		
		withAnimation(rotationAnimation) {
			context.rotationContext.angle += .degrees(segmentAngle) // <- use original context
		}
		
		if index == context.processedData.wrappedValue.count - 1 {
			let cumulative = context.processedData.wrappedValue
				.prefix(index + 1)
				.filter { $0.name != "Remaining" }
				.reduce(0) { $0 + $1.sales }
			let cumulativeAngle = (cumulative / total) * 360
			
			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				withAnimation(snapAnimation) {
					context.rotationContext.angle += .degrees(cumulativeAngle) // <- again, original context
				}
			}
		}
	}
}
