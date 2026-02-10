import SwiftUI

private struct ToolbarCutPreview2: View {
	let avatars: [AvatarData]

	@State private var cutout = true
	@State private var showBorder = true
	@State private var overlap: CGFloat = 0.25
	@State private var height: CGFloat = 48
	@State private var borderWidth: CGFloat = 1.5

	var body: some View {
		NavigationStack {
			Text("Avatar Stack View")
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						CutoutV2AvatarStack(
							avatars: demoAvatars,
							style: .init(
								strokeWidth: borderWidth,
								strokeColor: .blue,
								iconBackgroundColor: .white,
								stackBackgroundColor: .black,
								overlapRatio: overlap
							),
							shouldCutout: true,
							showBorder: showBorder
						)
						.onTapGesture {
							print("📌 ToolbarItem tapped!")
						}
					}
				}

			CutoutV2AvatarStack(
				avatars: demoAvatars,
				style: .init(
					strokeWidth: 8,
					strokeColor: .blue,
					iconBackgroundColor: .white,
					stackBackgroundColor: .gray,
					overlapRatio: overlap
				),
				shouldCutout: cutout,
				showBorder: showBorder
			).frame(height: 160)
		}
	}

	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(content: .icon(Image(systemName: "person.fill"))),
			.init(content: .image(Image("LargeDP"))),
			.init(content: .icon(Image(systemName: "star.fill")))
		]
	}
}

#Preview {
	ToolbarCutPreview2(
		avatars: [
			AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
			AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
		]
	)
}
