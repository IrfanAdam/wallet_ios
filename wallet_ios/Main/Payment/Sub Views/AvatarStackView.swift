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
	
	@State private var checkCount = 0

	var body: some View {
		let _ = {
			checkCount += 1
			print("🟣 Render pass:", checkCount)
			Self._printChanges()
		}()
		
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
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
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
				style: style
			)
			.fixedSize(horizontal: true, vertical: true)
			.transaction { t in t.animation = nil }
//			Text("T Height: \(circleSize, specifier: "%.1f")")
//				.font(.caption)
//				.foregroundColor(.blue)
//				.frame(width: 60)
		}
	}
}
