import SwiftUI
import Charts

struct DonutShadowDemoView: View {
	struct DataItem: Identifiable {
		let id = UUID()
		let label: String
		let value: Double
		let color: Color
	}

	let data: [DataItem] = [
		.init(label: "Rent", value: 35, color: .indigo),
		.init(label: "Food", value: 20, color: .orange),
		.init(label: "Transport", value: 15, color: .teal),
		.init(label: "Health", value: 10, color: .pink),
		.init(label: "Savings", value: 20, color: .green)
	]

	let borderColor = Color.black

	@State private var selectedID: UUID? = nil
	@State private var selectedAngle: Double? = nil   // ✅ FIX

	var body: some View {
		Chart(data) { item in
			let isSelected = item.id == selectedID

			// 🔑 Animatable properties
			let outerRadius: CGFloat = isSelected ? 0.9 : 0.9
			let innerRadius: CGFloat = isSelected ? 0.6 : 0.6
			let inset: CGFloat       = isSelected ? 4 : 1

			let borderOpacity: CGFloat = isSelected ? 1.0 : 0.1
			let fillOpacity: CGFloat   = isSelected ? 1.0 : 1.0
			let borderStroke: CGFloat   = isSelected ? 1.5 : 0.64

			SectorMark(
				angle: .value("Value", item.value),
				innerRadius: .ratio(innerRadius),
				outerRadius: .ratio(outerRadius),
				angularInset: inset
			)
			.foregroundStyle(item.color.opacity(fillOpacity))
			.cornerRadius(8)

			// 🔥 Smooth “border”
			.shadow(color: borderColor.opacity(borderOpacity), radius: 0, x: 0, y: -borderStroke)
			.shadow(color: borderColor.opacity(borderOpacity), radius: 0, x: -borderStroke, y: 0)
			.shadow(color: borderColor.opacity(borderOpacity), radius: 0, x: 0, y: borderStroke)
			.shadow(color: borderColor.opacity(borderOpacity), radius: 0, x: borderStroke, y: 0)
		}
		.frame(height: 300)

		// ✅ FIX: use real binding
		.chartAngleSelection(value: $selectedAngle)

		// ✅ FIX: correct angle → segment mapping (NO 360 math)
		.onChange(of: selectedAngle) {_, angle in
			guard let angle else { return }

			var current: Double = 0

			for item in data {
				let next = current + item.value

				if angle >= current && angle <= next {
					withAnimation(.easeInOut(duration: 0.25)) {
						selectedID = item.id
					}
					break
				}

				current = next
			}
		}
	}
}

#Preview {
	DonutShadowDemoView()
}
