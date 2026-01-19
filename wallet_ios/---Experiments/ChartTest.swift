import SwiftUI
import Charts

struct DummyData: Identifiable {
	let month: String
	let sales: Double
	let id = UUID()
}

struct AlternatingBackgroundChart: View {
	let data: [DummyData] = [
		.init(month: "Jan", sales: 1500),
		.init(month: "Feb", sales: 2200),
		.init(month: "Mar", sales: 1800),
		.init(month: "Apr", sales: 2500),
		.init(month: "May", sales: 1900),
		.init(month: "Jun", sales: 2100)
	]

	@State private var selectedMonth: String?

	var body: some View {
		Chart(data) { sale in
			BarMark(
				x: .value("Month", sale.month),
				y: .value("Sales", sale.sales)
			)
			.clipShape(RoundedRectangle(cornerRadius: 12))
			.foregroundStyle(
				selectedMonth == sale.month
				? Color.blue
				: Color.blue.opacity(0.7)
			)
			.annotation(position: .overlay) {
				if selectedMonth == sale.month {
					RoundedRectangle(cornerRadius: 8)
						.stroke(Color.black.opacity(0.25), lineWidth: 2)
				}
			}
		}
		.chartBackground { proxy in
			GeometryReader { geo in
				if let plotAnchor = proxy.plotFrame {
					let plotFrame = geo[plotAnchor]
					let barWidth = plotFrame.width / CGFloat(data.count)

					HStack(spacing: 0) {
						ForEach(data.indices, id: \.self) { index in
							(index.isMultiple(of: 2)
							 ? Color.gray.opacity(0.2)
							 : Color.clear
							)
							.frame(width: barWidth)
							.clipShape(RoundedRectangle(cornerRadius: 12))
						}
					}
					.frame(width: plotFrame.width, height: plotFrame.height)
					.position(x: plotFrame.midX, y: plotFrame.midY)
				}
			}
		}
		.frame(height: 300)
		.padding()
		.chartYAxis(.hidden)
		.chartXAxis {
			AxisMarks {
				AxisTick().foregroundStyle(.clear)
				AxisValueLabel()
			}
		}
	}
}

#Preview {
	AlternatingBackgroundChart()
}
