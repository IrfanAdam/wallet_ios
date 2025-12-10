import SwiftUI

struct InitiatePayment: View {
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("Payment Screen")
					.font(.title)
					.foregroundColor(.primary)

				// Add UI here later
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			).navigationTitle("Payment To")
				.navigationBarBackButtonHidden(true)
				.navigationBarTitleDisplayMode(.large)
				.toolbar { toolbarContent }
		}
	}

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		// Remove default back Chevron
		ToolbarItem(placement: .topBarLeading) {
			ZStack() {
				HStack(spacing: overlapSpacing) {
					CutoutAvatarView()
					CutoutAvatarView()
					StrokedIconView()
				}
				.overlay(
					Capsule()
						.stroke(Color.white, lineWidth: 2)
				)
				.compositingGroup()
			}.onTapGesture {
				dismiss()
			}
			.background(.ultraThinMaterial)         // glass-like look
			.clipShape(Capsule())
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") {}.onTapGesture {
				dismiss()
			}
		}
	}

	struct ProfileImage: View {
		let imageName: String
		let size: CGFloat = 36

		var body: some View {
			Image(imageName)                 // must exist in Assets.xcassets
				.resizable()
				.scaledToFill()
				.frame(width: size, height: size)
				.clipShape(Circle())
		}
	}

}

#Preview {
	InitiatePayment()
}
