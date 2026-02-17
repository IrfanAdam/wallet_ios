import SwiftUI

enum AvatarContent {
	case image(Image)
	case icon(Image)
}

struct AvatarData: Identifiable {
	let id = UUID()
	let content: AvatarContent
	let hasBorder: Bool
	let isCutout: Bool?

	init(content: AvatarContent, hasBorder: Bool = false, isCutout: Bool? = nil) {
		self.content = content
		self.hasBorder = hasBorder
		self.isCutout = isCutout
	}
}


struct AvatarStyle {
	let strokeWidth: CGFloat
	let strokeColor: Color
	let iconBackgroundColor: Color
	let stackBackgroundColor: Color
	let overlapRatio: CGFloat

	static let `default` = AvatarStyle(
		strokeWidth: 1.5,
		strokeColor: .blue,
		iconBackgroundColor: .white,
		stackBackgroundColor: .clear,
		overlapRatio: 0.2
	)
}
