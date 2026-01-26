import SwiftUI

struct AuxiliarySheetCoordinator {
	let state: AuxiliarySheetState
	func navigateBack() {
		withAnimation(.easeInOut(duration: 0.35)) {
			guard let previous = state.route.previous else { return }
			state.route = previous
		}
	}
}

enum AuxiliaryRoute {
	case levelOne
	case levelTwo
}

extension AuxiliaryRoute {
	var previous: AuxiliaryRoute? {
		switch self {
		case .levelOne:
			return nil
		case .levelTwo:
			return .levelOne
		}
	}
	var next: AuxiliaryRoute? {
		switch self {
		case .levelOne:
			return .levelTwo
		case .levelTwo:
			return nil
		}
	}
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
