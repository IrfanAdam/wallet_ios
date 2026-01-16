import SwiftUI

struct ChartDonutSnapperAnimation {
	static func start(
		data: [SalesData],
		animatedData: Binding<[SalesData]>,
		chartRotation: Binding<Angle>
	) {
		chartRotation.wrappedValue = .degrees(0)
		
		animatedData.wrappedValue = data.map {
			SalesData(
				id: $0.id,
				name: $0.name,
				sales: 0.00000000000000001
			)
		}

		animateSegment(
			at: data.count - 1,
			data: data,
			animatedData: animatedData,
			chartRotation: chartRotation
		)
	}
	

	private static func animateSegment(
		at index: Int,
		data: [SalesData],
		animatedData: Binding<[SalesData]>,
		chartRotation: Binding<Angle>
	) {
		let total = data.reduce(0) { $0 + $1.sales }
		guard index >= 0 else { return }

		let isFirst = index == data.count - 1

		withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
			animatedData.wrappedValue[index] = data[index]
		}

		withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
			let segmentAngle = (data[index].sales / total) * 360
			chartRotation.wrappedValue += .degrees(segmentAngle)
		}

		if isFirst {
			let cumulativeAmount = data.prefix(index + 1)
				.filter { $0.name != "Remaining" }
				.reduce(0) { $0 + $1.sales }
			let cumulativeAngle = (cumulativeAmount / total) * 360
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
				withAnimation(.spring(response: 0.42, dampingFraction: 0.6)) {
					chartRotation.wrappedValue += .degrees(cumulativeAngle)
				}
			}
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
			animateSegment(
				at: index - 1,
				data: data,
				animatedData: animatedData,
				chartRotation: chartRotation
			)
		}
	}
}

extension View {
	func chartSpringAnimation(
		rawSelectedValue: Double?,
		selectedName: String?
	) -> some View {
		self
			.animation(
				.spring(response: 0.25, dampingFraction: 0.8),
				value: rawSelectedValue
			)
			.animation(
				.spring(response: 0.42, dampingFraction: 0.6),
				value: selectedName
			)
	}
}
