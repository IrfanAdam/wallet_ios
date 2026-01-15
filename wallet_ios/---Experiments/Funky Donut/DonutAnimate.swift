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
