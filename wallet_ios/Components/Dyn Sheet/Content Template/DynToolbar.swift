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
			AvatarStackView(
				avatars: [
					AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
					AvatarData(content: .icon(Image(systemName: "arrow.up")), hasBorder: false)
				],
				shouldCutout: false
			)
			.onTapGesture { onBack() }
		} else if route == .levelOne {
			Button(action: onDismiss) {
				Label("Dismiss", systemImage: "chevron.down")
			}
		}
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
