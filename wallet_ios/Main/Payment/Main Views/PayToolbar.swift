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
		AvatarStackView(
			avatars: [
				AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
				AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
			],
			shouldCutout: true,
			showBorder: true
		)
		.onTapGesture { dismiss() }
	}
}
