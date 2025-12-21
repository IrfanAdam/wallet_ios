import SwiftUI

struct AvatarStackView: View {
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false),
	]
	
	var body: some View {
		AvatarStack(avatars: avatars, avatarSize: 32, showBackground: false)
			.scaledToFill()
			.clipShape(Capsule())
	}
}
