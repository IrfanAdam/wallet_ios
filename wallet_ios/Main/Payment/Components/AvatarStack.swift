import SwiftUI

struct AvatarStyle {
	let strokeWidth: CGFloat
	let strokeColor: Color
	let iconBackgroundColor: Color
	let stackBackgroundColor: Color
	let overlapRatio: CGFloat

	static let `default` = AvatarStyle(
		strokeWidth: 1.5,
		strokeColor: .blue,
		iconBackgroundColor: .blue,
		stackBackgroundColor: .white,
		overlapRatio: 0.2
	)
}

struct AvatarData: Identifiable {
	let id = UUID()
	let content: AvatarContent
	let hasBorder: Bool
	
	init(content: AvatarContent, hasBorder: Bool = true) {
		self.content = content
		self.hasBorder = hasBorder
	}
}

struct AvatarStack: View {
	let avatars: [AvatarData]
	let avatarSize: CGFloat
	let showBackground: Bool
	let style: AvatarStyle

	init(
		avatars: [AvatarData],
		avatarSize: CGFloat = 32,
		showBackground: Bool = false,
		style: AvatarStyle = .default
	) {
		self.avatars = avatars
		self.avatarSize = avatarSize
		self.showBackground = showBackground
		self.style = style
	}

	var body: some View {
		HStack(spacing: -(avatarSize * style.overlapRatio)) {
			ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in
				let isLast = index == avatars.count - 1

				switch avatar.content {
				case .image(let image):
					AvatarCircle(
						size: avatarSize,
						image: image,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder,
						style: style
					)

				case .icon(let icon):
					AvatarCircle(
						size: avatarSize,
						icon: icon,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder,
						style: style
					)
				}
			}
		}
		.padding(style.strokeWidth) // inner clearance only
		.background {
			if showBackground {
				RoundedRectangle(
					cornerRadius: avatarSize / 2,
					style: .continuous
				)
				.fill(style.stackBackgroundColor)
			}
		}
	}
}


#Preview {
	AvatarStackViewPreview(circleSize: 120)
}

struct AvatarStackViewPreview: View {
	let circleSize: CGFloat
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false),
		AvatarData(content: .image(Image("LargeDP"))),
	]

	private let style = AvatarStyle(
		strokeWidth: 3.2,
		strokeColor: .blue,
		iconBackgroundColor: .green,
		stackBackgroundColor: .white,
		overlapRatio: 0.4
	)

	var body: some View {
		HStack {
			AvatarStack(
				avatars: avatars,
				avatarSize: circleSize - (4 * style.strokeWidth),
				showBackground: false,
				style: style
			)
		}
	}
}
