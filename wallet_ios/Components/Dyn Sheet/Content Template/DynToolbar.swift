import SwiftUI

struct AuxiliaryToolbar: ToolbarContent {
	let route: AuxiliaryRoute
	let onDismiss: () -> Void
	let onBack: () -> Void
	
	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {leading}
		ToolbarItem(placement: .topBarTrailing) {trailing}
	}
}

private extension AuxiliaryToolbar {
	@ViewBuilder
	var leading: some View {
		if route == .levelTwo {
//			CutoutV2AvatarStack(
//				avatars: demoAvatars,
//				style: .init(
//					strokeWidth: 1.5,
//					strokeColor: .blue,
//					iconBackgroundColor: .white,
//					stackBackgroundColor: .black,
//					overlapRatio: 0.12
//				),
//				shouldCutout: true,
//				showBorder: false
//			)
			FullHeightCirclesCutout().drawingGroup()
			.onTapGesture { onBack() }
		} else if route == .levelOne {
			Button(action: onDismiss) {
				Label("Dismiss", systemImage: "chevron.down")
			}
		}
	}

	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(
				content: .image(Image("LargeDP"))
			),
			.init(
				content: .icon(Image(systemName: "arrow.up"))
			)
		]
	}

	@ViewBuilder
	var trailing: some View {
		if route == .levelTwo {
			Button(action: onDismiss) {
				Image(systemName: "xmark")
			}
			.buttonStyle(.plain)
		}
	}
}
