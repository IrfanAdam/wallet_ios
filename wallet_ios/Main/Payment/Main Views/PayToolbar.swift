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
		CutoutV2AvatarStack(
			avatars: demoAvatars,
			style: .init(
				strokeWidth: 1.5,
				strokeColor: .blue,
				iconBackgroundColor: .white,
				stackBackgroundColor: .black,
				overlapRatio: 0.12
			),
			shouldCutout: true,
			showBorder: false
		)
		.onTapGesture { dismiss() }
	}

	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(content: .image(Image("LargeDP"))),
			.init(content: .icon(Image("ph_credit-card-bold")))
		]
	}
}
