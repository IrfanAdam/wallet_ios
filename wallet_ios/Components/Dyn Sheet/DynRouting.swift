import SwiftUI

// MARK: - Routing
enum AuxiliaryRoute {
	case levelOne
	case levelTwo
}

// MARK: - Flow Semantics
extension AuxiliaryRoute {

	/// Previous route in the flow
	var previous: AuxiliaryRoute? {
		switch self {
		case .levelOne:
			return nil
		case .levelTwo:
			return .levelOne
		}
	}

	/// Next route in the flow
	var next: AuxiliaryRoute? {
		switch self {
		case .levelOne:
			return .levelTwo
		case .levelTwo:
			return nil
		}
	}
}
