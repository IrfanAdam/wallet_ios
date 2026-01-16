import SwiftUI

struct ChartDonutSnapperAnimation {
	static func start(
		data: [SalesData],
		animatedData: Binding<[SalesData]>,
		chartRotation: Binding<Angle>
	) {
		// Initialize with near-zero values
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
		guard index >= 0 else { return }
		
		withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
			animatedData.wrappedValue[index] = data[index]
			chartRotation.wrappedValue += .degrees(data[index].sales)
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
