import SwiftUI

// MARK: - Toolbar Root
struct InitiatePaymentToolbar: ToolbarContent {
	let dismiss: DismissAction
	let sheetControl: SheetControl
	
	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			ToolbarLeadingContent(dismiss: dismiss)
		}
		
		ToolbarSpacer(.flexible)
		
		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") {
				sheetControl.dismiss()
			}
		}
	}
}

// MARK: - Toolbar Leading Content
private struct ToolbarLeadingContent: View {
	let dismiss: DismissAction
	
	var body: some View {
		FullHeightCirclesCutout(avatars: avatars, style: .default)
		.onTapGesture { dismiss() }
	}

	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .image(Image("LargeDP")), hasBorder: true),
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image(systemName: "arrow.up")), hasBorder: true)
	]
}
