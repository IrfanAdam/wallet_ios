import SwiftUI

struct ChartDonutSnapperAnimation {
	static func start(
		data: [SalesData],
		animatedData: Binding<[SalesData]>,
		chartRotation: Binding<Angle>
	) {
		chartRotation.wrappedValue = .degrees(0)
		animatedData.wrappedValue = data.map {
			SalesData(id: $0.id, name: $0.name, sales: .ulpOfOne)
		}

		let segmentAnimation = Animation.spring(response: 0.36, dampingFraction: 0.6)
		let rotationAnimation = Animation.spring(response: 0.32, dampingFraction: 0.8)
		let snapAnimation = Animation.spring(response: 0.42, dampingFraction: 0.6)
		let delay: TimeInterval = 0.24

		let total = data.reduce(0) { $0 + $1.sales }

		func animateSegment(at index: Int) {
			guard index >= 0 else { return }

			withAnimation(segmentAnimation) {
				animatedData.wrappedValue[index] = data[index]
			}

			animateRotation(at: index)

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				animateSegment(at: index - 1)
			}
		}

		func animateRotation(at index: Int) {
			let segmentAngle = (data[index].sales / total) * 360
			withAnimation(rotationAnimation) {
				chartRotation.wrappedValue += .degrees(segmentAngle)
			}

			if index == data.count - 1 {
				let cumulative = data.prefix(index + 1).filter { $0.name != "Remaining" }.reduce(0) { $0 + $1.sales }
				let cumulativeAngle = (cumulative / total) * 360

				DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
					withAnimation(snapAnimation) {
						chartRotation.wrappedValue += .degrees(cumulativeAngle)
					}
				}
			}
		}

		animateSegment(at: data.count - 1)
	}
}
