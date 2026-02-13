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
			Color.blue.ignoresSafeArea()
			VStack {
				Text("Avatar Stack View")
				CutoutV2AvatarStack(
					avatars: demoAvatars,
					style: .init(
						strokeWidth: 6,
						strokeColor: .blue,
						iconBackgroundColor: .white,
						stackBackgroundColor: .gray,
						overlapRatio: 0.2
					),
					shouldCutout: cutout,
					showBorder: showBorder
				).frame(height: 160)
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					CutoutV2AvatarStack(
						avatars: demoAvatars,
						style: .init(
							strokeWidth: 1.5,
							strokeColor: .blue,
							iconBackgroundColor: .white,
							stackBackgroundColor: .black,
							overlapRatio: 0.2
						),
						shouldCutout: true,
						showBorder: false
					)
					.onTapGesture {
						print("📌 ToolbarItem tapped!")
					}
				}
			}
		}
	}

	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(content: .icon(Image(systemName: "person.fill"))),
			.init(content: .image(Image("LargeDP"))),
			.init(content: .icon(Image("ph_credit-card-bold")))
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
