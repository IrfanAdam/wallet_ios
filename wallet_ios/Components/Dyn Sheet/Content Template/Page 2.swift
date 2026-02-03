import SwiftUI

struct LevelTwoView: View {
	@Environment(AuxiliaryContentState.self)
	private var routeState
	
	var body: some View {
		AuxiliaryPlaneContainer {
			VStack(spacing: 12) {
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
				Text("You can test any content style here")
			}
			.background(Color.gray.opacity(0.2))
		}
	}
}
