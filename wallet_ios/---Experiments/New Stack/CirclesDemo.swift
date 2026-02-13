import SwiftUI

#Preview("Toolbar Full-Height Circles – Auto Width") {
	ToolbarFullHeightCirclesDemo()
}

struct ToolbarFullHeightCirclesDemo: View {
	@State private var isAuxiliaryPlanePresented = false
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Text("Content Area")
				Button("Open Sheet") {
					isAuxiliaryPlanePresented.toggle()
				}
				Spacer()
			}
			.navigationTitle("Demo")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					FullHeightCirclesCutout().drawingGroup()
				}
			}
		}
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				Text("Sheet Area")
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							FullHeightCirclesCutout()
						}
					}
			}
			.presentationDetents([.medium, .large])   // 👈 This is the key
			.presentationDragIndicator(.visible)
		}
	}
}
