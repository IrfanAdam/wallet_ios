import SwiftUI

struct ShadowAnimationDemo: View {
	@State private var isSelected = false

	var body: some View {
		VStack {
			Spacer()

			RoundedRectangle(cornerRadius: 20)
				.fill(Color.blue)
				.frame(width: 200, height: 120)
				.shadow(
					color: Color.black.opacity(isSelected ? 0.5 : 0.9),
					radius: isSelected ? 20 : 0,
					x: 0,
					y: isSelected ? 10 : 3
				)
				.scaleEffect(isSelected ? 1.05 : 1.0)
				.animation(.easeInOut(duration: 0.3), value: isSelected)
				.onTapGesture {
					isSelected.toggle()
				}

			Spacer()

			Text("Tap the card")
				.foregroundColor(.gray)
		}
	}
}

#Preview {
	ShadowAnimationDemo()
}
