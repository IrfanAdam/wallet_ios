import SwiftUI

enum AuxiliarySheetBuilders {
	@ViewBuilder
	static func routedContent(
		route: AuxiliaryRoute
	) -> some View {
		switch route {
		case .levelOne:
			LevelOneView().transition(.blurReplace)
		case .levelTwo:
			LevelTwoView().transition(.blurReplace)
		}
	}
	
	static func toolbar(
		route: AuxiliaryRoute,
		onDismiss: @escaping () -> Void,
		onBack: @escaping () -> Void
	) -> some ToolbarContent {
		AuxiliaryToolbar(
			route: route,
			onDismiss: onDismiss,
			onBack: onBack
		)
	}
}
