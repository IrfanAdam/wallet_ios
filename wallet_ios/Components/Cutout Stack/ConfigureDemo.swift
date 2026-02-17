import SwiftUI

#Preview("Toolbar Full-Height Circles – Style Controls") {
	AvatarStyleStateDemo()
}

private let avatars: [AvatarData] = [
	AvatarData(content: .image(Image("LargeDP")), hasBorder: true),
	AvatarData(content: .icon(Image(systemName: "creditcard.fill")), hasBorder: true),
	AvatarData(content: .image(Image("LargeDP")))
]

struct AvatarStyleStateDemo: View {

	@State private var strokeWidth: CGFloat = 2
	@State private var overlapRatio: CGFloat = 0.2
	@State private var strokeColor: Color = .blue
	@State private var stackBackground: Color = .clear
	@State private var isAuxiliaryPlanePresented = false

	private var style: AvatarStyle {
		AvatarStyle(
			strokeWidth: strokeWidth,
			strokeColor: strokeColor,
			iconBackgroundColor: .white,
			stackBackgroundColor: stackBackground,
			overlapRatio: overlapRatio
		)
	}

	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				Spacer()

				FullHeightCirclesCutout(avatars: avatars, style: style)
					.frame(height: 150)
					.id("\(strokeWidth)-\(overlapRatio)-\(strokeColor)-\(stackBackground)")

				Text("Content Area").font(.headline)

				Button("Open Sheet") {
					isAuxiliaryPlanePresented.toggle()
				}

				Divider()

				VStack(spacing: 16) {
					VStack {
						Text("Stroke Width: \(strokeWidth, specifier: "%.1f")")
						Slider(value: $strokeWidth, in: 0...8)
					}
					VStack {
						Text("Overlap: \(overlapRatio, specifier: "%.2f")")
						Slider(value: $overlapRatio, in: 0...0.6)
					}
					HStack(spacing: 16) {
						Button("Toggle Color") {
							strokeColor = (strokeColor == .blue) ? .purple : .blue
						}
						Button("Toggle BG") {
							stackBackground = (stackBackground == .clear)
							? Color.black.opacity(0.1) : .clear
						}
					}
				}
				.padding(.horizontal)

				Spacer()
			}
			.padding()
			.navigationTitle("Style Demo")
		}
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				Text("Sheet Area")
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							FullHeightCirclesCutout(avatars: avatars, style: style)
								.id("\(strokeWidth)-\(overlapRatio)-\(strokeColor)-\(stackBackground)")
						}
					}
			}
			.presentationDetents([.medium, .large])
			.presentationDragIndicator(.visible)
		}
	}
}
