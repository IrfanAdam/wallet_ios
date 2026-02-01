import SwiftUI

struct AuxiliarySheetCoordinator {
	let state: AuxiliaryContentState
	
	func navigateBack() {
		withAnimation(.easeInOut(duration: 0.35)) {
			guard let previous = RouteNavigator.previous(state.route) else { return }
			state.route = previous
		}
	}
}

enum AuxiliaryRoute : CaseIterable {
	case levelOne
	case levelTwo
}

enum AuxiliarySheetRouter {
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
}

