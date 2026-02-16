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
			FullHeightCirclesCutout(avatars: avatars)
			.onTapGesture { onBack() }
		} else if route == .levelOne {
			Button(action: onDismiss) {
				Label("Dismiss", systemImage: "chevron.down")
			}
		}
	}

	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(content: .image(Image("LargeDP"))),
			.init(content: .icon(Image(systemName: "arrow.up")))
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

private let avatars: [AvatarData] = [
	AvatarData(content: .image(Image("LargeDP"))),
	AvatarData(content: .image(Image("LargeDP"))),
	AvatarData(content: .icon(Image(systemName: "creditcard.fill")), hasBorder: true),
	AvatarData(content: .image(Image("LargeDP"))),
]
