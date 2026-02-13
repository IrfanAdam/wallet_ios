import SwiftUI

// MARK: - CutoutV2 Models

enum CutoutV2AvatarContent {
	case image(Image)
	case icon(Image)
}

struct CutoutV2AvatarData: Identifiable {
	let id = UUID()
	let content: CutoutV2AvatarContent
	let hasBorder: Bool
	let forceCutout: Bool?
	
	init(
		content: CutoutV2AvatarContent,
		hasBorder: Bool = true,
		forceCutout: Bool? = nil
	) {
		self.content = content
		self.hasBorder = hasBorder
		self.forceCutout = forceCutout
	}
}

struct CutoutV2AvatarStyle {
	var strokeWidth: CGFloat = 1.5
	var strokeColor: Color = .blue
	var iconBackgroundColor: Color = .white
	var stackBackgroundColor: Color = .clear
	var overlapRatio: CGFloat = 0.25
}

