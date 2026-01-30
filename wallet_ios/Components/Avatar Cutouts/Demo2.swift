import SwiftUI

private struct ToolbarCutPreview: View {
	@State private var pillHeight: CGFloat = 0
	@State private var lastMeasuredHeight: CGFloat = 36
	@State private var shouldMeasure = true

	let avatars: [AvatarData]

	var body: some View {
		NavigationStack {
			Text("Avatar Stack View")
				.toolbar {

					// 👇 render probe only while height is increasing
					if shouldMeasure {
						ToolbarItem(placement: .topBarLeading) {
							ToolbarHeightProbe { newHeight in
								guard newHeight > lastMeasuredHeight else {
									shouldMeasure = false
									return
								}

								lastMeasuredHeight = newHeight
								pillHeight = newHeight
							}
						}
					}

					ToolbarItemGroup(placement: .topBarLeading) {
						AvatarStackView(
							avatars: avatars,
							circleSize: pillHeight
						)
						.background(
							Capsule()
								.fill(Color.white.opacity(0.94))
						)
					}
				}
		}
	}
}

private struct ToolbarHeightProbe: View {
	let onMeasure: (CGFloat) -> Void

	var body: some View {
		Color.clear
			.frame(width: 1) // minimal footprint
			.background(
				GeometryReader { geo in
					Color.clear
						.onAppear {
							onMeasure(geo.size.height)
						}
						.onChange(of: geo.size.height) { _, newValue in
							onMeasure(newValue)
						}
				}
			)
			.hidden() // 👈 important: keeps layout, hides visually
	}
}


#Preview {
	ToolbarCutPreview(
		avatars: [
			AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
			AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: true)
		]
	)
}
