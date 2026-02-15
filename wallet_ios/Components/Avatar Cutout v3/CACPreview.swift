import SwiftUI

#Preview("Cutout Avatar Stack") {
	
	VStack(spacing: 40) {
		
		CutoutAvatarStack(
			avatars: previewAvatars,
			style: previewStyle,
			shouldCutout: true,
			showBorder: true
		)
		.frame(height: 120)
		
		CutoutAvatarStack(
			avatars: previewAvatars,
			style: previewStyle,
			shouldCutout: false,
			showBorder: false
		)
		.frame(height: 120)
	}
	.padding()
	.background(Color.gray.opacity(0.15))
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
	.init(content: .icon(Image(systemName: "person.fill"))),
	.init(content: .icon(Image(systemName: "person.fill"))),
	.init(content: .icon(Image(systemName: "person.fill")))
]
