import SwiftUI

struct AuxiliaryToolbar: ToolbarContent {
	let route: AuxiliaryRoute
	let onDismiss: () -> Void
	let onBack: () -> Void

	var body: some ToolbarContent {
		// LEADING
		ToolbarItem(placement: .topBarLeading) {
			if route == .levelTwo {
				Button(action: onBack) {
					AvatarStackView(circleSize: 42, shouldCutout: false)
				}
				.padding(.horizontal, -8)
			} else if route == .levelOne {
				Button(action: onDismiss) {
					Label("Dismiss", systemImage: "chevron.down")
				}
			}
		}

		// TRAILING
		ToolbarItem(placement: .topBarTrailing) {
			if route == .levelTwo {
				Button(action: onDismiss) {
					Image(systemName: "xmark")
				}
				.buttonStyle(.plain)
			}
		}
	}
}
