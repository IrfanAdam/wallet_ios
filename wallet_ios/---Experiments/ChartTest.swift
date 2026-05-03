import SwiftUI
import Charts

struct DummyData: Identifiable {
	let month: String
	let sales: Double
	let target: Double
	let id = UUID()
}

struct AlternatingBackgroundChart: View {
	let data: [DummyData] = [
		.init(month: "Jan", sales: 1500, target: 1800),
		.init(month: "Feb", sales: 2200, target: 2000),
		.init(month: "Mar", sales: 1800, target: 2100),
		.init(month: "Apr", sales: 2500, target: 2300),
		.init(month: "May", sales: 1900, target: 2200),
		.init(month: "Jun", sales: 2100, target: 2000),
		.init(month: "Jul", sales: 1700, target: 1900),
		.init(month: "Aug", sales: 2800, target: 2500),
		.init(month: "Sep", sales: 2300, target: 2400),
		.init(month: "Oct", sales: 1600, target: 2000),
		.init(month: "Nov", sales: 2900, target: 2700),
		.init(month: "Dec", sales: 3100, target: 2800)
	]
	
	@State private var selectedMonth: String?  // drives rectangle overlay (spring)
	@State private var opacityMonth: String?   // drives bar mark opacity (easeOut)
	
	let barWidth: CGFloat = 64
	let labelFontSize: CGFloat = 12
	let labelVerticalPadding: CGFloat = 4
	var labelHeight: CGFloat { labelFontSize + labelVerticalPadding * 2 }
	let widthRatio: CGFloat = 0.82
	
	let grayGradient = LinearGradient(
		colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.0)],
		startPoint: .bottom,
		endPoint: .top
	)
	
	var totalWidth: CGFloat { barWidth * CGFloat(data.count) }

	
	@Namespace private var selectionNamespace
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			Chart(data) { sale in
				let isSelected = opacityMonth == sale.month
				let noneSelected = opacityMonth == nil
				
				// MARK: - Sales Bar
				BarMark(
					x: .value("Month", sale.month),
					y: .value("Sales", sale.sales),
					width: .ratio(widthRatio)
				)
				.position(by: .value("Type", "Sales"), axis: .horizontal, span: .inset(5))
				.clipShape(RoundedRectangle(cornerRadius: 6))
				.foregroundStyle(
					(noneSelected || isSelected) ? Color.blue : Color.blue.opacity(0.8)
				)
				.annotation(position: .overlay, spacing: 0) {
					RoundedRectangle(cornerRadius: 6)
						.strokeBorder(Color.black.opacity(0.32), lineWidth: isSelected ? 2 : 0)
				}
				
				// MARK: - Target Bar
				BarMark(
					x: .value("Month", sale.month),
					y: .value("Target", sale.target),
					width: .ratio(widthRatio)
				)
				.position(by: .value("Type", "Target"), axis: .horizontal, span: .inset(5))
				.clipShape(RoundedRectangle(cornerRadius: 6))
				.foregroundStyle(
					(noneSelected || isSelected) ? Color.green : Color.green.opacity(0.8)
				)
				.annotation(position: .overlay, spacing: 0) {
					RoundedRectangle(cornerRadius: 6)
						.strokeBorder(Color.black.opacity(0.32), lineWidth: isSelected ? 2 : 0)
				}
			}
			
			// MARK: - Background (alternating columns + selection highlight)
			.chartBackground { proxy in
				GeometryReader { geo in
					if let plotAnchor = proxy.plotFrame {
						let plotFrame = geo[plotAnchor]
						let colWidth = plotFrame.width / CGFloat(data.count)
						let bgHeight = plotFrame.height + labelHeight * 2
						
						HStack(spacing: 0) {
							ForEach(data.indices, id: \.self) { index in
								let month = data[index].month
								let isSelected = selectedMonth == month
								
								ZStack {
									// Alternating gray stripe
									if index.isMultiple(of: 2) && !isSelected {
										VStack(spacing: 0) {
											UnevenRoundedRectangle(
												topLeadingRadius: 12,
												bottomLeadingRadius: 0,
												bottomTrailingRadius: 0,
												topTrailingRadius: 12
											)
											.fill(grayGradient)
											.frame(width: colWidth, height: plotFrame.height)
											
											UnevenRoundedRectangle(
												topLeadingRadius: 0,
												bottomLeadingRadius: 12,
												bottomTrailingRadius: 12,
												topTrailingRadius: 0
											)
											.fill(Color.gray.opacity(0.15))
											.frame(width: colWidth, height: labelHeight * 2)
										}
									} else {
										Color.clear
											.frame(width: colWidth, height: bgHeight)
									}
									
									if isSelected {
										RoundedRectangle(cornerRadius: 12)
											.fill(Color.gray.opacity(0.06))
											.overlay(
												RoundedRectangle(cornerRadius: 14)
													.strokeBorder(Color.black.opacity(0.9), lineWidth: 2.25)
											)
											.frame(width: colWidth, height: bgHeight)
											.matchedGeometryEffect(id: "selection", in: selectionNamespace)
											.transition(.opacity)
									}
								}
								.frame(width: colWidth, height: bgHeight)
							}
						}
						.frame(width: plotFrame.width)
						.position(x: plotFrame.midX, y: plotFrame.midY + labelHeight * 0.72)
					}
				}
			}
			
			// MARK: - Tap detection
			.chartOverlay { proxy in
				GeometryReader { geo in
					Color.clear
						.contentShape(Rectangle())
						.onTapGesture { location in
							guard let plotFrame = proxy.plotFrame else { return }
							let origin = geo[plotFrame].origin
							let x = location.x - origin.x
							if let month: String = proxy.value(atX: x) {
								let next = (selectedMonth == month) ? nil : month
								
								// Spring → rectangle overlay
								withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
									selectedMonth = next
								}
								// EaseOut → bar mark opacity
								withAnimation(.easeOut(duration: 0.25)) {
									opacityMonth = next
								}
							}
						}
				}
			}
			
			.frame(width: totalWidth, height: 300)
			.chartYAxis(.hidden)
			.chartLegend(.hidden)
			
			// MARK: - X Axis
			.chartXAxis {
				AxisMarks { value in
					AxisTick().foregroundStyle(.clear)
					AxisGridLine().foregroundStyle(.clear)
					AxisValueLabel(centered: true) {
						if let month = value.as(String.self) {
							let isSelected = selectedMonth == month
							let noneSelected = opacityMonth == nil
							Text(month.uppercased())
								.font(.system(size: labelFontSize, weight: .bold))
								.padding(.vertical, labelVerticalPadding)
								.foregroundStyle(
									isSelected
									? Color.black
									: (noneSelected ? Color.black.opacity(0.9) : Color.black.opacity(0.6))
								)
						}
					}
				}
			}
			.padding()
		}
	}
}

#Preview {
	AlternatingBackgroundChart()
}
