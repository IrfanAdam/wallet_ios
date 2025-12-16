import SwiftUI

struct SpendingChartStyle {
    var barWidth: CGFloat = 16
    var barSpacing: CGFloat = 0
    var chartHeight: CGFloat = 240
    var cornerRadius: CGFloat = 6
    var highlightPadding: CGFloat = 4
    var highlightBorder: CGFloat = 3.2
    var opacityGhost: CGFloat = 0.4
    var verticalGap: CGFloat = 1.5
}

struct SpendingSheetView: View {
	@State private var selectedIndex: Int = 7   // August selected

	let style = SpendingChartStyle()

	// Use the new data
	private let data: [SpendingEntry] = spendingYear

	private var maxValue: Double {
		var values: [Double] = []

		for entry in data {
			let actualSpent = entry.actual?.spent ?? 0
			let actualReceived = entry.actual?.received ?? 0
			let forecastSpent = entry.forecast?.projectedSpent ?? 0
			let forecastReceived = entry.forecast?.projectedReceived ?? 0

			let actualTotal = actualSpent + actualReceived
			let forecastTotal = forecastSpent + forecastReceived

			values.append(max(actualTotal, forecastTotal))
		}

		return values.max() ?? 1
	}

	var body: some View {
		VStack(spacing: 16) {
			chart
			details
		}
		.padding(0)
	}

	private var chart: some View {
		ScrollViewReader { proxy in
			HStack() {
				if selectedIndex != 0 {
					Button(action: {
						withAnimation(.easeInOut(duration: 0.25)) {
							proxy.scrollTo(0, anchor: .center)
						}
						selectedIndex = 0
					}) {
						Text("Go to Jan")
							.font(.system(size: 13, weight: .medium))
							.foregroundColor(.black.opacity(0.8))
							.padding(.vertical, 8)
							.padding(.horizontal, 16)
							.background(
								Capsule()
									.fill(Color(.systemGray6))
							)
							.overlay(
								Capsule()
									.stroke(Color.black.opacity(0.1), lineWidth: 1)
							)
					}
				}
				Spacer()
				if selectedIndex != 7 {
					Button(action: {
						withAnimation(.easeInOut(duration: 0.25)) {
							proxy.scrollTo(7, anchor: .center)
						}
						selectedIndex = 7
					}) {
						Text("Current")
							.font(.system(size: 13, weight: .medium))
							.foregroundColor(.black.opacity(0.8))
							.padding(.vertical, 8)
							.padding(.horizontal, 16)
							.background(
								Capsule()
									.fill(Color(.systemGray6))
							)
							.overlay(
								Capsule()
									.stroke(Color.black.opacity(0.1), lineWidth: 1)
							)
					}
				}
			}
			.animation(.easeInOut(duration: 0.2), value: selectedIndex)
			.padding(.horizontal)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .bottom, spacing: style.barSpacing) {
					ForEach(Array(data.enumerated()), id: \.1.id) { index, entry in
						content(for: entry, index: index).id(index)
							.onTapGesture { withAnimation { selectedIndex = index } }
					}
				}
				.padding(12)
			}
			.onAppear {
				if let lastIndex = data.indices.last {
					proxy.scrollTo(lastIndex, anchor: .trailing)
				}
			}
		}
		.frame(height: style.chartHeight + 50)
	}

	@ViewBuilder
	private func content(for entry: SpendingEntry, index: Int) -> some View {
		let hasForecastSpend = entry.forecast?.projectedSpent != nil
		let hasActualSpend = entry.actual?.spent != nil
		let hasForecastCredit = entry.forecast?.projectedReceived != nil
		let hasActualCredit = entry.actual?.received != nil
		let isAlternate = index.isMultiple(of: 2)
		VStack(spacing: 4) {
			HStack(alignment: .bottom, spacing: 2) {
				// Received bar
				VStack(spacing: style.verticalGap) {
					if hasForecastCredit {
						Color.green
							.opacity(0.4)
							.frame(height: CGFloat((entry.actual?.received ?? entry.forecast?.projectedReceived ?? 0) / maxValue) * style.chartHeight * 0.75)
							.clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
					}
					if hasActualCredit {
						Color.green
							.frame(height: CGFloat((entry.actual?.received ?? entry.forecast?.projectedReceived ?? 0) / maxValue) * style.chartHeight * 0.75)
							.clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
					}
				}
				.frame(width: style.barWidth)

				// Spent bar
				VStack(spacing: style.verticalGap) {
					if hasForecastSpend {
						Color.blue
							.opacity(0.4)
							.frame(height: CGFloat((entry.actual?.received ?? entry.forecast?.projectedSpent ?? 0) / maxValue) * style.chartHeight * 0.75)
							.clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
					}

					if hasActualSpend {
						Color.blue
							.frame(height: CGFloat((entry.actual?.spent ?? entry.forecast?.projectedSpent ?? 0) / maxValue) * style.chartHeight * 0.75)
							.clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
					}
				}
				.frame(width: style.barWidth)
			}
			.padding(4)
			.background(
				RoundedRectangle(cornerRadius: style.cornerRadius)
					.stroke(index == selectedIndex ? Color.black.opacity(1) : Color.clear,
									lineWidth: style.highlightBorder)
			)
			.clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))

			Text(entry.time.label)
				.font(.caption)
				.foregroundColor(.black.opacity(index > 7 ? 0.3 : 0.8))
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
		.background(
			isAlternate
			? Color.white.opacity(0.6)   // soft gray background block
			: Color.clear
		)
		.clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
	}

	private var details: some View {
		VStack(spacing: 12) {
			Text("Details Section Placeholder")
				.font(.footnote)
				.foregroundColor(.gray)
			Divider()
		}
	}
}

#Preview {
	SpendingSheetView()
}
