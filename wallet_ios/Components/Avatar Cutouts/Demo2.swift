import SwiftUI

private struct ToolbarCutPreview: View {
	let avatars: [AvatarData]
	
	var body: some View {
		NavigationStack {
			Text("Avatar Stack View")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					AvatarStackView(
						avatars: avatars,
						shouldCutout: true,
						showBorder: true
					)
					.onTapGesture {
						print("📌 ToolbarItem tapped!")
					}
				}
			}
			
			VStack{
				AvatarStackView(avatars: avatars, shouldCutout: true, showBorder: true)
			}.frame(height: 180)
		}
	}
}

#Preview {
	ToolbarCutPreview(
		avatars: [
			AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
			AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
		]
	)
}
