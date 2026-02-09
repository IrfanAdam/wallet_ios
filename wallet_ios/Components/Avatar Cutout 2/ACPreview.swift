import SwiftUI

#Preview("CutoutV2 – Real Cutout") {
	CutoutV2PreviewPlayground()
}

private struct CutoutV2PreviewPlayground: View {
	@State private var cutout = true
	@State private var showBorder = true
	@State private var overlap: CGFloat = 0.25
	@State private var height: CGFloat = 48
	@State private var borderWidth: CGFloat = 1.5

	var body: some View {
		ZStack {
			Color.green.opacity(0.25) // ← visible through cutout
				.ignoresSafeArea()

			VStack(spacing: 24) {
				CutoutV2AvatarStack(
					avatars: demoAvatars,
					style: .init(
						strokeWidth: borderWidth,
						strokeColor: .blue,
						iconBackgroundColor: .white,
						stackBackgroundColor: .gray,
						overlapRatio: overlap
					),
					shouldCutout: cutout,
					showBorder: showBorder,
					avatarDiameter: height   // 👈 same source
				)

				controls
			}
			.padding()
		}
	}

	private var controls: some View {
		VStack(alignment: .leading, spacing: 12) {
			Toggle("Cutout Enabled", isOn: $cutout)
			Toggle("Show Border", isOn: $showBorder)

			HStack {
				Text("Overlap")
				Slider(value: $overlap, in: -0.5...1)
			}

			HStack {
				Text("Height")
				Slider(value: $height, in: 32...90)
			}

			HStack {
				Text("Border")
				Slider(value: $borderWidth, in: 2...10)
			}
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
