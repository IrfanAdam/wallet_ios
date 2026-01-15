import SwiftUI

// MARK: - Animation Logic

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
	
	static func animateSegments(
		data: [SalesData],
		animatedData: Binding<[SalesData]>
	) {
#if DEBUG
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			animatedData.wrappedValue = data
			return
		}
#endif
		
		func animate(at index: Int) {
			guard index < data.count else { return }
			
			withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
				animatedData.wrappedValue[index] = data[index]
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
				animate(at: index + 1)
			}
		}
		
		animate(at: 0)
	}

	
}

// MARK: - Selection Logic

struct ChartSelection {
	
	static func updateSelection(
		rawValue: Double?,
		data: [SalesData],
		selectedName: Binding<String?>
	) {
		guard let rawValue else { return }
		
		selectedName.wrappedValue = findSelectedName(
			for: rawValue,
			in: data
		)
	}
	
	static func findSelectedName(
		for value: Double,
		in data: [SalesData]
	) -> String? {
		var cumulativeTotal: Double = 0
		
		for element in data {
			cumulativeTotal += element.sales
			if value <= cumulativeTotal {
				return element.name
			}
		}
		return nil
	}
}
