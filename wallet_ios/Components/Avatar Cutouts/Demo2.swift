import SwiftUI

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
		}
	}
}


#Preview {
	NavigationStack {
		GeometryReader { ProxyRepresentation in
			AvatarStackView(circleSize: 42, shouldCutout: true)
		}.background(Color.black)
	}
}
