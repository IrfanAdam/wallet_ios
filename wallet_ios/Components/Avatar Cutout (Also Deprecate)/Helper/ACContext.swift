import SwiftUI
import Observation

@Observable
final class CutoutV2AvatarStackContext {
	
	// MARK: - Model
	
	struct Model {
		let avatars: [CutoutV2AvatarData]
		let style: CutoutV2AvatarStyle
		let shouldCutout: Bool
		let showBorder: Bool
	}
	
	// MARK: - Layout
	
	struct Layout {
		var containerHeight: CGFloat = 0
		var avatarDiameter: CGFloat = 0
		var overlap: CGFloat = 0
		var totalWidth: CGFloat = 0
	}
	
	// MARK: - Interaction
	
	struct Interaction {
		var hasAppeared = false
	}
	
	// MARK: - Animation
	
	struct Animation {
		var animateIn = false
		var isRasterized = false
	}
	
	// MARK: - Stored
	
	let model: Model
	var layout = Layout()
	var interaction = Interaction()
	var animation = Animation()
	
	// MARK: - Init
	
	init(
		avatars: [CutoutV2AvatarData],
		style: CutoutV2AvatarStyle,
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
