import SwiftUI

#Preview("Toolbar Full-Height Circles – Auto Width") {
	ToolbarFullHeightCirclesDemo()
}

private let avatars: [AvatarData] = [
	AvatarData(content: .image(Image("LargeDP"))),
	AvatarData(content: .image(Image("LargeDP"))),
	AvatarData(content: .icon(Image(systemName: "creditcard.fill")), hasBorder: true),
	AvatarData(content: .image(Image("LargeDP"))),
]

struct ToolbarFullHeightCirclesDemo: View {
	@State private var isAuxiliaryPlanePresented = false
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				FullHeightCirclesCutout(avatars: avatars).frame(height: 90)
				Text("Content Area")
				Button("Open Sheet") {
					isAuxiliaryPlanePresented.toggle()
				}
				Spacer()
			}
			.navigationTitle("Demo")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					FullHeightCirclesCutout(avatars: avatars)
				}
			}
		}
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				Text("Sheet Area")
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							FullHeightCirclesCutout(avatars: avatars)
						}
					}
			}
			.presentationDetents([.medium, .large])   // 👈 This is the key
			.presentationDragIndicator(.visible)
		}
	}
}
