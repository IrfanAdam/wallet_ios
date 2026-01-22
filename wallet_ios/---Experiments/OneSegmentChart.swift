import SwiftUI
import Charts

struct DonutVisibilitySwitcher: View {

	struct Item: Identifiable {
		let id = UUID()
		let name: String
		let value: Double
		let color: Color
	}

	let data: [Item]

	@State private var visibleID: UUID?

	var body: some View {
		VStack(spacing: 24) {

			// MARK: - Donut Chart
			Chart {
				ForEach(data) { item in
					let isVisible = item.id == visibleID

					SectorMark(
						angle: .value("Value", item.value),
						innerRadius: .ratio(0.6),
						angularInset: 1
					)
					// 👇 geometry stays, paint disappears
					.foregroundStyle(isVisible ? item.color : .clear)
					.opacity(isVisible ? 1 : 0)
				}
			}

			.frame(width: 260, height: 260)
			.chartLegend(.hidden)

			// MARK: - Buttons
			HStack {
				ForEach(data) { item in
					Button {
						withAnimation(.easeInOut(duration: 0.25)) {
							visibleID = item.id
						}
					} label: {
						Text(item.name)
							.padding(.horizontal, 12)
							.padding(.vertical, 6)
							.background(
								RoundedRectangle(cornerRadius: 8)
									.fill(item.id == visibleID
												? item.color.opacity(0.2)
												: .gray.opacity(0.15))
							)
					}
				}
			}
		}
		.onAppear {
			visibleID = data.first?.id
		}
	}
}

#Preview {
	DonutVisibilitySwitcher(
		data: [
			.init(name: "Food", value: 40, color: .red),
			.init(name: "Rent", value: 30, color: .blue),
			.init(name: "Travel", value: 20, color: .green),
			.init(name: "Other", value: 10, color: .orange)
		]
	)
}
