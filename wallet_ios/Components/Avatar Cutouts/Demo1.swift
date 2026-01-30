import SwiftUI

struct AvatarStackViewPreview: View {
	let circleSize: CGFloat
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false),
		AvatarData(content: .image(Image("LargeDP"))),
	]

	private var style: AvatarStyle {
		AvatarStyle(
			strokeWidth: 3.2,
			strokeColor: .blue,
			iconBackgroundColor: .green,
			stackBackgroundColor: .white,
			overlapRatio: 0.4,
			circleSize: circleSize
		)
	}

	var body: some View {
		HStack {
			AvatarStack(
				avatars: avatars,
//				avatarSize: circleSize - (4 * style.strokeWidth),
				style: style,
				shouldCutout: true
			)
		}
		.background(Color.black)
	}
}

#Preview {
	AvatarStackViewPreview(circleSize: 120)
}
