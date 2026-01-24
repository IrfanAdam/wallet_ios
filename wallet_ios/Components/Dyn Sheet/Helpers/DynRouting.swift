import SwiftUI

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
