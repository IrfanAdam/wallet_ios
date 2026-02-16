import SwiftUI

#Preview("Cutout Avatar Stack") {
	NavigationStack {
		VStack(spacing: 40) {
//			CutoutAvatarStack(
//				avatars: previewAvatars,
//				style: previewStyle,
//				shouldCutout: true,
//				showBorder: true
//			)
		}
		.frame(height: 120)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				CutoutAvatarStack(
					avatars: previewAvatars,
					style: previewStyle,
					shouldCutout: true,
					showBorder: true
				)
//				FullHeightCirclesCutout()
			}
		}
	}
}

private let previewStyle = CutoutAvatarStyle(
	strokeWidth: 8,
	strokeColor: .blue,
	iconBackgroundColor: .white,
	stackBackgroundColor: .gray,
	overlapRatio: 0.3
)

private let previewAvatars: [CutoutAvatarData] = [
	.init(content: .icon(Image(systemName: "person.fill"))),
	.init(content: .image(Image("LargeDP"))),
	.init(content: .icon(Image(systemName: "person.fill"))),
	.init(content: .icon(Image(systemName: "person.fill")))
]
