import SwiftUI

struct ExpandingCapsuleStackModifier: ViewModifier {
	@Binding var height: CGFloat
	@Binding var animateSpace: Bool
	@Binding var stackWidth: CGFloat

	let totalWidth: CGFloat

	func body(content: Content) -> some View {
		content
			.onChange(of: height) { _, _ in
				animateSpace = false
				stackWidth = height
				withAnimation(.spring(response: 0.36, dampingFraction: 0.8).delay(0.2)) {
					animateSpace = true
				}
				withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
					stackWidth = totalWidth
				}
			}
			.drawingGroup()
			.frame(width: stackWidth)
			.fixedSize(horizontal: true, vertical: false)
			.background(
				Capsule()
					.fill(Color.black.opacity(0.9))
			)
	}
}
