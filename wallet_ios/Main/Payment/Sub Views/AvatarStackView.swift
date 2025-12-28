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

struct AvatarStackView: View {
	let circleSize: CGFloat
	let shouldCutout: Bool
	
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
		AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
	]

	private let style = AvatarStyle(
		strokeWidth: 1.5,
		strokeColor: .blue,
		iconBackgroundColor: .white,
		stackBackgroundColor: .white,
		overlapRatio: 0.25
	)

	var body: some View {
		HStack {
			AvatarStack(
				avatars: avatars,
				avatarSize: circleSize - (4 * style.strokeWidth),
				showBackground: false,
				style: style,
				shouldCutout: shouldCutout
			)
//			Text("T Height: \(circleSize, specifier: "%.1f")")
//				.font(.caption)
//				.foregroundColor(.blue)
//				.frame(width: 60)
		}
	}
}
