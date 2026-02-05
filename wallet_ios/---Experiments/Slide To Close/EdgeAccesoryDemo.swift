import SwiftUI

struct EdgeAccessoryDemo: View {
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
	}
}

#Preview {
	EdgeAccessoryDemo()
}
