import SwiftUI

extension View {
	
	func chartSpringAnimation(
		rawSelectedValue: Double?,
		selectedName: String?
	) -> some View {
		self
			.animation(
				.spring(response: 0.25, dampingFraction: 0.8),
				value: rawSelectedValue
			)
			.animation(
				.spring(response: 0.42, dampingFraction: 0.6),
				value: selectedName
			)
	}
	
	func flippedHorizontally() -> some View {
		self.scaleEffect(x: -1, y: 1)
	}
}
