import SwiftUI
import Observation

@Observable
final class CutoutAvatarStackContext {

	struct Model {
		let avatars: [CutoutAvatarData]
		let style: CutoutAvatarStyle
		let shouldCutout: Bool
		let showBorder: Bool
	}

	struct Layout {
		var containerHeight: CGFloat = 0
		var avatarDiameter: CGFloat = 0
		var overlapSpacing: CGFloat = 0
		var totalWidth: CGFloat = 0
	}

	struct AnimationState {
		var animateIn: Bool = false
		var isRasterized: Bool = false
	}

	let model: Model
	var layout = Layout()
	var animation = AnimationState()

	init(
		avatars: [CutoutAvatarData],
		style: CutoutAvatarStyle,
		shouldCutout: Bool,
		showBorder: Bool
	) {
		self.model = Model(
			avatars: avatars,
			style: style,
			shouldCutout: shouldCutout,
			showBorder: showBorder
		)
	}
}
