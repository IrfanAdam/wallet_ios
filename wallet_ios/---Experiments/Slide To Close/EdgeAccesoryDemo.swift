import SwiftUI

struct EdgeAccessoryDemo: View {
	@Environment(\.dismiss) private var dismiss
	var body: some View {
		ZStack(alignment: .bottom) {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					ForEach(0..<40, id: \.self) { i in
						Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Line \(i)")
							.font(.system(size: 18, weight: .medium))
					}
				}
				.padding(24)
			}
			.background(.white)

			EdgeAccessory()
		}
		.padding(.horizontal, 4)
		.padding(.vertical, 4)
		.ignoresSafeArea()
		.overlay(alignment: .topTrailing) {
			Button {
				dismiss()
			} label: {
				Image(systemName: "xmark")
					.font(.system(size: 20, weight: .semibold))
					.padding(16)
					.background(.ultraThinMaterial, in: .circle)
			}
			.padding()
		}
	}
}

#Preview {
	EdgeAccessoryDemo()
}
