import SwiftUI

struct ChartAnimation {
	static func prepareAnimatedData(from data: [SalesData]) -> [SalesData] {
		data.map {
			SalesData(
				id: $0.id,
				name: $0.name,
				sales: .leastNonzeroMagnitude
			)
		}
	}
}

struct ChartDonutSnapperAnimation {
	static func start(
		data: [SalesData],
		total: Double? = nil,
		animatedData: Binding<[SalesData]>
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
			at: 0,
			data: data,
			animatedData: animatedData
		)
	}
	
	private static func animateSegment(
		at index: Int,
		data: [SalesData],
		animatedData: Binding<[SalesData]>
	) {
		guard index < data.count else { return }
		
		withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
			animatedData.wrappedValue[index] = data[index]
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
			animateSegment(
				at: index + 1,
				data: data,
				animatedData: animatedData
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
	
	func flippedHorizontally() -> some View {
		self.scaleEffect(x: -1, y: 1)
	}
}
