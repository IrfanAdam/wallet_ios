import SwiftUI

struct EdgeAccessory: View {
	var body: some View {
		VStack {
			SwipeToUnlock(
				capSize: CGSize(width: 60, height: 56),
				trackHeight: 56
			) {
				print("Unlocked")
			}
			.padding(.horizontal, 24)
			.padding(.vertical, 12)

			HStack(spacing: 12) {
				Image(systemName: "waveform")
					.padding(10)
					.background(.white.opacity(0.25), in: .circle)

				Text("Recede")
					.foregroundStyle(.white)

				Spacer()
			}
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(12)
		.background(
			Color.clear
				.glassEffect(
					.clear.tint(Color.blue).interactive(),
					in: .containerRelative
				)
		)
	}
}
