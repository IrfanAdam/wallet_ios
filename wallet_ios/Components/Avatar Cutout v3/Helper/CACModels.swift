import SwiftUI

enum CutoutAvatarContent {
	case image(Image)
	case icon(Image)
}

struct CutoutAvatarData: Identifiable {
	
	let id = UUID()
	let content: CutoutAvatarContent
	let hasBorder: Bool
	let forceCutout: Bool?
	
	init(
		content: CutoutAvatarContent,
		hasBorder: Bool = true,
		forceCutout: Bool? = nil
	) {
		self.content = content
		self.hasBorder = hasBorder
		self.forceCutout = forceCutout
	}
}

struct CutoutAvatarStyle {
	
	var strokeWidth: CGFloat = 1.5
	var strokeColor: Color = .blue
	var iconBackgroundColor: Color = .white
	var stackBackgroundColor: Color = .clear
	var overlapRatio: CGFloat = 0.25
}
