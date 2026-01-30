import SwiftUI

struct AvatarStackView: View {
	let avatars: [AvatarData]
	let circleSize: CGFloat
	let shouldCutout: Bool

	init(
		avatars: [AvatarData],
		circleSize: CGFloat,
		shouldCutout: Bool = true
	) {
		self.avatars = avatars
		self.circleSize = circleSize
		self.shouldCutout = shouldCutout
	}

	private var style: AvatarStyle {
		AvatarStyle(
			strokeWidth: 1.5,
			strokeColor: .blue,
			iconBackgroundColor: .white,
			stackBackgroundColor: .white,
			overlapRatio: 0.25,
			circleSize: circleSize + 1.5 * 2
		)
	}

	var body: some View {
		HStack {
			AvatarStack(
				avatars: avatars,
				style: style,
				shouldCutout: shouldCutout
			)
		}
		.onChange(of: circleSize) {_, newValue in
			print("Toolbar circle size:", newValue)
		}
	}
}

