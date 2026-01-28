import SwiftUI


//helper
struct ToolbarPill<Content: View>: View {
	let strokeWidth: CGFloat
	let content: Content

	init(
		strokeWidth: CGFloat = 1.5,
		cornerRadius: CGFloat = 42,
		@ViewBuilder content: () -> Content
	) {
		self.strokeWidth = strokeWidth
		self.content = content()
	}

	var body: some View {
		content
			.background(
				Capsule()
					.stroke(Color.blue, lineWidth: strokeWidth)
			)
			.contentShape(Capsule())
	}
}

