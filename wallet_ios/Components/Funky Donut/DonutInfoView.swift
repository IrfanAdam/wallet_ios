import SwiftUI

struct DonutSelectionInfoView: View {
	@Bindable var mainContext: DonutChartContext

	var body: some View {
		VStack {
			HStack(alignment: .top) {
				Image("LargeDP") // replace with your image
					.resizable()
					.scaledToFill()
					.frame(width: 36, height: 36)
					.clipShape(Circle())

				Spacer()
				VStack(alignment: .trailing, spacing: 4) {
					// Checkmark
					Image(systemName: "checkmark")
						.font(.system(size: 14, weight: .semibold))
						.foregroundStyle(.black.opacity(0.8))

					// Percentage Badge
					Text("54%")
						.font(.system(size: 14, weight: .semibold))
						.foregroundStyle(Color.blue)
						.padding(.horizontal, 4)
						.padding(.vertical, 2)
						.background(
							Capsule()
								.fill(Color.blue.opacity(0.12))
						)
				}
			}
			if let selected = mainContext.interaction.selectedData {
				Text("User Name: \(selected.name)")
					.font(.headline)

				Button("Clear") {
					withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
						mainContext.interaction.selectedData = nil
					}
				}
				.font(.subheadline)
				.foregroundStyle(.secondary)
			} else {
				Text("Tap a segment")
					.foregroundStyle(.secondary)
			}

			HStack(spacing: 2) {
				let selectedIndex = mainContext.model.processedData.firstIndex {
					$0.name == mainContext.interaction.selectedData?.name
				} ?? 0

				ForEach(mainContext.model.processedData.indices, id: \.self) { index in
					let distance = abs(index - selectedIndex)

					// Smooth falloff (tweak these)
					let width = max(6, 12 - CGFloat(distance) * 6)
					let height = max(4, 8 - CGFloat(distance))
					let opacity = max(0.1, 1.0 - Double(distance) * 0.3)

					Capsule()
						.fill(Color.black.opacity(opacity))
						.frame(width: width, height: height)
						.animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedIndex)
				}
			}

			
		}
		.frame(width: 100, height: 116)
		.padding(.horizontal, 12)
		.padding(.vertical, 8)
		.background(
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(Color(.systemBackground)) // off-white
		)
		.shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
	}
}
